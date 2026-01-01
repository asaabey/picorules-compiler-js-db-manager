import sql from 'mssql';
import dotenv from 'dotenv';

dotenv.config();

export interface MSSQLConfig {
  server: string;
  port: number;
  database: string;
  user: string;
  password: string;
  options: {
    encrypt: boolean;
    trustServerCertificate: boolean;
  };
}

export class MSSQLConnection {
  private pool: sql.ConnectionPool | null = null;

  constructor(private config: MSSQLConfig) {}

  static fromEnv(): MSSQLConnection {
    const config: MSSQLConfig = {
      server: process.env.MSSQL_SERVER || 'localhost',
      port: parseInt(process.env.MSSQL_PORT || '1433', 10),
      database: process.env.MSSQL_DATABASE || 'testdb',
      user: process.env.MSSQL_USER || 'sa',
      password: process.env.MSSQL_PASSWORD || '',
      options: {
        encrypt: process.env.MSSQL_ENCRYPT === 'true',
        trustServerCertificate: process.env.MSSQL_TRUST_SERVER_CERTIFICATE === 'true',
      },
    };

    if (!config.password) {
      throw new Error('SQL Server password not found in environment variables');
    }

    return new MSSQLConnection(config);
  }

  async connect(): Promise<void> {
    if (this.pool) {
      return;
    }

    try {
      this.pool = await sql.connect(this.config);
      console.log('✅ Connected to SQL Server database');
    } catch (error) {
      console.error('❌ Failed to connect to SQL Server:', error);
      throw error;
    }
  }

  async execute(sqlText: string): Promise<sql.IResult<unknown>> {
    if (!this.pool) {
      throw new Error('Not connected to SQL Server database');
    }

    try {
      const result = await this.pool.request().query(sqlText);
      return result;
    } catch (error) {
      console.error('❌ SQL execution failed:', error);
      console.error('SQL:', sqlText);
      throw error;
    }
  }

  async executeQuery(sqlText: string): Promise<sql.IResult<unknown>> {
    return this.execute(sqlText);
  }

  async close(): Promise<void> {
    if (this.pool) {
      try {
        await this.pool.close();
        console.log('✅ SQL Server connection closed');
        this.pool = null;
      } catch (error) {
        console.error('❌ Failed to close SQL Server connection:', error);
        throw error;
      }
    }
  }

  async cleanup(tableName: string): Promise<void> {
    if (!this.pool) {
      return;
    }

    try {
      await this.execute(`DROP TABLE IF EXISTS ${tableName}`);
      console.log(`🧹 Dropped table ${tableName}`);
    } catch (error) {
      console.error(`⚠️  Failed to drop table ${tableName}:`, error);
    }
  }
}
