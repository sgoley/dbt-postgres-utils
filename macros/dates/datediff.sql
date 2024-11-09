{% macro datediff(datepart, startdate, enddate) %}
    {% if datepart|lower in ['year', 'yy', 'yyyy'] %}
        DATE_PART('year', {{ enddate }}::timestamp) - DATE_PART('year', {{ startdate }}::timestamp)
    {% elif datepart|lower in ['quarter', 'qq', 'q'] %}
        (DATE_PART('year', {{ enddate }}::timestamp) - DATE_PART('year', {{ startdate }}::timestamp)) * 4 +
        (DATE_PART('quarter', {{ enddate }}::timestamp) - DATE_PART('quarter', {{ startdate }}::timestamp))
    {% elif datepart|lower in ['month', 'mm', 'm'] %}
        (DATE_PART('year', {{ enddate }}::timestamp) - DATE_PART('year', {{ startdate }}::timestamp)) * 12 +
        (DATE_PART('month', {{ enddate }}::timestamp) - DATE_PART('month', {{ startdate }}::timestamp))
    {% elif datepart|lower in ['week', 'wk', 'ww'] %}
        FLOOR(DATE_PART('day', {{ enddate }}::timestamp - {{ startdate }}::timestamp) / 7)
    {% elif datepart|lower in ['day', 'dd', 'd'] %}
        DATE_PART('day', {{ enddate }}::timestamp - {{ startdate }}::timestamp)
    {% elif datepart|lower in ['hour', 'hh'] %}
        DATE_PART('hour', {{ enddate }}::timestamp - {{ startdate }}::timestamp)
    {% elif datepart|lower in ['minute', 'mi', 'n'] %}
        DATE_PART('minute', {{ enddate }}::timestamp - {{ startdate }}::timestamp)
    {% elif datepart|lower in ['second', 'ss', 's'] %}
        DATE_PART('second', {{ enddate }}::timestamp - {{ startdate }}::timestamp)
    {% elif datepart|lower in ['millisecond', 'ms'] %}
        (DATE_PART('second', {{ enddate }}::timestamp - {{ startdate }}::timestamp) * 1000)::int
    {% else %}
        {{ exceptions.raise_compiler_error("Invalid datepart for datediff: " ~ datepart) }}
    {% endif %}
{% endmacro %} 