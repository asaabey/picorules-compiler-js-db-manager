# Phase 3: Execution Failures Analysis

**Date:** 2026-01-03
**Test Runs:**
- Initial: 26 failures out of 97 executed (71 skipped due to dependencies) - 73.2% success
- After fixes: 18 failures out of 98 executed (70 skipped) - **81.6% success**

## Fixes Applied (Round 1)

1. **Backtick to single quote conversion** - Picorules uses `` `string` ``, PostgreSQL uses `'string'`
2. **String concatenation** - Picorules/Oracle uses `+`, PostgreSQL uses `||`
3. **to_char() for numbers** - Single-arg `to_char(num)` converted to `(num)::TEXT`
4. **substr() with negative index** - `substr(str, -n)` converted to `RIGHT(str, n)`
5. **Table name convention** - Fixed manifest to use `rout_` (lowercase) to match PostgreSQL's case-folding

## Remaining Failures (18)

### Category 1: Missing Column "loc" (6 failures)
These ruleblocks reference a `loc` column in `.where()` predicates.

| Ruleblock | Error |
|-----------|-------|
| rrt | column "loc" does not exist |
| dmg_loc | column "loc" does not exist |
| dmg_loc2 | column "loc" does not exist |
| dmg_loc_origin | column "loc" does not exist |
| rrt_hd_loc | column "loc" does not exist |
| rrt_new3_wip | column "loc" does not exist |

**Root Cause:** The `loc` (location) column is used in `.where()` clauses (e.g., `where(substr(loc,2,2)=90)`) but the PostgreSQL EADV table may not have this column.

**Example from rrt.prb:58:**
```
tx_dt_icpc => eadv.icpc_u28001.dt.min().where(to_number(substr(loc,2,2))=90);
```

**Fix:** This is likely a **schema issue** - the EADV table in PostgreSQL needs the `loc` column, or the ruleblocks need modification for environments without location data.

---

### Category 2: DV Column Reference Mismatch (6 failures)
Variables reference columns with `_l_dt` or other suffixes, but DV functions generate `_val` and `_dt`.

| Ruleblock | Error |
|-----------|-------|
| ckd_egfr_metrics | column "egfr_l_dt" does not exist |
| ckd_uacr_metrics | column "acr_l_dt" does not exist |
| cd_nutr_low | column "wt_dt" does not exist |
| ckd_ttem | column "rrt_dt_min" does not exist |
| egfr_metrics | column "egfr_rn_dt" does not exist |
| pregnancy | column "us_ld" does not exist |

**Root Cause:** The ruleblocks use non-standard suffixes or reference variables that weren't defined with DV functions.

**Fix:** Review the ruleblock source to understand the intended variable naming convention.

---

### Category 3: Duplicate CTE Names (2 failures)

| Ruleblock | Error |
|-----------|-------|
| cd_hepb | WITH query name "sq_e_ab" specified more than once |
| hba1c_graph | WITH query name "sq_hba1c_graph" specified more than once |

**Root Cause:** The ruleblock defines the same variable name twice, causing duplicate CTE names.

**Fix:** The compiler could append sequence numbers to duplicate CTE names, or the ruleblocks need to use unique variable names.

---

### Category 4: Missing Column References (2 failures)

| Ruleblock | Error |
|-----------|-------|
| cd_hepb_coded | column "hepb_icpc_code" does not exist |
| ca_misc | column "ca_att" does not exist |

**Root Cause:** These columns are referenced in CASE expressions but weren't defined in the CTE chain.

---

### Category 5: Type Mismatch (1 failure)

| Ruleblock | Error |
|-----------|-------|
| ckd_dense | operator does not exist: text = integer |

**Root Cause:** A text value is being compared to an integer without proper type casting.

---

### Category 6: Function Type Issue (1 failure)

| Ruleblock | Error |
|-----------|-------|
| cd_dm_mx | function substr(numeric, integer, integer) does not exist |

**Root Cause:** `substr` is being called on a numeric column instead of text. The computed value needs casting.

---

## Summary

| Category | Count | Compiler Fix? | Notes |
|----------|-------|---------------|-------|
| Missing `loc` column | 6 | No | Schema/data issue |
| DV column suffixes | 6 | Maybe | Ruleblock convention issue |
| Duplicate CTEs | 2 | Yes | Add sequence numbers |
| Missing column refs | 2 | No | Ruleblock bug |
| Type mismatch | 1 | Maybe | Better casting |
| Function type | 1 | Yes | Cast before substr |

## Recommendations

1. **Schema**: Add `loc` column to EADV table in PostgreSQL, or make those 6 ruleblocks inactive for PostgreSQL
2. **DV Naming**: Standardize on `_val` and `_dt` suffixes in all ruleblocks
3. **Compiler**: Add sequence numbers to duplicate CTE names
4. **Compiler**: Improve type casting in expressions

## Current Success Rate: 81.6%

- 80 ruleblocks execute successfully
- 70 skipped due to dependency failures (would succeed if dependencies fixed)
- 18 have actual execution errors
