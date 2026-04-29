{% macro uindex(this, column, type=none, where=none, name=none, concurrently=false, include=none) %}

{%- set columns = postgres_utils__as_list(column) -%}
{%- set index_name = name or postgres_utils__default_constraint_name(this, 'uindex_on', columns) -%}

create unique index {% if concurrently %}concurrently {% endif %}if not exists {{ postgres_utils__quote_identifier(index_name) }}
on {{ this }}
{% if type %}using {{ type }} {% endif %}
({{ postgres_utils__render_identifier_list(columns) }})
{% if include %}include ({{ postgres_utils__render_identifier_list(include) }}){% endif %}
{% if where %}where {{ where }}{% endif %}

{% endmacro %}
