{% macro create_foreign_data_wrapper(wrapper_name, handler=none, validator=none) -%}
create foreign data wrapper {{ postgres_utils__quote_identifier(wrapper_name) }}
{% if handler %} handler {{ handler }}{% endif %}
{% if validator %} validator {{ validator }}{% endif %}
{%- endmacro %}

{% macro drop_foreign_data_wrapper(wrapper_name, cascade=false) -%}
drop foreign data wrapper if exists {{ postgres_utils__quote_identifier(wrapper_name) }}{% if cascade %} cascade{% endif %}
{%- endmacro %}

{% macro create_foreign_server(server_name, foreign_data_wrapper, options=none, type=none, version=none) -%}
create server if not exists {{ postgres_utils__quote_identifier(server_name) }}
{% if type %} type '{{ postgres_utils__escape_literal(type) }}'{% endif %}
{% if version %} version '{{ postgres_utils__escape_literal(version) }}'{% endif %}
foreign data wrapper {{ postgres_utils__quote_identifier(foreign_data_wrapper) }}
{{ postgres_utils__render_options(options) }}
{%- endmacro %}

{% macro drop_foreign_server(server_name, cascade=false) -%}
drop server if exists {{ postgres_utils__quote_identifier(server_name) }}{% if cascade %} cascade{% endif %}
{%- endmacro %}

{% macro create_user_mapping(server_name, user_name='current_user', options=none) -%}
create user mapping if not exists for {% if user_name | lower in ['current_user', 'public'] %}{{ user_name }}{% else %}{{ postgres_utils__quote_identifier(user_name) }}{% endif %}
server {{ postgres_utils__quote_identifier(server_name) }}
{{ postgres_utils__render_options(options) }}
{%- endmacro %}

{% macro drop_user_mapping(server_name, user_name='current_user') -%}
drop user mapping if exists for {% if user_name | lower in ['current_user', 'public'] %}{{ user_name }}{% else %}{{ postgres_utils__quote_identifier(user_name) }}{% endif %}
server {{ postgres_utils__quote_identifier(server_name) }}
{%- endmacro %}

{% macro import_foreign_schema(remote_schema, server_name, local_schema=target.schema, limit_to=none, except_tables=none, options=none) -%}
import foreign schema {{ postgres_utils__quote_qualified_identifier(remote_schema) }}
{% if limit_to %} limit to ({{ postgres_utils__render_identifier_list(limit_to) }}){% endif %}
{% if except_tables %} except ({{ postgres_utils__render_identifier_list(except_tables) }}){% endif %}
from server {{ postgres_utils__quote_identifier(server_name) }}
into {{ postgres_utils__quote_qualified_identifier(local_schema) }}
{{ postgres_utils__render_options(options) }}
{%- endmacro %}
