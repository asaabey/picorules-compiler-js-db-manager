import { describe, it, expect, vi, beforeEach } from 'vitest';
import { BatchExecutor, type DatabaseConnection } from '../../../src/execution/batch-executor.js';
import type { CompilationManifest } from 'picorules-compiler-js-core';

describe('BatchExecutor', () => {
  let mockConnection: DatabaseConnection;

  beforeEach(() => {
    mockConnection = {
      execute: vi.fn().mockResolvedValue(undefined),
      executeQuery: vi.fn().mockResolvedValue({ recordset: [{ cnt: 10 }] }),
      cleanup: vi.fn().mockResolvedValue(undefined),
    };
  });

  const createManifest = (entries: Partial<CompilationManifest['entries'][0]>[]): CompilationManifest => ({
    version: '1.0.0',
    dialect: 'mssql',
    compiledAt: new Date().toISOString(),
    totalRuleblocks: entries.length,
    entries: entries.map((e, i) => ({
      ruleblockId: e.ruleblockId || `rb${i}`,
      executionOrder: e.executionOrder ?? i,
      targetTable: e.targetTable || `SROUT_rb${i}`,
      dependencies: e.dependencies || [],
      outputVariables: e.outputVariables || [],
      sqlIndex: e.sqlIndex ?? i,
    })),
    dependencyGraph: {},
  });

  describe('execute', () => {
    it('should execute all ruleblocks in manifest order', async () => {
      const manifest = createManifest([
        { ruleblockId: 'base', dependencies: [] },
        { ruleblockId: 'derived', dependencies: ['base'] },
      ]);
      const sql = ['-- SQL for base', '-- SQL for derived'];

      const executor = new BatchExecutor(mockConnection, { verbose: false });
      const result = await executor.execute(manifest, sql);

      expect(result.success).toBe(true);
      expect(result.executedCount).toBe(2);
      expect(result.successCount).toBe(2);
      expect(result.failedCount).toBe(0);
      expect(result.results).toHaveLength(2);
      expect(result.results[0].ruleblockId).toBe('base');
      expect(result.results[1].ruleblockId).toBe('derived');
    });

    it('should clean up tables before execution', async () => {
      const manifest = createManifest([
        { ruleblockId: 'test', targetTable: 'SROUT_test' },
      ]);
      const sql = ['-- SQL'];

      const executor = new BatchExecutor(mockConnection, { verbose: false, cleanupTables: true });
      await executor.execute(manifest, sql);

      expect(mockConnection.cleanup).toHaveBeenCalledWith('SROUT_test');
    });

    it('should not clean up tables when cleanupTables is false', async () => {
      const manifest = createManifest([{ ruleblockId: 'test' }]);
      const sql = ['-- SQL'];

      const executor = new BatchExecutor(mockConnection, { verbose: false, cleanupTables: false });
      await executor.execute(manifest, sql);

      expect(mockConnection.cleanup).not.toHaveBeenCalled();
    });

    it('should stop on first failure when stopOnFailure is true', async () => {
      mockConnection.execute = vi.fn()
        .mockResolvedValueOnce(undefined)
        .mockRejectedValueOnce(new Error('SQL error'))
        .mockResolvedValueOnce(undefined);

      const manifest = createManifest([
        { ruleblockId: 'a', dependencies: [] },
        { ruleblockId: 'b', dependencies: ['a'] },
        { ruleblockId: 'c', dependencies: ['b'] },
      ]);
      const sql = ['-- a', '-- b', '-- c'];

      const executor = new BatchExecutor(mockConnection, { verbose: false, stopOnFailure: true });
      const result = await executor.execute(manifest, sql);

      expect(result.success).toBe(false);
      expect(result.executedCount).toBe(2);
      expect(result.successCount).toBe(1);
      expect(result.failedCount).toBe(1);
      expect(result.firstFailedIndex).toBe(1);
      expect(result.skippedRuleblocks).toContain('c');
    });

    it('should continue on failure when stopOnFailure is false', async () => {
      mockConnection.execute = vi.fn()
        .mockResolvedValueOnce(undefined)
        .mockRejectedValueOnce(new Error('SQL error'))
        .mockResolvedValueOnce(undefined);

      const manifest = createManifest([
        { ruleblockId: 'a', dependencies: [] },
        { ruleblockId: 'b', dependencies: [] },  // Independent, no dep on 'a'
        { ruleblockId: 'c', dependencies: [] },
      ]);
      const sql = ['-- a', '-- b', '-- c'];

      const executor = new BatchExecutor(mockConnection, { verbose: false, stopOnFailure: false });
      const result = await executor.execute(manifest, sql);

      expect(result.success).toBe(false);
      expect(result.executedCount).toBe(3);
      expect(result.successCount).toBe(2);
      expect(result.failedCount).toBe(1);
    });

    it('should skip ruleblocks with unsatisfied dependencies', async () => {
      mockConnection.execute = vi.fn()
        .mockRejectedValueOnce(new Error('SQL error'));

      const manifest = createManifest([
        { ruleblockId: 'base', dependencies: [] },
        { ruleblockId: 'derived', dependencies: ['base'] },
      ]);
      const sql = ['-- base', '-- derived'];

      const executor = new BatchExecutor(mockConnection, { verbose: false, stopOnFailure: false });
      const result = await executor.execute(manifest, sql);

      // 'derived' should be skipped because 'base' failed
      expect(result.skippedRuleblocks).toContain('derived');
    });

    it('should track row counts for each ruleblock', async () => {
      mockConnection.executeQuery = vi.fn()
        .mockResolvedValueOnce({ recordset: [{ cnt: 100 }] })
        .mockResolvedValueOnce({ recordset: [{ cnt: 50 }] });

      const manifest = createManifest([
        { ruleblockId: 'a' },
        { ruleblockId: 'b' },
      ]);
      const sql = ['-- a', '-- b'];

      const executor = new BatchExecutor(mockConnection, { verbose: false });
      const result = await executor.execute(manifest, sql);

      expect(result.results[0].rowCount).toBe(100);
      expect(result.results[1].rowCount).toBe(50);
    });

    it('should use sqlIndex to get correct SQL', async () => {
      const manifest = createManifest([
        { ruleblockId: 'first', sqlIndex: 1 },
        { ruleblockId: 'second', sqlIndex: 0 },
      ]);
      const sql = ['-- SQL for second', '-- SQL for first'];

      const executor = new BatchExecutor(mockConnection, { verbose: false });
      await executor.execute(manifest, sql);

      expect(mockConnection.execute).toHaveBeenNthCalledWith(1, '-- SQL for first');
      expect(mockConnection.execute).toHaveBeenNthCalledWith(2, '-- SQL for second');
    });

    it('should record execution time for each ruleblock', async () => {
      const manifest = createManifest([{ ruleblockId: 'test' }]);
      const sql = ['-- SQL'];

      const executor = new BatchExecutor(mockConnection, { verbose: false });
      const result = await executor.execute(manifest, sql);

      expect(result.results[0].executionTimeMs).toBeGreaterThanOrEqual(0);
      expect(result.totalExecutionTimeMs).toBeGreaterThanOrEqual(0);
    });

    it('should handle empty manifest', async () => {
      const manifest = createManifest([]);
      const sql: string[] = [];

      const executor = new BatchExecutor(mockConnection, { verbose: false });
      const result = await executor.execute(manifest, sql);

      expect(result.success).toBe(true);
      expect(result.executedCount).toBe(0);
      expect(result.results).toHaveLength(0);
    });

    it('should handle Oracle-style query results', async () => {
      mockConnection.executeQuery = vi.fn()
        .mockResolvedValue({ rows: [{ CNT: 42 }] });

      const manifest = createManifest([{ ruleblockId: 'test' }]);
      const sql = ['-- SQL'];

      const executor = new BatchExecutor(mockConnection, { verbose: false });
      const result = await executor.execute(manifest, sql);

      expect(result.results[0].rowCount).toBe(42);
    });
  });
});
