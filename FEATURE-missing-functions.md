# Missing Functions Implementation Plan

## Original Request
Fix the 13 ruleblocks that fail compilation before proceeding to SQL execution testing.

## Failure Analysis

### Category 1: Missing Functions (5 functions)

| Function | Used In | Description |
|----------|---------|-------------|
| `stats_mode` | ckd_dense, dmg_loc, dmg_loc2, dmg_source, rrt_hd_location | Statistical mode (most frequent value) |
| `minfdv` | rrt_tx, rrt_tx_card | Minimum value with first date |
| `serialize2` | rx_desc_ptr | Extended value serialization |
| `max_neg_delta_dv` | egfr_metrics | Maximum negative delta with date |
| `temporal_regularity` | rrt_1_metrics, rrt_journey | Temporal pattern regularity metric |

### Category 2: Parser Issues (2 issues)

| Issue | Used In | Description |
|-------|---------|-------------|
| Single wildcard attribute | cd_dm_dx | `eadv.icd_e10%.dt.min()` - wildcard without brackets |
| Complex `.where()` clause | rrt_hd_loc | Multi-line where with complex conditions |

## Implementation Order

### Phase 1: Missing Functions

1. **stats_mode** - Statistical mode
   - Returns most frequent value per patient
   - Uses ranking by count

2. **minfdv** - Minimum First Date-Value
   - Returns `_val` and `_dt` columns
   - Similar to minldv but returns FIRST date the min occurred

3. **serialize2** - Extended Serialization
   - Similar to serialize but may have different encoding

4. **max_neg_delta_dv** - Maximum Negative Delta
   - Calculates deltas between consecutive values
   - Returns maximum decrease with date

5. **temporal_regularity** - Temporal Pattern Analysis
   - Measures regularity of event intervals
   - Returns coefficient of variation or similar metric

### Phase 2: Parser Fixes

6. **Single wildcard attribute parsing**
   - Allow `eadv.icd_e10%.dt.min()` syntax
   - Currently only bracket syntax `[icd_e10%]` works

7. **Complex `.where()` clause parsing**
   - Multi-line support
   - SQL functions in predicates
   - Backtick string literals

## Files to Modify

### Core Compiler (`picorules-compiler-js-core/src/`)

1. **sql/templates/template-interface.ts** - Add 5 function signatures
2. **sql/templates/postgresql-templates.ts** - Implement 5 functions for PostgreSQL
3. **sql/templates/mssql-templates.ts** - Implement 5 functions for T-SQL
4. **sql/templates/oracle-templates.ts** - Implement 5 functions for Oracle
5. **sql/sql-generator.ts** - Add functions to functionMap, update DV_FUNCTIONS set
6. **parsing/fetch-statement-parser.ts** - Fix wildcard pattern parsing (if needed)

## Expected Outcome

After implementation:
- All 168 ruleblocks should compile successfully
- Test harness should report 0 compilation failures
- Ready to proceed with PostgreSQL execution testing
