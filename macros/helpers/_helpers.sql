{% macro postgres_utils__as_list(value) -%}
    {%- if value is string -%}
        {{ return([value]) }}
    {%- else -%}
        {{ return(value) }}
    {%- endif -%}
{%- endmacro %}

{% macro postgres_utils__quote_identifier(identifier) -%}
    "{{ identifier | string | replace('"', '""') }}"
{%- endmacro %}

{% macro postgres_utils__quote_qualified_identifier(identifier) -%}
    {%- set parts = (identifier | string).split('.') -%}
    {%- for part in parts -%}
        {{ postgres_utils__quote_identifier(part) }}{%- if not loop.last -%}.{%- endif -%}
    {%- endfor -%}
{%- endmacro %}

{% macro postgres_utils__escape_literal(value) -%}
    {{ value | string | replace("'", "''") }}
{%- endmacro %}

{% macro postgres_utils__render_identifier_list(identifiers) -%}
    {%- set identifier_list = postgres_utils__as_list(identifiers) -%}
    {%- for identifier in identifier_list -%}
        {{ postgres_utils__quote_identifier(identifier) }}{%- if not loop.last -%}, {% endif -%}
    {%- endfor -%}
{%- endmacro %}

{% macro postgres_utils__render_csv(values) -%}
    {%- set value_list = postgres_utils__as_list(values) -%}
    {%- for value in value_list -%}
        {{ value }}{%- if not loop.last -%}, {% endif -%}
    {%- endfor -%}
{%- endmacro %}

{% macro postgres_utils__render_literal_list(values) -%}
    {%- set value_list = postgres_utils__as_list(values) -%}
    {%- for value in value_list -%}
        '{{ postgres_utils__escape_literal(value) }}'{%- if not loop.last -%}, {% endif -%}
    {%- endfor -%}
{%- endmacro %}

{% macro postgres_utils__render_options(options) -%}
    {%- if options -%}
        options (
        {%- for key, value in options.items() -%}
            {{ key }} '{{ postgres_utils__escape_literal(value) }}'{%- if not loop.last -%}, {% endif -%}
        {%- endfor -%}
        )
    {%- endif -%}
{%- endmacro %}

{% macro postgres_utils__default_constraint_name(relation, prefix, columns) -%}
    {%- set column_list = postgres_utils__as_list(columns) -%}
    {%- if relation.identifier is defined and relation.identifier -%}
        {%- set relation_name = relation.identifier -%}
    {%- elif relation.name is defined and relation.name -%}
        {%- set relation_name = relation.name -%}
    {%- else -%}
        {%- set relation_name = 'relation' -%}
    {%- endif -%}
    {{ relation_name }}__{{ prefix }}__{{ column_list | join('__') }}
{%- endmacro %}
