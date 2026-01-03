import { readdir, readFile } from 'fs/promises';
import { join, basename, dirname } from 'path';
import { fileURLToPath } from 'url';
import type { RuleblockInput } from 'picorules-compiler-js-core';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

/**
 * Result of loading ruleblocks from a directory
 */
export interface LoaderResult {
  /** Successfully loaded ruleblocks */
  ruleblocks: RuleblockInput[];
  /** Files that failed to load */
  errors: LoaderError[];
  /** Total files found */
  totalFiles: number;
  /** Time taken to load */
  loadTimeMs: number;
}

/**
 * Error during ruleblock loading
 */
export interface LoaderError {
  /** File path that failed */
  filePath: string;
  /** Error message */
  message: string;
}

/**
 * Extract ruleblock name from #define_ruleblock() directive
 *
 * Matches patterns like:
 * - #define_ruleblock(ckd, {...})
 * - #define_ruleblock(at_risk, {...})
 */
function extractRuleblockName(content: string, filePath: string): string | null {
  // Pattern: #define_ruleblock(name, {
  const match = content.match(/#define_ruleblock\s*\(\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*,/);

  if (match && match[1]) {
    return match[1];
  }

  // Fallback: use filename without extension
  const filename = basename(filePath, '.prb');
  return filename;
}

/**
 * Replace [[rb_id]] placeholder with the ruleblock name
 */
function replacePlaceholder(content: string, ruleblockName: string): string {
  return content.replace(/\[\[rb_id\]\]/g, ruleblockName);
}

/**
 * Load all .prb files from a directory
 *
 * @param directoryPath - Path to directory containing .prb files
 * @returns LoaderResult with ruleblocks and any errors
 */
export async function loadRuleblocksFromDirectory(
  directoryPath: string
): Promise<LoaderResult> {
  const startTime = Date.now();
  const ruleblocks: RuleblockInput[] = [];
  const errors: LoaderError[] = [];

  try {
    // Read all files in directory
    const files = await readdir(directoryPath);
    const prbFiles = files.filter(f => f.endsWith('.prb')).sort();

    console.log(`Found ${prbFiles.length} .prb files in ${directoryPath}`);

    for (const file of prbFiles) {
      const filePath = join(directoryPath, file);

      try {
        // Read file content
        const content = await readFile(filePath, 'utf-8');

        // Extract ruleblock name
        const name = extractRuleblockName(content, filePath);
        if (!name) {
          errors.push({
            filePath,
            message: 'Could not extract ruleblock name from file',
          });
          continue;
        }

        // Replace [[rb_id]] placeholder
        const processedContent = replacePlaceholder(content, name);

        ruleblocks.push({
          name,
          text: processedContent,
        });
      } catch (error) {
        errors.push({
          filePath,
          message: error instanceof Error ? error.message : String(error),
        });
      }
    }

    const loadTimeMs = Date.now() - startTime;

    return {
      ruleblocks,
      errors,
      totalFiles: prbFiles.length,
      loadTimeMs,
    };
  } catch (error) {
    return {
      ruleblocks: [],
      errors: [
        {
          filePath: directoryPath,
          message: `Failed to read directory: ${error instanceof Error ? error.message : String(error)}`,
        },
      ],
      totalFiles: 0,
      loadTimeMs: Date.now() - startTime,
    };
  }
}

/**
 * Load specific ruleblocks by name from a directory
 *
 * @param directoryPath - Path to directory containing .prb files
 * @param names - Array of ruleblock names to load
 * @returns LoaderResult with matching ruleblocks
 */
export async function loadRuleblocksByName(
  directoryPath: string,
  names: string[]
): Promise<LoaderResult> {
  const allResult = await loadRuleblocksFromDirectory(directoryPath);

  const nameSet = new Set(names.map(n => n.toLowerCase()));
  const filtered = allResult.ruleblocks.filter(rb =>
    nameSet.has(rb.name.toLowerCase())
  );

  return {
    ...allResult,
    ruleblocks: filtered,
  };
}

/**
 * Default path to rule_blocks directory
 */
export const DEFAULT_RULEBLOCKS_PATH = join(
  __dirname,
  '../../../../picodomain_rule_pack/rule_blocks'
);
