#!/usr/bin/env node
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import { Dialect } from 'picorules-compiler-js-core';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
import { loadRuleblocksFromDirectory, DEFAULT_RULEBLOCKS_PATH } from './loaders/ruleblock-loader.js';
import { compileAllRuleblocks, compileRuleblocksIndividually } from './runners/batch-compilation-runner.js';
import { BatchExecutor, type DatabaseConnection } from './execution/batch-executor.js';
import { PostgreSQLConnection } from './db/postgresql-connection.js';
import { MSSQLConnection } from './db/mssql-connection.js';
import {
  generateReportFilename,
  writeMarkdownReport,
  printConsoleSummary,
  type TestRunResult,
} from './reporters/markdown-reporter.js';

interface CLIOptions {
  /** Only compile, don't execute against database */
  compileOnly: boolean;
  /** Stop on first execution failure */
  stopOnFailure: boolean;
  /** Verbose output */
  verbose: boolean;
  /** Path to ruleblocks directory */
  ruleblocksPath: string;
  /** Path to write report */
  reportPath: string;
  /** Show individual compilation results on failure */
  showIndividual: boolean;
  /** Filter to specific ruleblocks (comma-separated) */
  filter?: string;
  /** SQL dialect */
  dialect: Dialect;
}

function parseArgs(): CLIOptions {
  const args = process.argv.slice(2);

  // Default dialect based on first positional arg or default to postgresql
  let dialect = Dialect.POSTGRESQL;

  const options: CLIOptions = {
    compileOnly: false,
    stopOnFailure: true,
    verbose: true,
    ruleblocksPath: DEFAULT_RULEBLOCKS_PATH,
    reportPath: '', // Will be set after dialect is determined
    showIndividual: false,
    filter: undefined,
    dialect: Dialect.POSTGRESQL,
  };

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];

    switch (arg) {
      case '--compile-only':
      case '-c':
        options.compileOnly = true;
        break;

      case '--continue-on-failure':
        options.stopOnFailure = false;
        break;

      case '--quiet':
      case '-q':
        options.verbose = false;
        break;

      case '--show-individual':
      case '-i':
        options.showIndividual = true;
        break;

      case '--path':
      case '-p':
        options.ruleblocksPath = args[++i];
        break;

      case '--report':
      case '-r':
        options.reportPath = args[++i];
        break;

      case '--filter':
      case '-f':
        options.filter = args[++i];
        break;

      case '--dialect':
      case '-d':
        const dialectArg = args[++i]?.toLowerCase();
        if (dialectArg === 'mssql' || dialectArg === 'sqlserver') {
          options.dialect = Dialect.MSSQL;
        } else if (dialectArg === 'postgresql' || dialectArg === 'postgres' || dialectArg === 'pg') {
          options.dialect = Dialect.POSTGRESQL;
        } else if (dialectArg === 'oracle') {
          options.dialect = Dialect.ORACLE;
        } else {
          console.error(`Unknown dialect: ${dialectArg}. Use: postgresql, mssql, or oracle`);
          process.exit(1);
        }
        break;

      case '--help':
      case '-h':
        printHelp();
        process.exit(0);

      default:
        if (arg.startsWith('-')) {
          console.error(`Unknown option: ${arg}`);
          process.exit(1);
        }
    }
  }

  // Set report path based on dialect if not specified
  if (!options.reportPath) {
    options.reportPath = join(__dirname, '../reports', generateReportFilename(options.dialect));
  }

  return options;
}

function printHelp(): void {
  console.log(`
Picorules Test Harness

USAGE:
  npm run test:all [options]
  tsx src/test-all-ruleblocks.ts [options]

OPTIONS:
  -d, --dialect <dialect>  SQL dialect: postgresql (default), mssql, oracle
  -c, --compile-only       Only compile, don't execute against database
  --continue-on-failure    Don't stop on first execution failure
  -q, --quiet              Minimal output
  -i, --show-individual    On failure, show which ruleblocks fail individually
  -p, --path <path>        Path to ruleblocks directory
  -r, --report <path>      Path to write markdown report
  -f, --filter <names>     Only test specific ruleblocks (comma-separated)
  -h, --help               Show this help

ENVIRONMENT VARIABLES:
  PostgreSQL:
    PG_HOST, PG_PORT, PG_DATABASE, PG_USER, PG_PASSWORD

  MSSQL:
    MSSQL_SERVER, MSSQL_PORT, MSSQL_DATABASE, MSSQL_USER, MSSQL_PASSWORD
    MSSQL_ENCRYPT, MSSQL_TRUST_SERVER_CERTIFICATE

EXAMPLES:
  # Test all ruleblocks against PostgreSQL (default)
  npm run test:all

  # Test against MSSQL
  npm run test:all -- --dialect mssql

  # Compile only (no database)
  npm run test:all -- --compile-only

  # Test specific ruleblocks
  npm run test:all -- --filter "dmg,ckd,rrt"

  # Continue on failure to see all errors
  npm run test:all -- --continue-on-failure --dialect mssql
`);
}

async function main(): Promise<void> {
  const options = parseArgs();
  const startTime = Date.now();

  console.log('='.repeat(60));
  console.log('PICORULES TEST HARNESS');
  console.log('='.repeat(60));
  console.log(`\nDialect: ${options.dialect}`);
  console.log(`Ruleblocks path: ${options.ruleblocksPath}`);
  console.log(`Mode: ${options.compileOnly ? 'Compile Only' : 'Compile + Execute'}`);
  console.log(`Report: ${options.reportPath}`);
  console.log('');

  // Phase 1: Load ruleblocks
  console.log('Phase 1: Loading ruleblocks...');
  let loaderResult = await loadRuleblocksFromDirectory(options.ruleblocksPath);

  if (loaderResult.errors.length > 0) {
    console.log(`  Warning: ${loaderResult.errors.length} files failed to load`);
  }

  // Apply filter if specified
  if (options.filter) {
    const filterNames = new Set(options.filter.split(',').map(n => n.trim().toLowerCase()));
    loaderResult = {
      ...loaderResult,
      ruleblocks: loaderResult.ruleblocks.filter(rb =>
        filterNames.has(rb.name.toLowerCase())
      ),
    };
    console.log(`  Filtered to ${loaderResult.ruleblocks.length} ruleblocks`);
  }

  console.log(`  Loaded ${loaderResult.ruleblocks.length} ruleblocks in ${loaderResult.loadTimeMs}ms\n`);

  if (loaderResult.ruleblocks.length === 0) {
    console.error('No ruleblocks loaded. Exiting.');
    process.exit(1);
  }

  // Phase 2: Compile ruleblocks
  console.log('Phase 2: Compiling ruleblocks...');
  const compilationResult = compileAllRuleblocks(loaderResult.ruleblocks, {
    dialect: options.dialect,
    verbose: options.verbose,
  });

  if (!compilationResult.success) {
    console.log(`  Compilation failed with ${compilationResult.errors.length} errors\n`);

    // Show individual failures if requested
    if (options.showIndividual) {
      console.log('Checking individual ruleblocks...');
      const individual = compileRuleblocksIndividually(
        loaderResult.ruleblocks,
        options.dialect
      );

      const failures = Array.from(individual.entries()).filter(([_, r]) => !r.success);
      console.log(`\n${failures.length} ruleblocks fail individually:\n`);
      for (const [name, result] of failures) {
        console.log(`  ${name}: ${result.error}`);
      }
    }
  }

  // Phase 3: Execute (if not compile-only)
  let executionResult = undefined;

  if (!options.compileOnly && compilationResult.success && compilationResult.manifest) {
    console.log(`\nPhase 3: Executing against ${options.dialect}...`);

    let connection: DatabaseConnection | null = null;

    try {
      // Create appropriate connection based on dialect
      if (options.dialect === Dialect.MSSQL) {
        const mssqlConn = MSSQLConnection.fromEnv();
        await mssqlConn.connect();
        connection = mssqlConn;
      } else if (options.dialect === Dialect.POSTGRESQL) {
        const pgConn = PostgreSQLConnection.fromEnv();
        await pgConn.connect();
        connection = pgConn;
      } else {
        console.error(`Execution not supported for dialect: ${options.dialect}`);
        process.exit(1);
      }

      const executor = new BatchExecutor(connection, {
        stopOnFailure: options.stopOnFailure,
        verbose: options.verbose,
      });

      executionResult = await executor.execute(
        compilationResult.manifest,
        compilationResult.sql
      );
    } catch (error) {
      console.error('Execution failed:', error);
      executionResult = {
        success: false,
        totalExecutionTimeMs: 0,
        executedCount: 0,
        successCount: 0,
        failedCount: 0,
        results: [],
        firstFailedIndex: -1,
        skippedRuleblocks: compilationResult.manifest?.entries.map(e => e.ruleblockId) || [],
      };
    } finally {
      if (connection) {
        await (connection as any).close();
      }
    }
  }

  // Phase 4: Generate report
  console.log('\nPhase 4: Generating report...');

  const testResult: TestRunResult = {
    loader: loaderResult,
    compilation: compilationResult,
    execution: executionResult,
    timestamp: new Date(),
    dialect: options.dialect,
    options: {
      compileOnly: options.compileOnly,
      stopOnFailure: options.stopOnFailure,
    },
  };

  await writeMarkdownReport(testResult, options.reportPath);

  // Print summary
  printConsoleSummary(testResult);

  const totalTime = Date.now() - startTime;
  console.log(`Total time: ${totalTime}ms\n`);

  // Exit with appropriate code
  const success = compilationResult.success &&
    (!executionResult || executionResult.success);

  process.exit(success ? 0 : 1);
}

main().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});
