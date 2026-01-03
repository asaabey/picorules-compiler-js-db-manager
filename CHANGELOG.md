# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-01-04

### Added
- Initial release of picorules-compiler-js-db-manager
- `OracleManager` for Oracle database operations
- `MSSQLManager` for SQL Server database operations
- `PostgreSQLManager` for PostgreSQL database operations
- `BatchExecutor` for manifest-based execution with dependency ordering
- `RuleblockLoader` for loading .prb files from directories
- `MarkdownReporter` for generating test reports
- Database connection classes for Oracle, MSSQL, and PostgreSQL
- CLI tools for testing and validation:
  - `validate:oracle` - Run validation against Oracle database
  - `validate:mssql` - Run validation against SQL Server database
  - `test:prb` - Test individual .prb files
  - `test:all` - Batch test all ruleblocks

### Changed
- Renamed from `picorules-compiler-js-db-validator` to `picorules-compiler-js-db-manager`
- Renamed internal classes from `*Validator` to `*Manager` (e.g., `OracleValidator` → `OracleManager`)
- Renamed `src/validators/` directory to `src/managers/`
