{% macro postgres__create_mat_view_as(temporary, relation, sql) -%}
  {%- set unlogged = config.get('unlogged', default=false) -%}
  {%- set sql_header = config.get('sql_header', none) -%}

  {{ sql_header if sql_header is not none }}

  create {% if temporary -%}
    temporary
  {%- elif unlogged -%}
    unlogged
  {%- endif %} MATERIALIZED VIEW {{ relation }}
  as (
    {{ sql }}
  );
{%- endmacro %}