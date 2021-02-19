# Postgres Utils

This [dbt](https://github.com/fishtown-analytics/dbt) package contains Postgres-specific macros that can be (re)used across dbt projects.

## Installation Instructions

Check [dbt Hub](https://hub.getdbt.com/fishtown-analytics/postgres_utils/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Prerequisites

Postgres Utils is compatible with dbt 0.17.0 and later.

## Features & Contents

### Optimizers

#### index ([source](macros/optimizers/index.sql))
This macro creates an index on a given column. 

Usage (at end of model definition .sql file):
```
{{
config({
    "post-hook": [
      "{{ postgres_utils.index(this, 'id')}}",
    ],
    })
}}
```

#### uindex ([source](macros/optimizers/uindex.sql))
This macro creates an index on a given column.

Usage (at end of model definition .sql file):
```
{{
config({
    "post-hook": [
      "{{ postgres_utils.uindex(this, 'id')}}",
    ],
    })
}}
```

## Resources

#### DBT-Core Postgres Plugin

The DBT Core definitions for all postgres specific macros are located here:

- [DBT Core Postgres](https://github.com/fishtown-analytics/dbt/tree/master/plugins/postgres)

## Acknowlegements

This project extends fishtown-analytics's own postgres project available here:

https://github.com/fishtown-analytics/postgres (source of index macro)
