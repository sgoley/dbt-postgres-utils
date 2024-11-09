{# Shorthand for unique index #}
{% macro uindex(model, columns, method='btree', name=none, where=none, include=none) %}
    {{ return(index(model, columns, method=method, unique=true, name=name, where=where, include=include)) }}
{% endmacro %}

{# Shorthand for GiST index (good for geometric/geographic data) #}
{% macro gist_index(model, columns, name=none, where=none) %}
    {{ return(index(model, columns, method='gist', name=name, where=where)) }}
{% endmacro %}

{# Shorthand for GIN index (good for array/jsonb data) #}
{% macro gin_index(model, columns, name=none, where=none) %}
    {{ return(index(model, columns, method='gin', name=name, where=where)) }}
{% endmacro %}

{# Shorthand for BRIN index (good for large tables with natural ordering) #}
{% macro brin_index(model, columns, name=none, where=none, pages_per_range=none) %}
    {%- if pages_per_range is none -%}
        {{ return(index(model, columns, method='brin', name=name, where=where)) }}
    {%- else -%}
        {% set name = name if name is not none else model.name + '_' + '_'.join(columns) + '_brin_idx' %}
        {% call statement('create_brin_index', fetch_result=True, auto_begin=False) -%}
            DROP INDEX IF EXISTS {{ name }};
            CREATE INDEX IF NOT EXISTS {{ name }}
            ON {{ model }} USING brin (
                {%- for column in columns -%}
                    {{ column }}{% if not loop.last %}, {% endif %}
                {%- endfor -%}
            )
            WITH (pages_per_range = {{ pages_per_range }})
            {%- if where is not none %}
            WHERE {{ where }}
            {%- endif -%};
        {%- endcall %}
    {%- endif -%}
{% endmacro %}

{# Shorthand for partial index #}
{% macro partial_index(model, columns, where, method='btree', name=none) %}
    {{ return(index(model, columns, method=method, name=name, where=where)) }}
{% endmacro %} 