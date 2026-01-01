import oracledb from 'oracledb';
import dotenv from 'dotenv';

dotenv.config();

export interface OracleConfig {
  user: string;
  password: string;
  connectString: string;
}

export class OracleConnection {
  private connection: oracledb.Connection | null = null;

  constructor(private config: OracleConfig) {}

  static fromEnv(): OracleConnection {
    const config: OracleConfig = {
      user: process.env.ORACLE_USER || '',
      password: process.env.ORACLE_PASSWORD || '',
      connectString: process.env.ORACLE_CONNECT_STRING || 'localhost:1521/XEPDB1',
    };

    if (!config.user || !config.password) {
      throw new Error('Oracle credentials not found in environment variables');
    }

    return new OracleConnection(config);
  }

  async connect(): Promise<void> {
    if (this.connection) {
      return;
    }

    try {
      this.connection = await oracledb.getConnection(this.config);
      console.log('✅ Connected to Oracle database');
    } catch (error) {
      console.error('❌ Failed to connect to Oracle:', error);
      throw error;
    }
  }

  async execute(sql: string): Promise<oracledb.Result<unknown>> {
    if (!this.connection) {
      throw new Error('Not connected to Oracle database');
    }

    try {
      const result = await this.connection.execute(sql, [], { autoCommit: true });
      return result;
    } catch (error) {
      console.error('❌ SQL execution failed:', error);
      console.error('SQL:', sql);
      throw error;
    }
  }

  async executeQuery(sql: string): Promise<oracledb.Result<unknown>> {
    if (!this.connection) {
      throw new Error('Not connected to Oracle database');
    }

    try {
      const result = await this.connection.execute(sql, [], {
        outFormat: oracledb.OUT_FORMAT_OBJECT,
      });
      return result;
    } catch (error) {
      console.error('❌ Query execution failed:', error);
      console.error('SQL:', sql);
      throw error;
    }
  }

  async close(): Promise<void> {
    if (this.connection) {
      try {
        await this.connection.close();
        console.log('✅ Oracle connection closed');
        this.connection = null;
      } catch (error) {
        console.error('❌ Failed to close Oracle connection:', error);
        throw error;
      }
    }
  }

  async cleanup(tableName: string): Promise<void> {
    if (!this.connection) {
      return;
    }

    try {
      await this.execute(`DROP TABLE ${tableName}`);
      console.log(`🧹 Dropped table ${tableName}`);
    } catch (error) {
      // Ignore errors if table doesn't exist
      if (error instanceof Error && !error.message.includes('ORA-00942')) {
        console.error(`⚠️  Failed to drop table ${tableName}:`, error);
      }
    }
  }
}
