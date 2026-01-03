import { MSSQLConnection } from './src/db/mssql-connection.js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function executeRule1() {
  const sql = fs.readFileSync(
    path.join(__dirname, 'sample-prb/rule1-fixed.sql'),
    'utf-8'
  );

  const connection = new MSSQLConnection({
    server: process.env.MSSQL_SERVER!,
    port: parseInt(process.env.MSSQL_PORT || '1433'),
    database: process.env.MSSQL_DATABASE!,
    user: process.env.MSSQL_USER!,
    password: process.env.MSSQL_PASSWORD!,
    options: {
      encrypt: process.env.MSSQL_ENCRYPT === 'true',
      trustServerCertificate: process.env.MSSQL_TRUST_SERVER_CERTIFICATE === 'true',
    },
  });

  try {
    console.log('🔌 Connecting to SQL Server...');
    await connection.connect();
    console.log('✅ Connected successfully!\n');

    console.log('🧹 Dropping existing ROUT_RULE1 table...');
    await connection.cleanup('ROUT_RULE1');

    console.log('⚙️  Executing SQL...\n');
    const startTime = Date.now();
    await connection.execute(sql);
    const executionTime = Date.now() - startTime;
    console.log(`✅ Executed successfully in ${executionTime}ms\n`);

    console.log('📊 Querying results from ROUT_RULE1...');
    const queryResult = await connection.executeQuery(
      'SELECT TOP 20 * FROM ROUT_RULE1 ORDER BY eid'
    );

    console.log(`\n📈 Results (showing first ${queryResult.recordset.length} rows):`);
    console.log('='.repeat(80));
    console.table(queryResult.recordset);
    console.log('='.repeat(80));

    const countResult = await connection.executeQuery(
      'SELECT COUNT(*) as total FROM ROUT_RULE1'
    );
    console.log(`\n✅ Total rows in ROUT_RULE1: ${countResult.recordset[0].total}`);

    const rule1CountResult = await connection.executeQuery(
      'SELECT rule1, COUNT(*) as count FROM ROUT_RULE1 GROUP BY rule1 ORDER BY rule1'
    );
    console.log(`\n📊 Rule1 distribution:`);
    console.table(rule1CountResult.recordset);

  } catch (error) {
    console.error('\n❌ Error:', error instanceof Error ? error.message : String(error));
    process.exit(1);
  } finally {
    await connection.close();
    console.log('\n✅ Connection closed');
  }
}

executeRule1();
