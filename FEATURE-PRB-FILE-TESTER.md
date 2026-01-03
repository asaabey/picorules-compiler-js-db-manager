# Feature: Individual .prb File Testing and SQL Generation

**Date:** 2026-01-01
**Status:** Complete
**Original Request:** Add ability for validator to test a file in the sample-prb folder, generate SQL output, save to file, and execute against MSSQL database

## Overview

Added a CLI tool (`test-prb-file.ts`) that allows testing individual Picorules `.prb` files from the `sample-prb` folder (or any location), generates SQL output, saves it to a `.sql` file, and optionally executes against MSSQL database - all without requiring full validation suite execution.

## Implementation Details

### Files Created/Modified

1. **Created:** [src/test-prb-file.ts](src/test-prb-file.ts)
   - Main CLI tool for testing individual .prb files
   - Reads .prb files from filesystem
   - Parses and compiles to SQL using picorules-compiler-js-core
   - Supports multiple SQL dialects (Oracle, MSSQL, PostgreSQL)
   - Optional database execution via Oracle/MSSQL validators
   - Includes comment stripping to handle malformed comments in .prb files

2. **Modified:** [package.json](package.json)
   - Added `test:prb` script for easy CLI access

3. **Modified:** [README.md](README.md)
   - Added usage documentation and examples

### Key Features

#### 1. File Parsing
- Reads `.prb` files from any path (relative or absolute)
- Automatically extracts ruleblock name from `#define_ruleblock()` directive
- Falls back to filename if directive not found
- Strips C-style comments (`/* */` and `//`) from source before compilation

#### 2. Comment Stripping
Handles multiple comment formats:
- Complete multiline comments: `/* ... */`
- Incomplete/malformed multiline comments: `/* ...` (without closing)
- Single-line comments: `// ...`

This preprocessing step ensures the compiler doesn't choke on documentation comments.

#### 2.5. [[rb_id]] Placeholder Replacement
Implements Picorules convention for ruleblock ID placeholders:
- Detects `[[rb_id]]` placeholder in `.prb` files
- Replaces all occurrences with the actual ruleblock name (filename without .prb extension)
- Supports usage in:
  - `#define_ruleblock([[rb_id]], ...)`
  - Variable names: `[[rb_id]] : { ... }`
  - `#define_attribute([[rb_id]], ...)`
- Example: In `rule2.prb`, all `[[rb_id]]` become `rule2`

#### 3. SQL Generation
- Compiles to MSSQL SQL by default (changed from Oracle)
- Supports `--dialect` flag for Oracle, MSSQL, and PostgreSQL
- Displays generated SQL in formatted output
- Shows compilation time metrics
- **Automatically saves SQL to `.sql` file** in same directory as `.prb` file

#### 4. SQL File Output
- Default: saves to `<ruleblock>.sql` in same directory as source `.prb` file
- Custom output path via `--output` flag
- Includes full SQL with proper formatting and comments
- **Automatically prepends `DROP TABLE IF EXISTS` statement** for safe re-execution
- Makes SQL files self-contained and idempotent

#### 5. Database Execution
- `--execute` flag executes against MSSQL database
- Uses MSSQLValidator infrastructure
- Displays execution results, row counts, and sample data
- Requires EADV table to exist in database

## Usage Examples

### Basic SQL Generation (MSSQL)
```bash
npm run test:prb -- sample-prb/rule1.prb
```
Generates SQL and saves to `sample-prb/rule1.sql`

### Specific SQL Dialect
```bash
npm run test:prb -- sample-prb/rule1.prb --dialect oracle
npm run test:prb -- sample-prb/rule1.prb --dialect postgres
```

### Custom Output Location
```bash
npm run test:prb -- sample-prb/rule1.prb --output output/rule1.sql
```

### Execute Against MSSQL Database
```bash
npm run test:prb -- sample-prb/rule1.prb --execute
```

### Debug Mode
```bash
DEBUG=1 npm run test:prb -- sample-prb/rule1.prb
```

**Note:** The `--` separator is required when passing arguments through npm.

## Sample Output

```
🔧 Picorules File Tester
============================================================
📄 File: sample-prb/rule1.prb
🎯 Dialect: oracle

✅ Loaded ruleblock: rule1

📝 Compiling to SQL...
✅ Compilation successful (2ms)

📋 Generated SQL:
============================================================
--------------------------------------------------
-- Ruleblock: rule1
--------------------------------------------------
CREATE TABLE ROUT_RULE1 AS
WITH
  UEADV AS (
    SELECT DISTINCT eid FROM eadv
  ),
SQ_EGFR AS (
    SELECT eid, val AS egfr
    FROM (
      SELECT eid, val,
             ROW_NUMBER() OVER (PARTITION BY eid ORDER BY dt DESC) AS rn
      FROM eadv
      WHERE att = 'lab_bld_egfr_c'
    )
    WHERE rn = 1
  ),
...
============================================================

✨ Done!
```

## Technical Design Decisions

### Why Comment Stripping?
The compiler core doesn't currently handle comments in the parsing phase. Rather than modify the core parser (which would require testing across all dialects and use cases), we opted for preprocessing in the test tool. This:
- Keeps the change isolated to the testing utility
- Doesn't affect production compiler behavior
- Allows quick iteration on .prb test files

### Regex Patterns Used
```typescript
// Complete multiline comments
text.replace(/\/\*[\s\S]*?\*\//g, '');

// Incomplete multiline comments (malformed)
text.replace(/^\s*\/\*.*$/gm, '');

// Single-line comments
text.replace(/\/\/.*$/gm, '');
```

### Future Enhancements
1. Add comment stripping to compiler core for production use
2. Add syntax highlighting for SQL output
3. Support batch testing of multiple .prb files
4. Add JSON output format for programmatic use
5. Add Oracle execution support (currently only MSSQL)

## Testing

### SQL Generation Test
Tested with [sample-prb/rule1.prb](sample-prb/rule1.prb):
- ✅ Successfully strips malformed comment on line 1
- ✅ Parses ruleblock name from `#define_ruleblock` directive
- ✅ Generates valid MSSQL SQL with proper CTEs and JOINs
- ✅ Saves SQL to [sample-prb/rule1.sql](sample-prb/rule1.sql)
- ✅ Correctly identifies fetch statements and compute statements

### Database Execution Test
Executed against MSSQL database:
- ✅ Connected to SQL Server successfully
- ✅ Dropped existing ROUT_RULE1 table
- ✅ Executed compiled SQL successfully
- ✅ **Results: 9,446 rows** in 1,346ms
- ✅ Sample data shows correct calculation of `egfr`, `ckd`, and `rule1` fields
- ✅ Verified CKD detection logic (eGFR < 90 = CKD)

## Related Components

- **Compiler Core:** `picorules-compiler-js-core` - provides compile() function
- **MSSQL Validator:** [src/validators/mssql-validator.ts](src/validators/mssql-validator.ts) - for MSSQL database execution
- **MSSQL Connection:** [src/db/mssql-connection.ts](src/db/mssql-connection.ts) - database connection wrapper
- **Sample Files:** [sample-prb/](sample-prb/) - test .prb files

## Updates

### 2026-01-01: Implemented Helper Function Translation

**Issue 1**: The '.' (dot) shortcut in Picorules compute statements was not being translated to valid SQL.

**Issue 2**: Helper functions like `least_date()`, `greatest_date()`, `least()`, and `greatest()` were not being translated to dialect-specific SQL.

**Solution**: Implemented `translateFunctions()` for all three SQL dialects based on the Python picodomain implementation:

**MSSQL Functions**:
- `least_date(a,b,...)` → `(SELECT MIN(x) FROM (VALUES (a), (b)) AS T(x) WHERE x IS NOT NULL)`
- `greatest_date(a,b,...)` → `(SELECT MAX(x) FROM (VALUES (a), (b)) AS T(x) WHERE x IS NOT NULL)`
- `least(a,b)` → Uses CASE WHEN with NULL checks
- `greatest(a,b)` → Uses CASE WHEN with NULL checks

**Oracle Functions**:
- `least_date(a,b,...)` → `NULLIF(LEAST(COALESCE(a, TO_DATE('9999-12-31', 'YYYY-MM-DD')), ...), TO_DATE('9999-12-31', 'YYYY-MM-DD'))`
- `greatest_date(a,b,...)` → `NULLIF(GREATEST(COALESCE(a, TO_DATE('0001-01-01', 'YYYY-MM-DD')), ...), TO_DATE('0001-01-01', 'YYYY-MM-DD'))`
- `least(a,b,...)` → Native `LEAST()` function
- `greatest(a,b,...)` → Native `GREATEST()` function

**PostgreSQL Functions**:
- `least_date(a,b,...)` → `NULLIF(LEAST(COALESCE(a, '9999-12-31'::DATE), ...), '9999-12-31'::DATE)`
- `greatest_date(a,b,...)` → `NULLIF(GREATEST(COALESCE(a, '0001-01-01'::DATE), ...), '0001-01-01'::DATE)`
- `least(a,b,...)` → Native `LEAST()` function
- `greatest(a,b,...)` → Native `GREATEST()` function

**Testing**: Verified with [rule2.prb:15](rule2.prb#L15) containing `code_fd : { . => least_date(icd_fd,icpc_fd)};`:
- ✅ MSSQL: `WHEN 1=1 THEN (SELECT MIN(x) FROM (VALUES (icd_fd), (icpc_fd)) AS T(x) WHERE x IS NOT NULL)`
- ✅ Oracle: `WHEN 1=1 THEN NULLIF(LEAST(COALESCE(icd_fd, TO_DATE('9999-12-31', 'YYYY-MM-DD')), COALESCE(icpc_fd, TO_DATE('9999-12-31', 'YYYY-MM-DD'))), TO_DATE('9999-12-31', 'YYYY-MM-DD'))`
- ✅ PostgreSQL: `WHEN 1=1 THEN NULLIF(LEAST(COALESCE(icd_fd, '9999-12-31'::DATE), COALESCE(icpc_fd, '9999-12-31'::DATE)), '9999-12-31'::DATE)`

**Also Fixed**: Corrected `Dialect.POSTGRES` → `Dialect.POSTGRESQL` enum mapping in [test-prb-file.ts:46](test-prb-file.ts#L46).

## Notes

- Default dialect changed from Oracle to MSSQL for better alignment with current testing environment
- Assumes EADV table exists when using `--execute` flag
- Database credentials must be configured in `.env` for execution mode
- The tool is primarily for development/debugging workflows
- Not intended for production compilation (use compiler core directly)
- Successfully tested with real EADV data containing 9,446+ patient records
- The '.' shortcut is a Picorules DSL convention for "always true" condition (equivalent to `1=1` in SQL)
