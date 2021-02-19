{% macro grant_all_on_schemas(schemas, user) %}
  {% for schema in schemas %}
    grant usage on schema {{ schema }} to "{{ user }}";
    grant all on all tables in schema {{ schema }} to "{{ user }}";
    alter default privileges in schema {{ schema }}
        grant all on tables to "{{ user }}";
  {% endfor %}
{% endmacro %}