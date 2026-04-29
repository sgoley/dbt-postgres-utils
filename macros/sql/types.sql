{% macro create_enum_type(type_name, values, schema=none) -%}
{%- set qualified_type_name = schema ~ '.' ~ type_name if schema else type_name -%}
do $$
begin
    if not exists (
        select 1
        from pg_type t
        join pg_namespace n on n.oid = t.typnamespace
        where t.typname = '{{ postgres_utils__escape_literal(type_name) }}'
          and n.nspname = '{{ postgres_utils__escape_literal(schema or target.schema) }}'
    ) then
        create type {{ postgres_utils__quote_qualified_identifier(qualified_type_name) }} as enum ({{ postgres_utils__render_literal_list(values) }});
    end if;
end $$;
{%- endmacro %}

{% macro create_composite_type(type_name, attributes, schema=none) -%}
{%- set qualified_type_name = schema ~ '.' ~ type_name if schema else type_name -%}
do $$
begin
    if not exists (
        select 1
        from pg_type t
        join pg_namespace n on n.oid = t.typnamespace
        where t.typname = '{{ postgres_utils__escape_literal(type_name) }}'
          and n.nspname = '{{ postgres_utils__escape_literal(schema or target.schema) }}'
    ) then
        create type {{ postgres_utils__quote_qualified_identifier(qualified_type_name) }} as (
            {%- for attribute_name, data_type in attributes.items() -%}
                {{ postgres_utils__quote_identifier(attribute_name) }} {{ data_type }}{%- if not loop.last -%}, {% endif -%}
            {%- endfor -%}
        );
    end if;
end $$;
{%- endmacro %}

{% macro create_domain_type(type_name, base_type, schema=none, default=none, not_null=false, check=none) -%}
{%- set qualified_type_name = schema ~ '.' ~ type_name if schema else type_name -%}
do $$
begin
    if not exists (
        select 1
        from pg_type t
        join pg_namespace n on n.oid = t.typnamespace
        where t.typname = '{{ postgres_utils__escape_literal(type_name) }}'
          and n.nspname = '{{ postgres_utils__escape_literal(schema or target.schema) }}'
    ) then
        create domain {{ postgres_utils__quote_qualified_identifier(qualified_type_name) }} as {{ base_type }}
        {% if default is not none %} default {{ default }}{% endif %}
        {% if not_null %} not null{% endif %}
        {% if check %} check ({{ check }}){% endif %};
    end if;
end $$;
{%- endmacro %}

{% macro drop_type(type_name, schema=none, cascade=false) -%}
{%- set qualified_type_name = schema ~ '.' ~ type_name if schema else type_name -%}
drop type if exists {{ postgres_utils__quote_qualified_identifier(qualified_type_name) }}{% if cascade %} cascade{% endif %}
{%- endmacro %}
