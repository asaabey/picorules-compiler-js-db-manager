# Picorules Test Harness Feature

## Original Request
> Let's work on a test harness that will test all the rules in the given folder (/home/asaabey/projects/tkc/tkc-picorules-rules/picodomain_rule_pack/rule_blocks). So I think we'll have to break it down into a few phases. The first phase will compile each rule and see if it compiles to SQL. Then we will have to work out the manifest and according to the order, execute each SQL against the given platform, maybe MS SQL or PostgreSQL, and then catch any errors and then iteratively fix those.

## Status: COMPLETED (Phase 1 & 2)

The test harness has been implemented and is working. It successfully:
- Loads all 168 .prb files from the rule_blocks directory
- Compiles them using the JS compiler for PostgreSQL dialect
- Generates a markdown report with detailed results
- Identifies which ruleblocks fail compilation individually

## Files Created

| File | Purpose |
|------|---------|
| `src/loaders/ruleblock-loader.ts` | Loads .prb files from directory |
| `src/runners/batch-compilation-runner.ts` | Compiles all ruleblocks together |
| `src/reporters/markdown-reporter.ts` | Generates markdown test reports |
| `src/test-all-ruleblocks.ts` | CLI entry point |

## Usage

```bash
# Test all ruleblocks (compile + execute against PostgreSQL)
npm run test:all

# Compile only (no database required)
npm run test:all:compile-only

# Show individual failures
npm run test:all:compile-only -- --show-individual

# Test specific ruleblocks
npm run test:all -- --filter "dmg,ckd,rrt"

# Continue on failure to see all errors
npm run test:all -- --continue-on-failure

# Help
npm run test:all -- --help
```

## Current Test Results

### Summary
- **Total .prb files:** 168
- **Loaded successfully:** 168
- **Individual compilation failures:** 13

### Failed Ruleblocks (13)

| Ruleblock | Issue |
|-----------|-------|
| cd_dm_dx | Wildcard attribute pattern `icd_e10%` not supported |
| ckd_dense | Unsupported function: `stats_mode` |
| dmg_loc | Unsupported function: `stats_mode` |
| dmg_loc2 | Unsupported function: `stats_mode` |
| dmg_source | Unsupported function: `stats_mode` |
| egfr_metrics | Unsupported function: `max_neg_delta_dv` |
| rrt_1_metrics | Unsupported function: `temporal_regularity` |
| rrt_hd_loc | Complex `.where()` clause parsing issue |
| rrt_hd_location | Unsupported function: `stats_mode` |
| rrt_journey | Unsupported function: `temporal_regularity` |
| rrt_tx | Unsupported function: `minfdv` |
| rrt_tx_card | Unsupported function: `minfdv` |
| rx_desc_ptr | Unsupported function: `serialize2` |

### Missing Functions in JS Compiler

The following functions are used in production ruleblocks but not implemented in the JS compiler:

1. `stats_mode` - Statistical mode function
2. `max_neg_delta_dv` - Maximum negative delta with date-value
3. `temporal_regularity` - Temporal pattern analysis
4. `minfdv` - Minimum first date-value
5. `serialize2` - Extended serialization

## Environment Variables

For database execution, set these in a `.env` file:

```bash
PG_HOST=localhost
PG_PORT=5432
PG_DATABASE=tkc_clinical
PG_USER=postgres
PG_PASSWORD=your_password
```

## Next Steps

1. **Add missing functions to JS compiler** - Implement `stats_mode`, `minfdv`, `serialize2`, etc.
2. **Fix wildcard attribute parsing** - Support `eadv.icd_e10%.dt.min()` syntax
3. **Fix complex `.where()` parsing** - Handle multi-condition where clauses
4. **Run against PostgreSQL** - Execute compiled SQL against real database
5. **Iterate on fixes** - Fix SQL generation issues discovered during execution

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    test-all-ruleblocks.ts                   │
│                      (CLI Entry Point)                      │
└─────────────────────────────────────────────────────────────┘
                              │
         ┌────────────────────┼────────────────────┐
         ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ ruleblock-loader│  │batch-compilation│  │markdown-reporter│
│                 │  │     -runner     │  │                 │
│ Load .prb files │  │ Compile to SQL  │  │ Generate report │
└─────────────────┘  └─────────────────┘  └─────────────────┘
         │                    │                    │
         │                    ▼                    │
         │           ┌─────────────────┐           │
         │           │ BatchExecutor   │           │
         │           │ (existing)      │           │
         │           │ Execute SQL     │           │
         │           └─────────────────┘           │
         │                    │                    │
         └────────────────────┴────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │   PostgreSQL    │
                    │   (optional)    │
                    └─────────────────┘
```

## Report Location

Reports are generated in: `picorules-compiler-js-db-validator/reports/`

Filename format: `report-postgresql-YYYY-MM-DDTHH-MM-SS.md`
