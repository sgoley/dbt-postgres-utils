{% macro create_extension(extension_name, schema=none, version=none, cascade=false) -%}
create extension if not exists {{ postgres_utils__quote_qualified_identifier(extension_name) }}
{% if schema or version or cascade %}with{% endif %}
{% if schema %} schema {{ postgres_utils__quote_qualified_identifier(schema) }}{% endif %}
{% if version %} version '{{ postgres_utils__escape_literal(version) }}'{% endif %}
{% if cascade %} cascade{% endif %}
{%- endmacro %}

{% macro drop_extension(extension_name, cascade=false) -%}
drop extension if exists {{ postgres_utils__quote_qualified_identifier(extension_name) }}{% if cascade %} cascade{% endif %}
{%- endmacro %}
