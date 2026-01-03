#!/usr/bin/env node
import * as fs from 'fs';
import * as path from 'path';
import { compile, Dialect, type RuleblockInput } from 'picorules-compiler-js-core';
import { MSSQLConnection } from './db/mssql-connection.js';
import { MSSQLManager } from './managers/mssql-manager.js';
import { PostgreSQLConnection } from './db/postgresql-connection.js';
import { PostgreSQLManager } from './managers/postgresql-manager.js';

/**
 * Parse command line arguments
 */
function parseArgs() {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.error('Usage: npm run test:prb <file.prb> [options]');
    console.error('');
    console.error('Options:');
    console.error('  --execute         Execute SQL against database (uses dialect setting)');
    console.error('  --dialect <name>  Generate SQL for specific dialect (oracle, mssql, postgres)');
    console.error('  --output <file>   Save SQL to file (default: <ruleblock>.sql in same directory as .prb)');
    console.error('');
    console.error('Examples:');
    console.error('  npm run test:prb sample-prb/rule1.prb');
    console.error('  npm run test:prb sample-prb/rule1.prb --execute');
    console.error('  npm run test:prb sample-prb/rule1.prb --dialect mssql --output output.sql');
    process.exit(1);
  }

  const filePath = args[0];
  const executeDb = args.includes('--execute');

  let dialect = Dialect.MSSQL; // default to MSSQL
  const dialectIndex = args.indexOf('--dialect');
  if (dialectIndex !== -1 && args[dialectIndex + 1]) {
    const dialectName = args[dialectIndex + 1].toLowerCase();
    switch (dialectName) {
      case 'oracle':
        dialect = Dialect.ORACLE;
        break;
      case 'mssql':
      case 'sqlserver':
        dialect = Dialect.MSSQL;
        break;
      case 'postgres':
      case 'postgresql':
        dialect = Dialect.POSTGRESQL;
        break;
      default:
        console.error(`Unknown dialect: ${dialectName}`);
        process.exit(1);
    }
  }

  let outputFile: string | null = null;
  const outputIndex = args.indexOf('--output');
  if (outputIndex !== -1 && args[outputIndex + 1]) {
    outputFile = args[outputIndex + 1];
  }

  return { filePath, executeDb, dialect, outputFile };
}

/**
 * Strip comments from Picorules code
 */
function stripComments(text: string): string {
  // Remove complete multiline comments /* ... */
  let result = text.replace(/\/\*[\s\S]*?\*\//g, '');

  // Remove unclosed multiline comment starters at the beginning of lines
  // This handles malformed comments like "/* something" without closing */
  result = result.replace(/^\s*\/\*.*$/gm, '');

  // Remove single-line comments // ...
  result = result.replace(/\/\/.*$/gm, '');

  return result;
}

/**
 * Replace [[rb_id]] placeholder with actual ruleblock name
 * This is a Picorules convention where [[rb_id]] is a shortcut for the ruleblock name
 */
function replaceRuleblockId(text: string, ruleblockName: string): string {
  return text.replace(/\[\[rb_id\]\]/g, ruleblockName);
}

/**
 * Read and parse a .prb file into a RuleblockInput
 */
function readPrbFile(filePath: string): RuleblockInput {
  const absolutePath = path.isAbsolute(filePath)
    ? filePath
    : path.join(process.cwd(), filePath);

  if (!fs.existsSync(absolutePath)) {
    throw new Error(`File not found: ${absolutePath}`);
  }

  const rawText = fs.readFileSync(absolutePath, 'utf-8');
  const fileName = path.basename(filePath, '.prb');

  // First, determine the ruleblock name
  // Check if [[rb_id]] is used in the file - if so, use filename as the name
  const usesPlaceholder = rawText.includes('[[rb_id]]');
  let name: string;

  if (usesPlaceholder) {
    // When [[rb_id]] is used, the ruleblock name is the filename
    name = fileName;
  } else {
    // Extract ruleblock name from #define_ruleblock directive if present
    const defineMatch = rawText.match(/#define_ruleblock\s*\(\s*([a-zA-Z_][a-zA-Z0-9_]*)/);
    name = defineMatch ? defineMatch[1] : fileName;
  }

  // Strip comments from the text
  let text = stripComments(rawText);

  // Replace [[rb_id]] with actual ruleblock name
  text = replaceRuleblockId(text, name);

  return {
    name,
    text,
    isActive: true,
  };
}

/**
 * Main execution
 */
async function main() {
  const { filePath, executeDb, dialect, outputFile } = parseArgs();

  console.log('🔧 Picorules File Tester');
  console.log('='.repeat(60));
  console.log(`📄 File: ${filePath}`);
  console.log(`🎯 Dialect: ${dialect}`);
  console.log('');

  try {
    // Read the .prb file
    const ruleblock = readPrbFile(filePath);
    console.log(`✅ Loaded ruleblock: ${ruleblock.name}`);
    console.log('');

    // Debug: show the processed text
    if (process.env.DEBUG) {
      console.log('🔍 Processed text (after comment stripping):');
      console.log('-'.repeat(60));
      console.log(ruleblock.text);
      console.log('-'.repeat(60));
      console.log('');
    }

    // Compile to SQL
    console.log('📝 Compiling to SQL...');
    const compileStart = Date.now();
    const result = compile([ruleblock], { dialect });
    const compilationTime = Date.now() - compileStart;

    if (!result.success) {
      console.error('❌ Compilation failed:');
      result.errors.forEach(error => {
        console.error(`  - ${error.message}`);
      });
      process.exit(1);
    }

    console.log(`✅ Compilation successful (${compilationTime}ms)`);
    console.log('');

    const generatedSql = result.sql[0];

    // Display generated SQL
    console.log('📋 Generated SQL:');
    console.log('='.repeat(60));
    console.log(generatedSql);
    console.log('='.repeat(60));
    console.log('');

    // Determine output SQL file path
    let sqlFilePath: string;
    if (outputFile) {
      sqlFilePath = outputFile;
    } else {
      // Default: save in same directory as .prb file with .sql extension
      const prbDir = path.dirname(filePath);
      const prbBaseName = path.basename(filePath, '.prb');
      sqlFilePath = path.join(prbDir, `${prbBaseName}.sql`);
    }

    // Prepare SQL with DROP TABLE statement for safe re-execution
    // MSSQL uses SROUT_ prefix, other dialects use ROUT_
    const tableName = dialect === Dialect.MSSQL
      ? `SROUT_${ruleblock.name}`
      : `ROUT_${ruleblock.name.toUpperCase()}`;

    // Different batch separators for different dialects
    let batchSeparator = '';
    if (dialect === Dialect.MSSQL) {
      batchSeparator = 'GO';
    }
    // PostgreSQL and Oracle don't need batch separators for DROP TABLE

    const sqlWithDrop = batchSeparator
      ? `-- Drop existing table if it exists\nDROP TABLE IF EXISTS ${tableName};\n${batchSeparator}\n\n${generatedSql}`
      : `-- Drop existing table if it exists\nDROP TABLE IF EXISTS ${tableName};\n\n${generatedSql}`;

    // Save SQL to file
    const absoluteSqlPath = path.isAbsolute(sqlFilePath)
      ? sqlFilePath
      : path.join(process.cwd(), sqlFilePath);

    fs.writeFileSync(absoluteSqlPath, sqlWithDrop, 'utf-8');
    console.log(`💾 SQL saved to: ${sqlFilePath}`);
    console.log(`   (Includes DROP TABLE IF EXISTS ${tableName})`);
    console.log('');

    // Execute against database if requested
    if (executeDb) {
      if (dialect === Dialect.MSSQL) {
        console.log('🚀 Executing against SQL Server database...');
        console.log('-'.repeat(60));

        const connection = MSSQLConnection.fromEnv();
        const manager = new MSSQLManager(connection);

        try {
          await connection.connect();

          const validationResult = await manager.validateRuleblock(ruleblock);

          if (!validationResult.success) {
            console.error('❌ Execution failed:', validationResult.error);
            process.exit(1);
          }

          console.log('✅ MSSQL execution successful!');
          console.log('');
        } finally {
          await connection.close();
        }
      } else if (dialect === Dialect.POSTGRESQL) {
        console.log('🚀 Executing against PostgreSQL database...');
        console.log('-'.repeat(60));

        const connection = PostgreSQLConnection.fromEnv();
        const manager = new PostgreSQLManager(connection);

        try {
          await connection.connect();

          const validationResult = await manager.validateRuleblock(ruleblock);

          if (!validationResult.success) {
            console.error('❌ Execution failed:', validationResult.error);
            process.exit(1);
          }

          console.log('✅ PostgreSQL execution successful!');
          console.log('');
        } finally {
          await connection.close();
        }
      } else {
        console.warn('⚠️  Database execution is only supported for MSSQL and PostgreSQL dialects');
      }
    }

    console.log('✨ Done!');
  } catch (error) {
    console.error('❌ Error:', error instanceof Error ? error.message : String(error));
    if (error instanceof Error && error.stack) {
      console.error('');
      console.error('Stack trace:');
      console.error(error.stack);
    }
    process.exit(1);
  }
}

main().catch(console.error);
