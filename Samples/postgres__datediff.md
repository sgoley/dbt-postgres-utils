{% docs postgres__datediff %}

#### datediff ([source](macros/dates/postgres__datediff.sql))
This macro calculates the difference between two dates.

Usage:
```
{{ dbt_utils.datediff("'2018-01-01'", "'2018-01-20'", 'day') }}
```

{% enddocs %}