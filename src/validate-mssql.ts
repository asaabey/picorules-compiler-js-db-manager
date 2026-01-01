#!/usr/bin/env node
import { MSSQLConnection } from './db/mssql-connection.js';
import { MSSQLValidator } from './validators/mssql-validator.js';
import {
  basicRuleblocks,
  aggregationRuleblocks,
  windowRuleblocks,
  computeRuleblocks,
  crossReferenceRuleblocks,
  stringRuleblocks,
  existsRuleblocks,
  medianRuleblocks,
} from './test-data/sample-ruleblocks.js';

async function main() {
  console.log('🚀 SQL Server Database Validation');
  console.log('='.repeat(60));

  const connection = MSSQLConnection.fromEnv();
  const validator = new MSSQLValidator(connection);

  try {
    await connection.connect();

    console.log('\n📦 Test Suite: Basic Functions');
    console.log('-'.repeat(60));
    const basicResults = await validator.validateMultiple(basicRuleblocks);

    console.log('\n📦 Test Suite: Aggregation Functions');
    console.log('-'.repeat(60));
    const aggResults = await validator.validateMultiple(aggregationRuleblocks);

    console.log('\n📦 Test Suite: Window Functions');
    console.log('-'.repeat(60));
    const windowResults = await validator.validateMultiple(windowRuleblocks);

    console.log('\n📦 Test Suite: Compute Statements');
    console.log('-'.repeat(60));
    const computeResults = await validator.validateMultiple(computeRuleblocks);

    console.log('\n📦 Test Suite: Cross-Ruleblock References');
    console.log('-'.repeat(60));
    const crossRefResult = await validator.validateWithDependencies(crossReferenceRuleblocks);

    console.log('\n📦 Test Suite: String Functions');
    console.log('-'.repeat(60));
    const stringResults = await validator.validateMultiple(stringRuleblocks);

    console.log('\n📦 Test Suite: Exists Function');
    console.log('-'.repeat(60));
    const existsResults = await validator.validateMultiple(existsRuleblocks);

    console.log('\n📦 Test Suite: Median Function');
    console.log('-'.repeat(60));
    const medianResults = await validator.validateMultiple(medianRuleblocks);

    // Summary
    const allResults = [
      ...basicResults,
      ...aggResults,
      ...windowResults,
      ...computeResults,
      crossRefResult,
      ...stringResults,
      ...existsResults,
      ...medianResults,
    ];

    const successCount = allResults.filter(r => r.success).length;
    const totalCount = allResults.length;

    console.log('\n' + '='.repeat(60));
    console.log('📊 VALIDATION SUMMARY');
    console.log('='.repeat(60));
    console.log(`Total tests: ${totalCount}`);
    console.log(`Passed: ${successCount}`);
    console.log(`Failed: ${totalCount - successCount}`);
    console.log(`Success rate: ${((successCount / totalCount) * 100).toFixed(1)}%`);

    if (successCount === totalCount) {
      console.log('\n✅ All validations passed!');
    } else {
      console.log('\n❌ Some validations failed:');
      allResults
        .filter(r => !r.success)
        .forEach(r => {
          console.log(`  - ${r.ruleblockName}: ${r.error}`);
        });
    }

  } catch (error) {
    console.error('\n❌ Validation failed:', error);
    process.exit(1);
  } finally {
    await connection.close();
  }
}

main().catch(console.error);
