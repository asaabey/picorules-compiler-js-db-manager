import { Client, QueryResult } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

export interface PostgreSQLConfig {
  host: string;
  port: number;
  database: string;
  user: string;
  password: string;
}

export class PostgreSQLConnection {
  private client: Client | null = null;

  constructor(private config: PostgreSQLConfig) {}

  static fromEnv(): PostgreSQLConnection {
    const config: PostgreSQLConfig = {
      host: process.env.PG_HOST || 'localhost',
      port: parseInt(process.env.PG_PORT || '5432', 10),
      database: process.env.PG_DATABASE || 'postgres',
      user: process.env.PG_USER || 'postgres',
      password: process.env.PG_PASSWORD || '',
    };

    if (!config.password) {
      throw new Error('PostgreSQL password not found in environment variables');
    }

    return new PostgreSQLConnection(config);
  }

  async connect(): Promise<void> {
    if (this.client) {
      return;
    }

    try {
      this.client = new Client(this.config);
      await this.client.connect();
      console.log('✅ Connected to PostgreSQL database');
    } catch (error) {
      console.error('❌ Failed to connect to PostgreSQL:', error);
      throw error;
    }
  }

  async execute(sqlText: string): Promise<QueryResult> {
    if (!this.client) {
      throw new Error('Not connected to PostgreSQL database');
    }

    try {
      const result = await this.client.query(sqlText);
      return result;
    } catch (error) {
      console.error('❌ SQL execution failed:', error);
      console.error('SQL:', sqlText);
      throw error;
    }
  }

  async executeQuery(sqlText: string): Promise<QueryResult> {
    return this.execute(sqlText);
  }

  async close(): Promise<void> {
    if (this.client) {
      try {
        await this.client.end();
        console.log('✅ PostgreSQL connection closed');
        this.client = null;
      } catch (error) {
        console.error('❌ Failed to close PostgreSQL connection:', error);
        throw error;
      }
    }
  }

  async cleanup(tableName: string): Promise<void> {
    if (!this.client) {
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
