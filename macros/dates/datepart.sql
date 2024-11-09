{% macro datepart(datepart, date) %}
    {% if datepart|lower in ['year', 'yy', 'yyyy'] %}
        EXTRACT(YEAR FROM {{ date }}::timestamp)
    {% elif datepart|lower in ['quarter', 'qq', 'q'] %}
        EXTRACT(QUARTER FROM {{ date }}::timestamp)
    {% elif datepart|lower in ['month', 'mm', 'm'] %}
        EXTRACT(MONTH FROM {{ date }}::timestamp)
    {% elif datepart|lower in ['week', 'wk', 'ww'] %}
        EXTRACT(WEEK FROM {{ date }}::timestamp)
    {% elif datepart|lower in ['weekday', 'dw', 'w'] %}
        EXTRACT(DOW FROM {{ date }}::timestamp)
    {% elif datepart|lower in ['day', 'dd', 'd'] %}
        EXTRACT(DAY FROM {{ date }}::timestamp)
    {% elif datepart|lower in ['hour', 'hh'] %}
        EXTRACT(HOUR FROM {{ date }}::timestamp)
    {% elif datepart|lower in ['minute', 'mi', 'n'] %}
        EXTRACT(MINUTE FROM {{ date }}::timestamp)
    {% elif datepart|lower in ['second', 'ss', 's'] %}
        EXTRACT(SECOND FROM {{ date }}::timestamp)
    {% elif datepart|lower in ['millisecond', 'ms'] %}
        EXTRACT(MILLISECONDS FROM {{ date }}::timestamp)
    {% else %}
        {{ exceptions.raise_compiler_error("Invalid datepart for datepart: " ~ datepart) }}
    {% endif %}
{% endmacro %} 