import {
  compile,
  Dialect,
  type RuleblockInput,
  type CompilationResult,
  type CompilationManifest,
} from 'picorules-compiler-js-core';

/**
 * Result of batch compilation
 */
export interface BatchCompilationResult {
  /** Whether compilation succeeded */
  success: boolean;
  /** Compiled SQL statements in execution order */
  sql: string[];
  /** Compilation manifest with execution order */
  manifest: CompilationManifest | null;
  /** Compilation errors */
  errors: CompilationError[];
  /** Compilation warnings */
  warnings: string[];
  /** Timing metrics */
  metrics: CompilationMetrics;
}

/**
 * Compilation error with ruleblock context
 */
export interface CompilationError {
  /** Ruleblock name (if known) */
  ruleblockName?: string;
  /** Error message */
  message: string;
  /** Error type for categorization */
  type: 'parse' | 'link' | 'transform' | 'generate' | 'unknown';
}

/**
 * Compilation timing metrics
 */
export interface CompilationMetrics {
  /** Total compilation time in ms */
  totalTimeMs: number;
  /** Parse time in ms */
  parseTimeMs: number;
  /** Link time in ms */
  linkTimeMs: number;
  /** Transform time in ms */
  transformTimeMs: number;
  /** SQL generation time in ms */
  sqlGenTimeMs: number;
  /** Number of ruleblocks processed */
  ruleblockCount: number;
}

/**
 * Options for batch compilation
 */
export interface BatchCompilationOptions {
  /** SQL dialect to compile for */
  dialect: Dialect;
  /** Include inactive ruleblocks */
  includeInactive?: boolean;
  /** Log progress to console */
  verbose?: boolean;
  /** Path to write manifest file */
  manifestPath?: string;
}

const DEFAULT_OPTIONS: BatchCompilationOptions = {
  dialect: Dialect.POSTGRESQL,
  includeInactive: false,
  verbose: true,
};

/**
 * Compile all ruleblocks together, respecting dependencies
 *
 * @param ruleblocks - Array of ruleblocks to compile
 * @param options - Compilation options
 * @returns BatchCompilationResult with SQL and manifest
 */
export function compileAllRuleblocks(
  ruleblocks: RuleblockInput[],
  options: Partial<BatchCompilationOptions> = {}
): BatchCompilationResult {
  const opts = { ...DEFAULT_OPTIONS, ...options };
  const startTime = Date.now();

  if (opts.verbose) {
    console.log(`\nCompiling ${ruleblocks.length} ruleblocks for ${opts.dialect}...`);
  }

  try {
    // Compile all ruleblocks together
    const result: CompilationResult = compile(ruleblocks, {
      dialect: opts.dialect,
      includeInactive: opts.includeInactive,
      manifestPath: opts.manifestPath,
    });

    const totalTime = Date.now() - startTime;

    if (!result.success) {
      if (opts.verbose) {
        console.log(`Compilation failed with ${result.errors.length} errors`);
      }

      return {
        success: false,
        sql: [],
        manifest: null,
        errors: result.errors.map(e => ({
          message: e.message,
          type: categorizeError(e.message),
        })),
        warnings: result.warnings.map(w => w.message),
        metrics: {
          totalTimeMs: totalTime,
          parseTimeMs: result.metrics?.parseTimeMs || 0,
          linkTimeMs: result.metrics?.linkTimeMs || 0,
          transformTimeMs: result.metrics?.transformTimeMs || 0,
          sqlGenTimeMs: result.metrics?.sqlGenTimeMs || 0,
          ruleblockCount: ruleblocks.length,
        },
      };
    }

    if (opts.verbose) {
      console.log(`Compilation successful in ${totalTime}ms`);
      console.log(`  - Parse: ${result.metrics?.parseTimeMs}ms`);
      console.log(`  - Link: ${result.metrics?.linkTimeMs}ms`);
      console.log(`  - Transform: ${result.metrics?.transformTimeMs}ms`);
      console.log(`  - SQL Gen: ${result.metrics?.sqlGenTimeMs}ms`);
      console.log(`  - Output: ${result.sql.length} SQL statements`);
    }

    return {
      success: true,
      sql: result.sql,
      manifest: result.manifest || null,
      errors: [],
      warnings: result.warnings.map(w => w.message),
      metrics: {
        totalTimeMs: totalTime,
        parseTimeMs: result.metrics?.parseTimeMs || 0,
        linkTimeMs: result.metrics?.linkTimeMs || 0,
        transformTimeMs: result.metrics?.transformTimeMs || 0,
        sqlGenTimeMs: result.metrics?.sqlGenTimeMs || 0,
        ruleblockCount: ruleblocks.length,
      },
    };
  } catch (error) {
    const totalTime = Date.now() - startTime;
    const errorMessage = error instanceof Error ? error.message : String(error);

    if (opts.verbose) {
      console.error(`Compilation failed: ${errorMessage}`);
    }

    return {
      success: false,
      sql: [],
      manifest: null,
      errors: [
        {
          message: errorMessage,
          type: categorizeError(errorMessage),
        },
      ],
      warnings: [],
      metrics: {
        totalTimeMs: totalTime,
        parseTimeMs: 0,
        linkTimeMs: 0,
        transformTimeMs: 0,
        sqlGenTimeMs: 0,
        ruleblockCount: ruleblocks.length,
      },
    };
  }
}

/**
 * Categorize error by type based on message content
 */
function categorizeError(message: string): CompilationError['type'] {
  const lowerMessage = message.toLowerCase();

  if (lowerMessage.includes('parse') || lowerMessage.includes('syntax')) {
    return 'parse';
  }
  if (lowerMessage.includes('link') || lowerMessage.includes('reference') || lowerMessage.includes('dependency')) {
    return 'link';
  }
  if (lowerMessage.includes('transform') || lowerMessage.includes('filter')) {
    return 'transform';
  }
  if (lowerMessage.includes('sql') || lowerMessage.includes('generate')) {
    return 'generate';
  }
  return 'unknown';
}

/**
 * Compile ruleblocks individually to identify which ones fail
 *
 * This is useful when batch compilation fails and you want to identify
 * the specific ruleblocks that are causing issues.
 *
 * @param ruleblocks - Array of ruleblocks to compile individually
 * @param dialect - SQL dialect
 * @returns Map of ruleblock name to compilation result
 */
export function compileRuleblocksIndividually(
  ruleblocks: RuleblockInput[],
  dialect: Dialect = Dialect.POSTGRESQL
): Map<string, { success: boolean; error?: string }> {
  const results = new Map<string, { success: boolean; error?: string }>();

  for (const ruleblock of ruleblocks) {
    try {
      const result = compile([ruleblock], { dialect });
      results.set(ruleblock.name, {
        success: result.success,
        error: result.errors.length > 0 ? result.errors[0].message : undefined,
      });
    } catch (error) {
      results.set(ruleblock.name, {
        success: false,
        error: error instanceof Error ? error.message : String(error),
      });
    }
  }

  return results;
}
