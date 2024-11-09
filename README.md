# Postgres Utils

This [dbt](https://github.com/dbt-labs/dbt-core) package contains Postgres-specific macros that can be (re)used across dbt projects.

## Installation Instructions

Check [dbt Hub](https://hub.getdbt.com/sgoley/postgres_utils/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Prerequisites

Postgres Utils is compatible with dbt Core 1.0.0 and later versions. This package is actively maintained to stay compatible with the latest stable dbt release.

---

## Features & Contents

### Constraints

#### check_constraint ([source](macros/constraints/check_constraint.sql))

Adds a CHECK constraint to a table.

```sql
{{ pg_check_constraint(this, 'age', 'age >= 0 AND age <= 150') }}
```

#### not_null_constraint ([source](macros/constraints/not_null_constraint.sql))

Adds a NOT NULL constraint to a column.

```sql
{{ pg_not_null(this, 'id') }}
```

#### unique_constraint ([source](macros/constraints/unique_constraint.sql))

Adds a UNIQUE constraint to one or more columns.

```sql
{{ pg_unique(this, 'email') }}
```

#### primary_key ([source](macros/constraints/primary_key_constraint.sql))

Adds a PRIMARY KEY constraint.

```sql
{{ pg_primary_key(this, 'id') }}
```

#### foreign_key ([source](macros/constraints/foreign_key_constraint.sql))

Adds a FOREIGN KEY constraint.

```sql
{{ pg_foreign_key(this, 'customer_id', ref('customers'), 'id') }}
```

### Date Functions

#### dateadd ([source](macros/dates/dateadd.sql))

Adds a specified number of date or time units to a date.

```sql
{{ dateadd('day', 7, 'created_at') }}
```

#### datediff ([source](macros/dates/datediff.sql))

Returns the difference between two dates in specified units.

```sql
{{ datediff('day', 'start_date', 'end_date') }}
```

#### datefromparts ([source](macros/dates/datefromparts.sql))

Creates a date from year, month, and day integers.

```sql
{{ datefromparts(2023, 12, 25) }}
```

#### datename ([source](macros/dates/datename.sql))

Returns a string representing the specified datepart.

```sql
{{ datename('month', 'created_at') }}
```

#### datepart ([source](macros/dates/datepart.sql))

Returns an integer representing the specified datepart.

```sql
{{ datepart('year', 'created_at') }}
```

### Grants

#### grant_core ([source](macros/grants/grant_core.sql))

Core macro for granting privileges.

```sql
{{ pg_grant_core(this, 'SELECT', 'analyst_role') }}
```

#### grant_by_tags ([source](macros/grants/tag_based_grants.sql))

Grants privileges based on model tags.

```sql
{{ pg_grant_by_tags('reader_role', 'SELECT', exclude_tags=['sensitive']) }}
```

#### preserve_grants ([source](macros/grants/preserve_grants.sql))

Preserves existing grants when a relation is rebuilt.

```sql
{{ config(post-hook="{{ pg_preserve_grants(this) }}") }}
```

#### record_grants ([source](macros/grants/permission_graph.sql))

Records all current grants to a tracking table.

```sql
{{ pg_record_grants() }}
```

### Indexes

#### index ([source](macros/indexes/index.sql))

Creates or replaces an index with configurable options.

```sql
{{ index(this, 'id') }}
```

#### specialized indexes ([source](macros/indexes/specialized_indexes.sql))

Shortcuts for common index types:

```sql
{{ uindex(this, 'email') }}  -- Unique index
{{ gist_index(this, 'location') }}  -- GiST index for geometric data
{{ gin_index(this, 'tags') }}  -- GIN index for array/jsonb data
{{ brin_index(this, 'created_at') }}  -- BRIN index for large tables
{{ partial_index(this, 'status', "status != 'deleted'") }}  -- Partial index
```

## Advanced Usage

### Tag-Based Security

You can use tags to automatically manage access to sensitive data:

```sql
-- In dbt_project.yml
on-run-end: "{{ pg_configure_access_roles() }}"

-- In your model
{{ config(tags=['sensitive', 'financial']) }}
```

### Preserving Grants

To automatically preserve grants when models are rebuilt:

```sql
-- In your model config
{{ config(
    post-hook="{{ pg_preserve_grants(this) }}"
) }}
```

### Complex Indexes

Create sophisticated indexes with multiple options:

```sql
{{ index(
    this,
    columns=['category', 'created_at'],
    method='btree',
    unique=true,
    name='custom_idx',
    where="category != 'test'",
    include='description',
    fillfactor=90,
    concurrent=true
) }}
```

---

## Resources

- [dbt Core Documentation](https://docs.getdbt.com)
- [dbt Core GitHub](https://github.com/dbt-labs/dbt-core)
- [dbt Community](https://www.getdbt.com/community/)

## Acknowledgements

This project was inspired by and builds upon the work of the dbt Labs team and the dbt Community.
