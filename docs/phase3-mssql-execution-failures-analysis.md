# Phase 3: MSSQL Execution Failures Analysis

**Date:** 2026-01-03
**Test Runs:**
- Initial: 24 failures out of 91 executed - 73.6% success
- After fixes: 16 failures out of 100 executed - **84.0% success**

## Fixes Applied

1. **Backtick to single quote conversion** - Picorules uses `` `string` ``, MSSQL uses `'string'`
2. **EXTRACT function** - `EXTRACT(YEAR FROM date)` → `DATEPART(YEAR, date)`
3. **to_number with nested functions** - Use balanced parenthesis matching for `to_number(substr(...))`
4. **Date subtraction (sysdate - variable)** - Convert `sysdate - var` to `DATEDIFF(DAY, var, GETDATE())`
5. **substr() with 2 arguments** - Handle all substr patterns with balanced function replacement:
   - `substr(str, -n)` → `RIGHT(str, n)` (last n characters)
   - `substr(str, n)` → `SUBSTRING(str, n, LEN(str) - n + 1)` (from position n to end)
   - `substr(str, start, len)` → `SUBSTRING(str, start, len)` (standard 3-arg)

## Remaining Failures (16)

### Category 1: Missing Column "loc" (6 failures)
These ruleblocks reference a `loc` column in `.where()` predicates.

| Ruleblock | Error |
|-----------|-------|
| rrt | Invalid column name 'loc' |
| dmg_loc | Invalid column name 'loc' |
| dmg_loc2 | Invalid column name 'loc' |
| dmg_loc_origin | Invalid column name 'loc' |
| rrt_hd_loc | Invalid column name 'loc' |
| rrt_new3_wip | Invalid column name 'loc' |

**Root Cause:** The `loc` (location) column is used in `.where()` clauses but the MSSQL EADV table may not have this column.

**Fix:** Schema issue - add `loc` column to EADV table in MSSQL, or mark these ruleblocks as inactive for MSSQL.

---

### Category 2: DV Column Reference Mismatch (5 failures)
Variables reference columns with `_l_dt` or other non-standard suffixes, but DV functions generate `_val` and `_dt`.

| Ruleblock | Error |
|-----------|-------|
| ckd_egfr_metrics | Invalid column name 'egfr_l_dt' |
| ckd_uacr_metrics | Invalid column name 'acr_l_dt' |
| ckd_dense | Invalid column name 'acr_l_dt' |
| cd_nutr_low | Invalid column name 'wt_dt' |
| ckd_ttem | Invalid column name 'rrt_dt_min' |
| egfr_metrics | Invalid column name 'egfr60_last_dt' |

**Root Cause:** The ruleblocks use non-standard suffixes or reference variables that weren't defined with DV functions.

**Fix:** Review the ruleblock source to understand the intended variable naming convention.

---

### Category 3: Duplicate Temp Table Names (2 failures)

| Ruleblock | Error |
|-----------|-------|
| cd_hepb | There is already an object named '#SQ_e_ag' in the database |
| hba1c_graph | There is already an object named '#SQ_hba1c_graph' in the database |

**Root Cause:** The ruleblock defines the same variable name twice, causing duplicate temp table names.

**Fix:** The compiler could append sequence numbers to duplicate temp table names, or the ruleblocks need to use unique variable names.

---

### Category 4: Date Subtraction (1 failure)

| Ruleblock | Error |
|-----------|-------|
| core_info_entropy | Operand data type date is invalid for subtract operator |

**Root Cause:** There's a date subtraction pattern not yet handled by the translator.

---

### Category 5: Timeout (1 failure)

| Ruleblock | Error |
|-----------|-------|
| cmidx_charlson | Timeout: Request failed to complete in 15000ms |

**Root Cause:** The query is too complex and times out. The Charlson comorbidity index calculation involves many conditions.

**Fix:** Increase timeout or optimize the query.

---

## Summary

| Category | Count | Compiler Fix? | Notes |
|----------|-------|---------------|-------|
| Missing `loc` column | 6 | No | Schema/data issue |
| DV column suffixes | 5 | Maybe | Ruleblock convention issue |
| Duplicate temp tables | 2 | Yes | Add sequence numbers |
| Date subtraction | 1 | Maybe | Edge case not handled |
| Timeout | 1 | No | Query complexity |

## Comparison with PostgreSQL

| Metric | PostgreSQL | MSSQL |
|--------|------------|-------|
| Initial success rate | 73.2% | 73.6% |
| After fixes | 81.6% | 84.0% |
| Executed | 98 | 100 |
| Passed | 80 | 84 |
| Failed | 18 | 16 |
| Skipped | 70 | 68 |

## Recommendations

1. **Schema**: Add `loc` column to EADV table in MSSQL
2. **DV Naming**: Standardize on `_val` and `_dt` suffixes in all ruleblocks
3. **Compiler**: Add sequence numbers to duplicate temp table names
4. **Compiler**: Handle remaining date subtraction edge cases
5. **Timeout**: Increase timeout for complex queries like cmidx_charlson
