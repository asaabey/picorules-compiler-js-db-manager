import { compile, Dialect, type RuleblockInput } from 'picorules-compiler-js-core';
import { OracleConnection } from '../db/oracle-connection.js';

export interface ValidationResult {
  ruleblockName: string;
  success: boolean;
  compilationTime: number;
  executionTime: number;
  rowCount: number;
  error?: string;
  sql?: string;
}

export class OracleValidator {
  constructor(private connection: OracleConnection) {}

  async validateRuleblock(ruleblock: RuleblockInput): Promise<ValidationResult> {
    const startTime = Date.now();

    try {
      // Compile the ruleblock
      const compileStart = Date.now();
      const result = compile([ruleblock], { dialect: Dialect.ORACLE });
      const compilationTime = Date.now() - compileStart;

      if (!result.success) {
        return {
          ruleblockName: ruleblock.name,
          success: false,
          compilationTime,
          executionTime: 0,
          rowCount: 0,
          error: result.errors.map(e => e.message).join('; '),
        };
      }

      const sql = result.sql[0];
      console.log(`\n📝 Compiled ${ruleblock.name} (${compilationTime}ms)`);

      // Clean up any existing table
      const tableName = `ROUT_${ruleblock.name.toUpperCase()}`;
      await this.connection.cleanup(tableName);

      // Execute the SQL
      const execStart = Date.now();
      await this.connection.execute(sql);
      const executionTime = Date.now() - execStart;

      // Query the results to verify
      const queryResult = await this.connection.executeQuery(
        `SELECT COUNT(*) as cnt FROM ${tableName}`
      );
      const rowCount = queryResult.rows?.[0]?.['CNT'] as number || 0;

      console.log(`✅ Executed successfully - ${rowCount} rows (${executionTime}ms)`);

      // Also show sample data
      const sampleResult = await this.connection.executeQuery(
        `SELECT * FROM ${tableName} WHERE ROWNUM <= 5`
      );
      if (sampleResult.rows && sampleResult.rows.length > 0) {
        console.log('📊 Sample data:', JSON.stringify(sampleResult.rows, null, 2));
      }

      return {
        ruleblockName: ruleblock.name,
        success: true,
        compilationTime,
        executionTime,
        rowCount,
        sql,
      };
    } catch (error) {
      return {
        ruleblockName: ruleblock.name,
        success: false,
        compilationTime: Date.now() - startTime,
        executionTime: 0,
        rowCount: 0,
        error: error instanceof Error ? error.message : String(error),
      };
    }
  }

  async validateMultiple(ruleblocks: RuleblockInput[]): Promise<ValidationResult[]> {
    const results: ValidationResult[] = [];

    for (const ruleblock of ruleblocks) {
      const result = await this.validateRuleblock(ruleblock);
      results.push(result);

      if (!result.success) {
        console.error(`\n❌ ${ruleblock.name} failed:`, result.error);
      }
    }

    return results;
  }

  async validateWithDependencies(ruleblocks: RuleblockInput[]): Promise<ValidationResult> {
    const startTime = Date.now();

    try {
      // Compile all ruleblocks together (handles dependencies)
      const compileStart = Date.now();
      const result = compile(ruleblocks, { dialect: Dialect.ORACLE });
      const compilationTime = Date.now() - compileStart;

      if (!result.success) {
        return {
          ruleblockName: ruleblocks.map(r => r.name).join(', '),
          success: false,
          compilationTime,
          executionTime: 0,
          rowCount: 0,
          error: result.errors.map(e => e.message).join('; '),
        };
      }

      console.log(`\n📝 Compiled ${ruleblocks.length} ruleblocks (${compilationTime}ms)`);

      // Clean up existing tables
      for (const ruleblock of ruleblocks) {
        const tableName = `ROUT_${ruleblock.name.toUpperCase()}`;
        await this.connection.cleanup(tableName);
      }

      // Execute all SQL statements in order
      const execStart = Date.now();
      for (let i = 0; i < result.sql.length; i++) {
        const sql = result.sql[i];
        const ruleblock = ruleblocks[i];
        console.log(`\n🔧 Executing ${ruleblock.name}...`);
        await this.connection.execute(sql);
      }
      const executionTime = Date.now() - execStart;

      // Query the final table for row count
      const lastRuleblock = ruleblocks[ruleblocks.length - 1];
      const tableName = `ROUT_${lastRuleblock.name.toUpperCase()}`;
      const queryResult = await this.connection.executeQuery(
        `SELECT COUNT(*) as cnt FROM ${tableName}`
      );
      const rowCount = queryResult.rows?.[0]?.['CNT'] as number || 0;

      console.log(`\n✅ All executed successfully - ${rowCount} rows in final table (${executionTime}ms)`);

      return {
        ruleblockName: ruleblocks.map(r => r.name).join(', '),
        success: true,
        compilationTime,
        executionTime,
        rowCount,
        sql: result.sql.join('\n\n'),
      };
    } catch (error) {
      return {
        ruleblockName: ruleblocks.map(r => r.name).join(', '),
        success: false,
        compilationTime: Date.now() - startTime,
        executionTime: 0,
        rowCount: 0,
        error: error instanceof Error ? error.message : String(error),
      };
    }
  }
}
