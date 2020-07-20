# Postgres Utils

This [dbt](https://github.com/fishtown-analytics/dbt) package contains Postgres-specific macros that can be (re)used across dbt projects.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/fishtown-analytics/postgres_utils/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Prerequisites
Postgres Utils is compatible with dbt 0.17.0 and later.

----

## Optimizers

#### index ([source](macros/optimizers/index.sql))
This macro creates an index on a given column.

Usage:
```
{{
config({
    "post-hook": [
      "{{ postgres.index(this, 'id')}}",
    ],
    })
}}
```

#### unique_index ([source](macros/optimizers/uindex.sql))
This macro creates an index on a given column.

Usage:
```
{{
config({
    "post-hook": [
      "{{ postgres.unique_index(this, 'id')}}",
    ],
    })
}}
```


## Acknowlegements

This project extends fishtown-analytics's own postgres project available here:

https://github.com/fishtown-analytics/postgres (source of index macro)
