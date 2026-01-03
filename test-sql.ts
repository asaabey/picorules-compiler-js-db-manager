import { loadRuleblocksFromDirectory, DEFAULT_RULEBLOCKS_PATH } from './src/loaders/ruleblock-loader.js';
import { compile, Dialect } from 'picorules-compiler-js-core';
import { writeFileSync } from 'fs';

async function main() {
  const result = await loadRuleblocksFromDirectory(DEFAULT_RULEBLOCKS_PATH);
  const block = result.ruleblocks.filter(rb => rb.name === 'dmg_loc2');
  
  const compilationResult = compile(block, { dialect: Dialect.MSSQL });
  
  writeFileSync('/tmp/dmg_loc2-mssql.sql', compilationResult.sql[0]);
  console.log('SQL written to /tmp/dmg_loc2-mssql.sql');
}

main().catch(console.error);
