{% macro datename(datepart, date) %}
    {% if datepart|lower in ['year', 'yy', 'yyyy'] %}
        EXTRACT(YEAR FROM {{ date }}::timestamp)::text
    {% elif datepart|lower in ['quarter', 'qq', 'q'] %}
        EXTRACT(QUARTER FROM {{ date }}::timestamp)::text
    {% elif datepart|lower in ['month', 'mm', 'm'] %}
        TO_CHAR({{ date }}::timestamp, 'Month')
    {% elif datepart|lower in ['week', 'wk', 'ww'] %}
        EXTRACT(WEEK FROM {{ date }}::timestamp)::text
    {% elif datepart|lower in ['weekday', 'dw', 'w'] %}
        TO_CHAR({{ date }}::timestamp, 'Day')
    {% elif datepart|lower in ['day', 'dd', 'd'] %}
        EXTRACT(DAY FROM {{ date }}::timestamp)::text
    {% elif datepart|lower in ['hour', 'hh'] %}
        TO_CHAR({{ date }}::timestamp, 'HH24')
    {% elif datepart|lower in ['minute', 'mi', 'n'] %}
        TO_CHAR({{ date }}::timestamp, 'MI')
    {% elif datepart|lower in ['second', 'ss', 's'] %}
        TO_CHAR({{ date }}::timestamp, 'SS')
    {% elif datepart|lower in ['millisecond', 'ms'] %}
        (EXTRACT(MILLISECONDS FROM {{ date }}::timestamp))::text
    {% else %}
        {{ exceptions.raise_compiler_error("Invalid datepart for datename: " ~ datepart) }}
    {% endif %}
{% endmacro %} 