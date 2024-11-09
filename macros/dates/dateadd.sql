{% macro dateadd(datepart, number, date) %}
    {% if datepart|lower in ['year', 'yy', 'yyyy'] %}
        {{ date }} + interval '{{ number }} year'
    {% elif datepart|lower in ['quarter', 'qq', 'q'] %}
        {{ date }} + interval '{{ number * 3 }} month'
    {% elif datepart|lower in ['month', 'mm', 'm'] %}
        {{ date }} + interval '{{ number }} month'
    {% elif datepart|lower in ['week', 'wk', 'ww'] %}
        {{ date }} + interval '{{ number }} week'
    {% elif datepart|lower in ['day', 'dd', 'd'] %}
        {{ date }} + interval '{{ number }} day'
    {% elif datepart|lower in ['hour', 'hh'] %}
        {{ date }} + interval '{{ number }} hour'
    {% elif datepart|lower in ['minute', 'mi', 'n'] %}
        {{ date }} + interval '{{ number }} minute'
    {% elif datepart|lower in ['second', 'ss', 's'] %}
        {{ date }} + interval '{{ number }} second'
    {% elif datepart|lower in ['millisecond', 'ms'] %}
        {{ date }} + interval '{{ number }} millisecond'
    {% else %}
        {{ exceptions.raise_compiler_error("Invalid datepart for dateadd: " ~ datepart) }}
    {% endif %}
{% endmacro %} 