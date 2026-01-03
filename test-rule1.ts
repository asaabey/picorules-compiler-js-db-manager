import { compile, Dialect } from 'picorules-compiler-js-core';
import { MSSQLConnection } from './src/db/mssql-connection.js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function testRule1() {
  // Read the rule file
  const ruleText = fs.readFileSync(
    path.join(__dirname, 'sample-prb/rule1.prb'),
    'utf-8'
  );

  console.log('📄 Source Rule:');
  console.log(ruleText);
  console.log('\n' + '='.repeat(60) + '\n');

  // Extract just the rule statements (remove comments and directives)
  const ruleStatements = `
icd_fd => eadv.[icd_c37%].dt.first();
icpc_fd => eadv.[icpc_t71%].dt.first();
rule1 : { icd_fd!? =>1},{=>0};
  `.trim();

  // Compile to SQL
  const ruleblock = {
    name: 'rule1',
    text: ruleStatements,
    isActive: true,
  };

  console.log('🔧 Compiling to SQL Server T-SQL...\n');
  const result = compile([ruleblock], { dialect: Dialect.MSSQL });

  if (!result.success) {
    console.error('❌ Compilation failed:');
    result.errors.forEach(err => console.error(`  - ${err.message}`));
    process.exit(1);
  }

  const sql = result.sql[0];

  // Save SQL to file
  fs.writeFileSync(
    path.join(__dirname, 'sample-prb/rule1.sql'),
    sql,
    'utf-8'
  );
  console.log('✅ Compilation successful!');
  console.log('📝 SQL saved to: sample-prb/rule1.sql\n');
  console.log('Generated SQL:');
  console.log('='.repeat(60));
  console.log(sql);
  console.log('='.repeat(60) + '\n');

  // Execute against SQL Server
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

    // Clean up existing table
    console.log('🧹 Dropping existing ROUT_RULE1 table if exists...');
    await connection.cleanup('ROUT_RULE1');

    // Execute the SQL
    console.log('⚙️  Executing compiled SQL...');
    const startTime = Date.now();
    await connection.execute(sql);
    const executionTime = Date.now() - startTime;
    console.log(`✅ Executed successfully in ${executionTime}ms\n`);

    // Query results
    console.log('📊 Querying results from ROUT_RULE1...');
    const queryResult = await connection.executeQuery(
      'SELECT TOP 10 * FROM ROUT_RULE1 ORDER BY eid'
    );

    console.log(`\n📈 Results (${queryResult.recordset.length} rows):`);
    console.log('='.repeat(60));
    console.table(queryResult.recordset);
    console.log('='.repeat(60));

    // Count total rows
    const countResult = await connection.executeQuery(
      'SELECT COUNT(*) as total FROM ROUT_RULE1'
    );
    console.log(`\n✅ Total rows in ROUT_RULE1: ${countResult.recordset[0].total}`);

  } catch (error) {
    console.error('\n❌ Error:', error instanceof Error ? error.message : String(error));
    process.exit(1);
  } finally {
    await connection.close();
    console.log('\n✅ Connection closed');
  }
}

testRule1();
