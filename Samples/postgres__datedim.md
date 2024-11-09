{% docs postgres__datediff %}

#### datedim ([source](macros/dates/postgres__datedim.sql))
This macro generates a calendar dimensional table starting from the dbt_utils macro "date spine"

Usage:
```
{{ postgres_utils.datedim("'11/01/2009'", "40", "11") }}
```

{% enddocs %}