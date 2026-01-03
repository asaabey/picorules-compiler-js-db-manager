import type { CompilationManifest, ManifestEntry } from 'picorules-compiler-js-core';

/**
 * Result for a single ruleblock execution
 */
export interface RuleblockExecutionResult {
  /** Ruleblock identifier */
  ruleblockId: string;
  /** Whether execution succeeded */
  success: boolean;
  /** Execution time in milliseconds */
  executionTimeMs: number;
  /** Number of rows in output table */
  rowCount: number;
  /** Target table name */
  targetTable: string;
  /** Error message if failed */
  error?: string;
  /** Dependencies that were required */
  dependencies: string[];
}

/**
 * Result for batch execution of multiple ruleblocks
 */
export interface BatchExecutionResult {
  /** Whether all ruleblocks executed successfully */
  success: boolean;
  /** Total execution time in milliseconds */
  totalExecutionTimeMs: number;
  /** Number of ruleblocks executed */
  executedCount: number;
  /** Number of ruleblocks that succeeded */
  successCount: number;
  /** Number of ruleblocks that failed */
  failedCount: number;
  /** Results for each ruleblock in execution order */
  results: RuleblockExecutionResult[];
  /** Index of first failed ruleblock (-1 if none) */
  firstFailedIndex: number;
  /** Ruleblocks that were skipped due to dependency failure */
  skippedRuleblocks: string[];
}

/**
 * Options for batch execution
 */
export interface BatchExecutionOptions {
  /** Stop on first failure (default: true) */
  stopOnFailure?: boolean;
  /** Log progress to console (default: true) */
  verbose?: boolean;
  /** Clean up existing tables before execution (default: true) */
  cleanupTables?: boolean;
}

/**
 * Database connection interface required by BatchExecutor
 */
export interface DatabaseConnection {
  /** Execute SQL statement (no result expected) */
  execute(sql: string): Promise<void>;
  /** Execute query and return results */
  executeQuery(sql: string): Promise<{ recordset?: any[]; rows?: any[] }>;
  /** Clean up (drop) a table */
  cleanup(tableName: string): Promise<void>;
}

const DEFAULT_OPTIONS: Required<BatchExecutionOptions> = {
  stopOnFailure: true,
  verbose: true,
  cleanupTables: true,
};

/**
 * Executes compiled SQL statements in dependency order using the manifest
 */
export class BatchExecutor {
  constructor(
    private connection: DatabaseConnection,
    private options: BatchExecutionOptions = {}
  ) {
    this.options = { ...DEFAULT_OPTIONS, ...options };
  }

  /**
   * Execute a batch of SQL statements using the manifest for ordering
   *
   * @param manifest - Compilation manifest with execution order
   * @param sqlStatements - Array of SQL statements (indexed by manifest.entries[i].sqlIndex)
   * @returns BatchExecutionResult with details for each ruleblock
   */
  async execute(
    manifest: CompilationManifest,
    sqlStatements: string[]
  ): Promise<BatchExecutionResult> {
    const startTime = Date.now();
    const results: RuleblockExecutionResult[] = [];
    const completedRuleblocks = new Set<string>();
    const skippedRuleblocks: string[] = [];
    let firstFailedIndex = -1;

    if (this.options.verbose) {
      console.log(`\n📦 Starting batch execution of ${manifest.totalRuleblocks} ruleblocks`);
      console.log(`   Dialect: ${manifest.dialect}`);
      console.log(`   Compiled at: ${manifest.compiledAt}\n`);
    }

    // Clean up existing tables if requested
    if (this.options.cleanupTables) {
      await this.cleanupAllTables(manifest.entries);
    }

    // Execute in manifest order (already topologically sorted)
    for (let i = 0; i < manifest.entries.length; i++) {
      const entry = manifest.entries[i];

      // Check if dependencies are satisfied
      const unsatisfiedDeps = this.getUnsatisfiedDependencies(entry, completedRuleblocks);
      if (unsatisfiedDeps.length > 0) {
        if (this.options.verbose) {
          console.log(`⏭️  Skipping ${entry.ruleblockId} - missing dependencies: ${unsatisfiedDeps.join(', ')}`);
        }
        skippedRuleblocks.push(entry.ruleblockId);
        continue;
      }

      // Get the SQL for this ruleblock
      const sql = sqlStatements[entry.sqlIndex];
      if (!sql) {
        const errorResult = this.createErrorResult(
          entry,
          `No SQL found at index ${entry.sqlIndex}`
        );
        results.push(errorResult);
        if (firstFailedIndex === -1) firstFailedIndex = i;
        if (this.options.stopOnFailure) break;
        continue;
      }

      // Execute the ruleblock
      const result = await this.executeRuleblock(entry, sql);
      results.push(result);

      if (result.success) {
        completedRuleblocks.add(entry.ruleblockId);
      } else {
        if (firstFailedIndex === -1) firstFailedIndex = i;
        if (this.options.stopOnFailure) {
          if (this.options.verbose) {
            console.log(`\n🛑 Stopping execution due to failure`);
          }
          // Mark remaining ruleblocks as skipped
          for (let j = i + 1; j < manifest.entries.length; j++) {
            skippedRuleblocks.push(manifest.entries[j].ruleblockId);
          }
          break;
        }
      }
    }

    const totalTime = Date.now() - startTime;
    const successCount = results.filter(r => r.success).length;

    if (this.options.verbose) {
      console.log(`\n📊 Batch execution complete`);
      console.log(`   Total time: ${totalTime}ms`);
      console.log(`   Success: ${successCount}/${results.length}`);
      if (skippedRuleblocks.length > 0) {
        console.log(`   Skipped: ${skippedRuleblocks.length}`);
      }
    }

    return {
      success: firstFailedIndex === -1 && skippedRuleblocks.length === 0,
      totalExecutionTimeMs: totalTime,
      executedCount: results.length,
      successCount,
      failedCount: results.length - successCount,
      results,
      firstFailedIndex,
      skippedRuleblocks,
    };
  }

  /**
   * Execute a single ruleblock
   */
  private async executeRuleblock(
    entry: ManifestEntry,
    sql: string
  ): Promise<RuleblockExecutionResult> {
    const startTime = Date.now();

    if (this.options.verbose) {
      console.log(`\n🔧 Executing ${entry.ruleblockId} (order: ${entry.executionOrder})`);
      if (entry.dependencies.length > 0) {
        console.log(`   Dependencies: ${entry.dependencies.join(', ')}`);
      }
    }

    try {
      // Execute the SQL
      await this.connection.execute(sql);
      const executionTime = Date.now() - startTime;

      // Get row count from the output table
      const rowCount = await this.getRowCount(entry.targetTable);

      if (this.options.verbose) {
        console.log(`   ✅ Success - ${rowCount} rows (${executionTime}ms)`);
      }

      return {
        ruleblockId: entry.ruleblockId,
        success: true,
        executionTimeMs: executionTime,
        rowCount,
        targetTable: entry.targetTable,
        dependencies: entry.dependencies,
      };
    } catch (error) {
      const executionTime = Date.now() - startTime;
      const errorMessage = error instanceof Error ? error.message : String(error);

      if (this.options.verbose) {
        console.log(`   ❌ Failed: ${errorMessage}`);
      }

      return {
        ruleblockId: entry.ruleblockId,
        success: false,
        executionTimeMs: executionTime,
        rowCount: 0,
        targetTable: entry.targetTable,
        dependencies: entry.dependencies,
        error: errorMessage,
      };
    }
  }

  /**
   * Clean up all output tables before execution
   */
  private async cleanupAllTables(entries: ManifestEntry[]): Promise<void> {
    if (this.options.verbose) {
      console.log(`🧹 Cleaning up ${entries.length} tables...`);
    }

    for (const entry of entries) {
      try {
        await this.connection.cleanup(entry.targetTable);
      } catch {
        // Ignore cleanup errors (table might not exist)
      }
    }
  }

  /**
   * Get row count from a table
   */
  private async getRowCount(tableName: string): Promise<number> {
    try {
      const result = await this.connection.executeQuery(
        `SELECT COUNT(*) as cnt FROM ${tableName}`
      );

      // Handle both MSSQL (recordset) and Oracle (rows) result formats
      if (result.recordset && result.recordset[0]) {
        return result.recordset[0].cnt || 0;
      }
      if (result.rows && result.rows[0]) {
        return result.rows[0]['CNT'] || result.rows[0]['cnt'] || 0;
      }
      return 0;
    } catch {
      return 0;
    }
  }

  /**
   * Check which dependencies are not yet satisfied
   */
  private getUnsatisfiedDependencies(
    entry: ManifestEntry,
    completedRuleblocks: Set<string>
  ): string[] {
    return entry.dependencies.filter(dep => !completedRuleblocks.has(dep));
  }

  /**
   * Create an error result for a ruleblock
   */
  private createErrorResult(
    entry: ManifestEntry,
    error: string
  ): RuleblockExecutionResult {
    return {
      ruleblockId: entry.ruleblockId,
      success: false,
      executionTimeMs: 0,
      rowCount: 0,
      targetTable: entry.targetTable,
      dependencies: entry.dependencies,
      error,
    };
  }
}
