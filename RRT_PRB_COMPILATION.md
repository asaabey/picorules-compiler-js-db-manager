# RRT.prb Compilation Feature Work

## Original Prompt
> still working on improving picorules-compiler-js-db-validator. we increasing the complexity of rules. i'm trying to compile @picorules-compiler-js/picorules-compiler-js-db-validator/sample-prb/rrt.prb , and its failing compilation. again targetting postgres first

## Assessment

The `rrt.prb` file contains complex Picorules syntax that the current compiler doesn't support. The file is a Renal Replacement Therapy (RRT) status determination ruleblock with ~375 lines.

### Key Issues Identified

1. **Multi-line attribute lists** - Attributes spanning multiple lines
2. **Oracle functions** - `to_number()`, `substr()`, `nvl()`, `sysdate`
3. **Complex null checks** - `expression!?` patterns (e.g., `coalesce(a,b)!?`)
4. **Wildcard attribute patterns** - `enc_op_%`

## Todo List (Completed)

- [x] Fix multi-line attribute list parsing (newlines in [...] blocks)
- [x] Add Oracle→PostgreSQL function translations (sysdate, nvl, to_number, substr)
- [x] Fix null check operators for complex expressions (expression!?)
- [x] Re-test rrt.prb compilation

## Changes Made

### 1. Multi-line Attribute List Normalization
**File:** `picorules-compiler-js-core/src/parsing/ruleblock-parser.ts`

Added whitespace normalization before statement parsing to collapse multi-line `[...]` blocks:

```typescript
const normalizedText = text.replace(/\[\s*([^\]]+?)\s*\]/gs, (_match, inner) => {
  const normalized = inner.replace(/\s+/g, '').trim();
  return `[${normalized}]`;
});
```

### 2. Oracle→PostgreSQL Function Translations
**File:** `picorules-compiler-js-core/src/sql/templates/postgresql-templates.ts`

Added translations in `translateFunctions()`:

| Oracle | PostgreSQL |
|--------|------------|
| `sysdate` | `CURRENT_DATE` |
| `nvl(a, b)` | `COALESCE(a, b)` |
| `to_number(x)` | `(x)::NUMERIC` |
| `substr(str, start, len)` | `SUBSTRING(str FROM start FOR len)` |

### 3. Fixed Null Check Operators for Complex Expressions
**File:** `picorules-compiler-js-core/src/sql/templates/postgresql-templates.ts`

Updated `translateOperators()` to handle both simple and complex patterns:

```typescript
// Handle )!? for function calls like coalesce(a,b)!?
result = result.replace(/\)(\s*)!\?/g, ') IS NOT NULL');
result = result.replace(/(\w+)(\s*)!\?/g, '$1 IS NOT NULL');
```

### 4. Added `translatePredicate()` Helper
Ensures fetch statement predicates get proper Oracle→PostgreSQL translations.

## Test Results

```bash
npm run test:prb sample-prb/rrt.prb -- --dialect postgres
```

**Result:** ✅ Compilation successful (3ms)

### Sample Translations Verified:
- `sysdate-365` → `CURRENT_DATE-365` ✅
- `to_number(substr(loc,2,2))` → `(SUBSTRING(loc FROM 2 FOR 2)::NUMERIC)` ✅
- `nvl(greatest_date(...), lower__bound__dt)` → `COALESCE(NULLIF(GREATEST(...)), lower__bound__dt)` ✅
- `coalesce(rx_l04ad,rx_l04aa)!?` → `coalesce(rx_l04ad,rx_l04aa) IS NOT NULL` ✅
- `tx_dt!?` → `tx_dt IS NOT NULL` ✅

## Features Already Supported (No Changes Needed)

The exploration revealed these were already implemented:
- `.lastdv()`, `.last()`, `.count()`, `.max()`, `.min()` functions
- Underscore property syntax (`._`)
- Wildcard attributes (`[enc_op_%]`)
- `between` operator in where clauses
- `greatest_date()`, `least_date()` functions
