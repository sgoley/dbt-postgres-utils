{% macro datefromparts(year, month, day) %}
    make_date({{ year }}::int, {{ month }}::int, {{ day }}::int)
{% endmacro %} 