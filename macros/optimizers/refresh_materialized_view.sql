{% macro refresh_materialized_view(relation, concurrently=false) -%}
refresh materialized view {% if concurrently %}concurrently {% endif %}{{ relation }}
{%- endmacro %}
