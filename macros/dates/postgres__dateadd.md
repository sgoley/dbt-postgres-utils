{% docs postgres__datediff %}

#### dateadd ([source](macros/dates/postgres__dateadd.sql))
This macro adds a time/day interval to the supplied date/timestamp. Note: The `datepart` argument is database-specific.

Usage:
```
{{ dbt_utils.dateadd(datepart='day', interval=1, from_date_or_timestamp="'2017-01-01'") }}
```

{% enddocs %}