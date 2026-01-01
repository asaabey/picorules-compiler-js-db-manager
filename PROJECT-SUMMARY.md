# Database Validator - Project Summary

**Created:** 2026-01-01
**Purpose:** Validate `picorules-compiler-js-core` v1.0.0 against real databases before npm publishing

## Objective

Before publishing the Picorules compiler to npm, we need to validate that the compiled SQL:
1. Is syntactically correct for Oracle PL/SQL and SQL Server T-SQL
2. Executes successfully against real databases
3. Produces correct results
4. Handles all 18 Picorules functions
5. Correctly resolves cross-ruleblock dependencies

## Architecture

### Components

**Database Connections:**
- [src/db/oracle-connection.ts](src/db/oracle-connection.ts) - Oracle database wrapper using `oracledb`
- [src/db/mssql-connection.ts](src/db/mssql-connection.ts) - SQL Server wrapper using `mssql`

**Validators:**
- [src/validators/oracle-validator.ts](src/validators/oracle-validator.ts) - Compiles & executes Oracle SQL
- [src/validators/mssql-validator.ts](src/validators/mssql-validator.ts) - Compiles & executes SQL Server SQL

**Test Data:**
- [src/test-data/sample-ruleblocks.ts](src/test-data/sample-ruleblocks.ts) - 9 test suites covering all functions
- [src/test-data/setup-oracle.sql](src/test-data/setup-oracle.sql) - Oracle EADV test data
- [src/test-data/setup-mssql.sql](src/test-data/setup-mssql.sql) - SQL Server EADV test data

**Runners:**
- [src/validate-oracle.ts](src/validate-oracle.ts) - Oracle validation runner
- [src/validate-mssql.ts](src/validate-mssql.ts) - SQL Server validation runner

### Test Suites

1. **Basic Functions** - `last()`, `first()`, `count()`
2. **Aggregation Functions** - `sum()`, `avg()`, `min()`, `max()`, `distinct_count()`, `median()`
3. **Window Functions** - `nth(n)`, `lastdv()`, `firstdv()`
4. **String Functions** - `serialize()`, `serializedv()`
5. **Statistical Functions** - `regr_slope()`, `regr_intercept()`, `regr_r2()`
6. **Existence Functions** - `exists()`
7. **Compute Statements** - CASE logic, boolean expressions
8. **Cross-Ruleblock References** - `bind()`, dependency ordering

## Dependencies

### Runtime
- `picorules-compiler-js-core` (file:../picorules-compiler-js-core) - The compiler being validated
- `oracledb` ^6.0.0 - Oracle database driver
- `mssql` ^10.0.0 - SQL Server database driver
- `dotenv` ^16.0.0 - Environment variable management

### Development
- `typescript` ^5.3.0
- `tsx` ^4.0.0 - TypeScript execution
- `vitest` ^1.0.0 - Testing framework
- `@types/node` ^20.0.0

## Usage Flow

1. **Setup**: User creates EADV test tables in both databases using setup scripts
2. **Configure**: User sets database credentials in `.env`
3. **Run Validator**:
   - `npm run validate:oracle` - Tests Oracle compilation & execution
   - `npm run validate:mssql` - Tests SQL Server compilation & execution
4. **Review Results**: Validator displays:
   - Compilation time for each ruleblock
   - Execution time
   - Row counts
   - Sample data
   - Success/failure status
   - Summary statistics

## Validation Process

For each ruleblock:
1. Compile using `picorules-compiler-js-core`
2. Check compilation success
3. Drop any existing result table
4. Execute generated SQL
5. Query result table for row count
6. Retrieve sample data (top 5 rows)
7. Display results and metrics
8. Record success/failure

For cross-reference tests:
1. Compile all ruleblocks together (preserves dependencies)
2. Clean up all result tables
3. Execute SQLs in topological order
4. Verify final table has correct results

## Test Data Design

**EADV Table Structure:**
```sql
CREATE TABLE EADV (
    eid     NUMBER/INT,        -- Patient ID
    att     VARCHAR(100),       -- Attribute name (e.g., 'lab_result')
    dt      DATE/DATETIME,      -- Date of observation
    val     VARCHAR(1000),      -- Value
    PRIMARY KEY (eid, att, dt)
);
```

**Patient Data:**
- **Patient 1**: 5 lab results (50, 75, 100, 125, 150) - Tests ordering and aggregation
- **Patient 2**: 3 lab results (30, 40, 60) - Tests multiple patients
- **Patient 3**: No records - Tests `exists() = 0`
- **Patient 4**: 3 identical values (200) - Tests duplicate handling

This data exercises:
- Multiple values per patient
- Different value ranges
- Missing data scenarios
- Duplicate values
- Date ordering

## Expected Results

### Aggregation Test (Patient 1)
- `sum = 500` (50+75+100+125+150)
- `avg = 100` ((50+75+100+125+150)/5)
- `min = 50`
- `max = 150`
- `count = 5`
- `distinct_count = 5`
- `median = 100`

### Window Test (Patient 1)
- `first = 50` (earliest date)
- `last = 150` (latest date)
- `nth(2) = 75` (second value by date)

### Exists Test
- Patient 1: `has_lab = 1`, `has_vital = 1`
- Patient 3: `has_lab = 0`, `has_vital = 0`

## Success Criteria

The validator is considered successful if:
1. All test suites compile without errors
2. All SQL statements execute without errors
3. Result tables contain expected number of rows
4. Sample data shows reasonable values
5. Both Oracle and SQL Server produce equivalent results

## File Structure

```
picorules-compiler-js-db-validator/
├── src/
│   ├── db/                      # Database connection modules
│   ├── validators/              # Validation logic
│   ├── test-data/               # Test ruleblocks and SQL setup
│   ├── validate-oracle.ts       # Oracle runner
│   └── validate-mssql.ts        # SQL Server runner
├── package.json                 # Dependencies and scripts
├── tsconfig.json                # TypeScript config
├── vitest.config.ts             # Vitest config
├── .env.example                 # Environment template
├── .gitignore                   # Git ignore rules
├── README.md                    # Setup and usage guide
└── PROJECT-SUMMARY.md           # This file
```

## Next Steps

1. User sets up Oracle and SQL Server test databases
2. User runs setup scripts to create EADV test data
3. User configures `.env` with credentials
4. User runs `npm run validate:oracle`
5. User runs `npm run validate:mssql`
6. If all validations pass → Core compiler v1.0.0 is ready for npm publishing
7. If validations fail → Investigate and fix issues in core compiler

## Notes

- This is a **private** package (not published to npm)
- Uses local file dependency: `picorules-compiler-js-core`
- Requires actual database instances (not mocked)
- Validation is end-to-end: compile → execute → verify
- Can be run repeatedly during development

---

**Status:** ✅ Ready for testing
**Version:** 0.1.0
**Core Compiler Version:** 1.0.0
