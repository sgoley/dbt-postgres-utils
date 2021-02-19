{% macro grant_all_on_prod(schemas, user) %}
  {% if 'prod' in target.name %}
  {% for schema in schemas %}
    grant usage on schema {{ schema }} to "{{ user }}";
    grant all on all tables in schema {{ schema }} to "{{ user }}";
    alter default privileges in schema {{ schema }}
        grant all on tables to "{{ user }}";
  {% endfor %}
  {% else %}
    select 1; -- hooks will error if they don't have valid SQL in them, this handles that!
  {% endif %}
{% endmacro %}