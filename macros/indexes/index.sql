-- original credits to https://github.com/fishtown-analytics/postgres
{%- macro index(model, columns, method='btree', unique=false, name=none, where=none, include=none, fillfactor=none, concurrent=false) -%}
    {# Convert single column to list #}
    {%- if columns is string -%}
        {% set columns = [columns] %}
    {%- endif -%}

    {# Generate index name if not provided #}
    {%- if name is none -%}
        {% set name = model.name + '_' + '_'.join(columns) + '_idx' %}
    {%- endif -%}

    {# Drop existing index if replacing #}
    {% call statement('drop_existing_index', fetch_result=True, auto_begin=False) -%}
        DROP INDEX IF EXISTS {{ name }};
    {%- endcall %}

    {# Build the CREATE INDEX statement #}
    {% set create_index_sql %}
        CREATE {% if unique %}UNIQUE {% endif %}
        {% if concurrent %}CONCURRENTLY {% endif %}
        INDEX {% if not concurrent %}IF NOT EXISTS {% endif %}{{ name }}
        ON {{ model }}
        USING {{ method }} (
            {%- for column in columns -%}
                {{ column }}{% if not loop.last %}, {% endif %}
            {%- endfor -%}
        )
        {%- if include is not none %}
        INCLUDE ({{ include }})
        {%- endif %}
        {%- if where is not none %}
        WHERE {{ where }}
        {%- endif %}
        {%- if fillfactor is not none %}
        WITH (fillfactor = {{ fillfactor }})
        {%- endif -%}
    {% endset %}

    {% call statement('create_index', fetch_result=True, auto_begin=False) -%}
        {{ create_index_sql }};
    {%- endcall %}

    {{ log("Created index " ~ name ~ " on " ~ model ~ " (" ~ columns|join(', ') ~ ")", info=True) }}
{%- endmacro -%}