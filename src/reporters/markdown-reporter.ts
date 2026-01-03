import { writeFile, mkdir } from 'fs/promises';
import { dirname } from 'path';
import type { LoaderResult } from '../loaders/ruleblock-loader.js';
import type { BatchCompilationResult } from '../runners/batch-compilation-runner.js';
import type { BatchExecutionResult, RuleblockExecutionResult } from '../execution/batch-executor.js';
import type { CompilationManifest } from 'picorules-compiler-js-core';

/**
 * Full test run result
 */
export interface TestRunResult {
  /** Loader result */
  loader: LoaderResult;
  /** Compilation result */
  compilation: BatchCompilationResult;
  /** Execution result (if executed) */
  execution?: BatchExecutionResult;
  /** Timestamp of test run */
  timestamp: Date;
  /** Database dialect */
  dialect: string;
  /** Test options */
  options: {
    compileOnly: boolean;
    stopOnFailure: boolean;
  };
}

/**
 * Generate markdown report from test run results
 *
 * @param result - Full test run result
 * @returns Markdown string
 */
export function generateMarkdownReport(result: TestRunResult): string {
  const lines: string[] = [];

  // Header
  lines.push('# Picorules Test Report');
  lines.push('');
  lines.push(`**Generated:** ${result.timestamp.toISOString()}`);
  lines.push(`**Dialect:** ${result.dialect}`);
  lines.push(`**Mode:** ${result.options.compileOnly ? 'Compilation Only' : 'Full Execution'}`);
  lines.push('');

  // Summary Section
  lines.push('## Summary');
  lines.push('');
  lines.push(`| Metric | Value |`);
  lines.push(`|--------|-------|`);
  lines.push(`| Total .prb files | ${result.loader.totalFiles} |`);
  lines.push(`| Loaded successfully | ${result.loader.ruleblocks.length} |`);
  lines.push(`| Load errors | ${result.loader.errors.length} |`);
  lines.push(`| Load time | ${result.loader.loadTimeMs}ms |`);
  lines.push('');

  if (result.compilation.success) {
    lines.push(`| Compilation | SUCCESS |`);
    lines.push(`| SQL statements generated | ${result.compilation.sql.length} |`);
  } else {
    lines.push(`| Compilation | FAILED |`);
    lines.push(`| Compilation errors | ${result.compilation.errors.length} |`);
  }
  lines.push(`| Compilation time | ${result.compilation.metrics.totalTimeMs}ms |`);
  lines.push('');

  if (result.execution) {
    const successRate = result.execution.executedCount > 0
      ? ((result.execution.successCount / result.execution.executedCount) * 100).toFixed(1)
      : '0.0';

    lines.push(`| Executed | ${result.execution.executedCount} |`);
    lines.push(`| Passed | ${result.execution.successCount} |`);
    lines.push(`| Failed | ${result.execution.failedCount} |`);
    lines.push(`| Skipped | ${result.execution.skippedRuleblocks.length} |`);
    lines.push(`| Success rate | ${successRate}% |`);
    lines.push(`| Execution time | ${result.execution.totalExecutionTimeMs}ms |`);
  }
  lines.push('');

  // Loading Errors Section
  if (result.loader.errors.length > 0) {
    lines.push('## Loading Errors');
    lines.push('');
    lines.push('| File | Error |');
    lines.push('|------|-------|');
    for (const error of result.loader.errors) {
      lines.push(`| ${escapeMarkdown(error.filePath)} | ${escapeMarkdown(error.message)} |`);
    }
    lines.push('');
  }

  // Compilation Errors Section
  if (result.compilation.errors.length > 0) {
    lines.push('## Compilation Errors');
    lines.push('');
    lines.push('| Type | Ruleblock | Error |');
    lines.push('|------|-----------|-------|');
    for (const error of result.compilation.errors) {
      lines.push(`| ${error.type} | ${error.ruleblockName || '-'} | ${escapeMarkdown(error.message)} |`);
    }
    lines.push('');
  }

  // Execution Failures Section
  if (result.execution) {
    const failures = result.execution.results.filter(r => !r.success);
    if (failures.length > 0) {
      lines.push('## Execution Failures');
      lines.push('');
      lines.push('| Ruleblock | Target Table | Dependencies | Error |');
      lines.push('|-----------|--------------|--------------|-------|');
      for (const failure of failures) {
        const deps = failure.dependencies.length > 0
          ? failure.dependencies.join(', ')
          : '-';
        lines.push(`| ${failure.ruleblockId} | ${failure.targetTable} | ${deps} | ${escapeMarkdown(failure.error || 'Unknown')} |`);
      }
      lines.push('');
    }

    // Skipped Ruleblocks
    if (result.execution.skippedRuleblocks.length > 0) {
      lines.push('## Skipped Ruleblocks');
      lines.push('');
      lines.push('These ruleblocks were skipped due to dependency failures or execution stopping:');
      lines.push('');
      for (const name of result.execution.skippedRuleblocks) {
        lines.push(`- ${name}`);
      }
      lines.push('');
    }
  }

  // Execution Order Section (from manifest)
  if (result.compilation.manifest) {
    lines.push('## Execution Order');
    lines.push('');
    lines.push('Ruleblocks in topological order (dependencies first):');
    lines.push('');
    lines.push('| Order | Ruleblock | Dependencies | Status |');
    lines.push('|-------|-----------|--------------|--------|');

    const executionResults = new Map<string, RuleblockExecutionResult>();
    if (result.execution) {
      for (const res of result.execution.results) {
        executionResults.set(res.ruleblockId, res);
      }
    }

    const skippedSet = new Set(result.execution?.skippedRuleblocks || []);

    for (const entry of result.compilation.manifest.entries) {
      const deps = entry.dependencies.length > 0
        ? entry.dependencies.join(', ')
        : '-';

      let status = 'NOT EXECUTED';
      if (result.execution) {
        const execResult = executionResults.get(entry.ruleblockId);
        if (execResult) {
          status = execResult.success ? 'PASS' : 'FAIL';
        } else if (skippedSet.has(entry.ruleblockId)) {
          status = 'SKIPPED';
        }
      }

      lines.push(`| ${entry.executionOrder + 1} | ${entry.ruleblockId} | ${deps} | ${status} |`);
    }
    lines.push('');
  }

  // Timing Breakdown
  lines.push('## Timing Breakdown');
  lines.push('');
  lines.push('| Stage | Time (ms) |');
  lines.push('|-------|-----------|');
  lines.push(`| Loading | ${result.loader.loadTimeMs} |`);
  lines.push(`| Parsing | ${result.compilation.metrics.parseTimeMs} |`);
  lines.push(`| Linking | ${result.compilation.metrics.linkTimeMs} |`);
  lines.push(`| Transform | ${result.compilation.metrics.transformTimeMs} |`);
  lines.push(`| SQL Generation | ${result.compilation.metrics.sqlGenTimeMs} |`);
  if (result.execution) {
    lines.push(`| Execution | ${result.execution.totalExecutionTimeMs} |`);
  }
  lines.push('');

  // Footer
  lines.push('---');
  lines.push('');
  lines.push('*Generated by picorules-compiler-js-db-manager*');

  return lines.join('\n');
}

/**
 * Write markdown report to file
 *
 * @param result - Test run result
 * @param outputPath - Path to write report
 */
export async function writeMarkdownReport(
  result: TestRunResult,
  outputPath: string
): Promise<void> {
  const markdown = generateMarkdownReport(result);

  // Ensure directory exists
  await mkdir(dirname(outputPath), { recursive: true });

  await writeFile(outputPath, markdown, 'utf-8');
  console.log(`Report written to: ${outputPath}`);
}

/**
 * Generate a timestamped filename for the report
 *
 * @param dialect - Database dialect
 * @returns Filename like "report-postgresql-2024-01-15T10-30-00.md"
 */
export function generateReportFilename(dialect: string): string {
  const timestamp = new Date()
    .toISOString()
    .replace(/:/g, '-')
    .replace(/\.\d{3}Z$/, '');
  return `report-${dialect.toLowerCase()}-${timestamp}.md`;
}

/**
 * Escape special markdown characters
 */
function escapeMarkdown(text: string): string {
  return text
    .replace(/\|/g, '\\|')
    .replace(/\n/g, ' ')
    .substring(0, 200); // Truncate long messages
}

/**
 * Print summary to console
 */
export function printConsoleSummary(result: TestRunResult): void {
  console.log('\n' + '='.repeat(60));
  console.log('PICORULES TEST SUMMARY');
  console.log('='.repeat(60));

  console.log(`\nLoading:`);
  console.log(`  - Files found: ${result.loader.totalFiles}`);
  console.log(`  - Loaded: ${result.loader.ruleblocks.length}`);
  console.log(`  - Errors: ${result.loader.errors.length}`);

  console.log(`\nCompilation:`);
  if (result.compilation.success) {
    console.log(`  - Status: SUCCESS`);
    console.log(`  - SQL statements: ${result.compilation.sql.length}`);
  } else {
    console.log(`  - Status: FAILED`);
    console.log(`  - Errors: ${result.compilation.errors.length}`);
  }
  console.log(`  - Time: ${result.compilation.metrics.totalTimeMs}ms`);

  if (result.execution) {
    console.log(`\nExecution:`);
    console.log(`  - Executed: ${result.execution.executedCount}`);
    console.log(`  - Passed: ${result.execution.successCount}`);
    console.log(`  - Failed: ${result.execution.failedCount}`);
    console.log(`  - Skipped: ${result.execution.skippedRuleblocks.length}`);
    console.log(`  - Time: ${result.execution.totalExecutionTimeMs}ms`);

    const successRate = result.execution.executedCount > 0
      ? ((result.execution.successCount / result.execution.executedCount) * 100).toFixed(1)
      : '0.0';
    console.log(`\nSuccess Rate: ${successRate}%`);
  }

  console.log('\n' + '='.repeat(60));

  if (result.compilation.success && (!result.execution || result.execution.success)) {
    console.log('ALL TESTS PASSED');
  } else {
    console.log('TESTS FAILED - See report for details');
  }
  console.log('='.repeat(60) + '\n');
}
