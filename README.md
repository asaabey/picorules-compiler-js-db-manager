# Picorules Compiler JS - Database Validator

Database validation tool for `picorules-compiler-js-core`. This package compiles Picorules ruleblocks to SQL and executes them against real Oracle and SQL Server databases to validate correctness.

## Purpose

Before publishing the core compiler to npm, this validator ensures that:
- Compiled SQL is syntactically correct for both Oracle and SQL Server
- SQL executes successfully against real databases
- Results match expected behavior
- All 18 Picorules functions work correctly
- Cross-ruleblock references and dependencies work
- Both SQL dialects produce equivalent results

## Prerequisites

### Oracle Database
- Oracle Database 11g or higher (Oracle XE recommended for testing)
- Oracle Instant Client installed
- Network access to Oracle database

### SQL Server
- SQL Server 2016 or higher (SQL Server Express recommended for testing)
- Network access to SQL Server database

## Installation

```bash
npm install
```

This will install:
- `picorules-compiler-js-core` (from local `../picorules-compiler-js-core`)
- `oracledb` - Oracle database driver
- `mssql` - SQL Server database driver
- Other dependencies

## Configuration

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Edit `.env` with your database credentials:

```env
# Oracle Database Configuration
ORACLE_USER=your_username
ORACLE_PASSWORD=your_password
ORACLE_CONNECT_STRING=localhost:1521/XEPDB1

# SQL Server Configuration
MSSQL_SERVER=localhost
MSSQL_PORT=1433
MSSQL_DATABASE=testdb
MSSQL_USER=sa
MSSQL_PASSWORD=your_password
MSSQL_ENCRYPT=true
MSSQL_TRUST_SERVER_CERTIFICATE=true
```

## Database Setup

### Oracle Setup

1. Create test schema/user:
```sql
CREATE USER picorules_test IDENTIFIED BY your_password;
GRANT CONNECT, RESOURCE TO picorules_test;
GRANT CREATE TABLE TO picorules_test;
GRANT UNLIMITED TABLESPACE TO picorules_test;
```

2. Connect as the test user and run setup script:
```bash
sqlplus picorules_test/your_password@localhost:1521/XEPDB1
SQL> @src/test-data/setup-oracle.sql
```

Or use SQL Developer/SQL*Plus to run [src/test-data/setup-oracle.sql](src/test-data/setup-oracle.sql).

### SQL Server Setup

1. Create test database:
```sql
CREATE DATABASE picorules_test;
GO
USE picorules_test;
GO
```

2. Run setup script:
```bash
sqlcmd -S localhost -U sa -P your_password -d picorules_test -i src/test-data/setup-mssql.sql
```

Or use SQL Server Management Studio to run [src/test-data/setup-mssql.sql](src/test-data/setup-mssql.sql).

## Usage

### Validate Against Oracle

```bash
npm run validate:oracle
```

This will:
1. Connect to Oracle database
2. Compile sample ruleblocks using `Dialect.ORACLE`
3. Execute generated SQL
4. Verify results
5. Display summary report

### Validate Against SQL Server

```bash
npm run validate:mssql
```

This will:
1. Connect to SQL Server database
2. Compile sample ruleblocks using `Dialect.MSSQL`
3. Execute generated SQL
4. Verify results
5. Display summary report

### Validate Against Both

```bash
npm run validate:all
```

Runs validation against both Oracle and SQL Server sequentially.

## Test Suites

The validator runs the following test suites:

### 1. Basic Functions
- `last()` - Last value
- `first()` - First value
- `count()` - Count of records

### 2. Aggregation Functions
- `sum()` - Sum of values
- `avg()` - Average
- `min()` - Minimum
- `max()` - Maximum
- `distinct_count()` - Distinct count
- `median()` - Median value

### 3. Window Functions
- `nth(n)` - Nth value
- `lastdv()` - Last date-value pair
- `firstdv()` - First date-value pair

### 4. String Functions
- `serialize(delimiter)` - Concatenate values
- `serializedv(delimiter)` - Concatenate date-value pairs

### 5. Statistical Functions
- `regr_slope()` - Regression slope
- `regr_intercept()` - Regression intercept
- `regr_r2()` - R-squared coefficient

### 6. Existence Functions
- `exists()` - Check if data exists

### 7. Compute Statements
- Multi-condition CASE logic
- Boolean expressions
- Nested conditions

### 8. Cross-Ruleblock References
- `bind()` statements
- Dependency resolution
- Topological ordering

## Sample Output

```
🚀 Oracle Database Validation
============================================================
✅ Connected to Oracle database

📦 Test Suite: Basic Functions
------------------------------------------------------------

📝 Compiled basic_test (5ms)
🧹 Dropped table ROUT_BASIC_TEST
✅ Executed successfully - 4 rows (45ms)
📊 Sample data: [
  { EID: 1, LAB_COUNT: 5, LAB_LAST: 150 },
  { EID: 2, LAB_COUNT: 3, LAB_LAST: 60 },
  { EID: 4, LAB_COUNT: 3, LAB_LAST: 200 }
]

...

============================================================
📊 VALIDATION SUMMARY
============================================================
Total tests: 9
Passed: 9
Failed: 0
Success rate: 100.0%

✅ All validations passed!
✅ Oracle connection closed
```

## Test Data

Test data is defined in [src/test-data/setup-oracle.sql](src/test-data/setup-oracle.sql) and [src/test-data/setup-mssql.sql](src/test-data/setup-mssql.sql).

**Sample EADV data:**
- Patient 1: 5 lab results (50, 75, 100, 125, 150) + vital signs
- Patient 2: 3 lab results (30, 40, 60)
- Patient 3: No data (for testing exists() = 0)
- Patient 4: 3 lab results (200, 200, 200) - all same value

This data exercises various edge cases:
- Multiple values per patient
- Missing data
- Duplicate values
- Different value ranges

## Validation Results

Each validation returns:
```typescript
{
  ruleblockName: string;
  success: boolean;
  compilationTime: number;  // ms
  executionTime: number;    // ms
  rowCount: number;         // rows in result table
  error?: string;           // if failed
  sql?: string;             // generated SQL
}
```

## Troubleshooting

### Oracle Connection Issues

**Error:** `ORA-12154: TNS:could not resolve the connect identifier`
- Solution: Check `ORACLE_CONNECT_STRING` format (should be `host:port/service_name`)

**Error:** `DPI-1047: Cannot locate a 64-bit Oracle Client library`
- Solution: Install Oracle Instant Client and set `LD_LIBRARY_PATH` (Linux) or `PATH` (Windows)

### SQL Server Connection Issues

**Error:** `Login failed for user 'sa'`
- Solution: Verify SQL Server authentication mode and credentials

**Error:** `Self-signed certificate`
- Solution: Set `MSSQL_TRUST_SERVER_CERTIFICATE=true` in `.env`

### SQL Execution Errors

If SQL execution fails:
1. Check the error message for SQL syntax issues
2. Review the generated SQL in the output
3. Try executing the SQL manually in SQL Developer / SSMS
4. Verify test data exists in EADV table

## Project Structure

```
picorules-compiler-js-db-validator/
├── src/
│   ├── db/
│   │   ├── oracle-connection.ts     # Oracle database wrapper
│   │   └── mssql-connection.ts      # SQL Server database wrapper
│   ├── validators/
│   │   ├── oracle-validator.ts      # Oracle validation logic
│   │   └── mssql-validator.ts       # SQL Server validation logic
│   ├── test-data/
│   │   ├── sample-ruleblocks.ts     # Test ruleblocks
│   │   ├── setup-oracle.sql         # Oracle test data
│   │   └── setup-mssql.sql          # SQL Server test data
│   ├── validate-oracle.ts           # Oracle validation runner
│   └── validate-mssql.ts            # SQL Server validation runner
├── package.json
├── tsconfig.json
├── .env.example
└── README.md
```

## Next Steps

After successful validation:
1. Review validation results to ensure all tests pass
2. Check sample data output to verify correctness
3. If all validations pass, the core compiler is ready for npm publishing
4. If any validations fail, investigate and fix issues in the core compiler

## License

MIT
