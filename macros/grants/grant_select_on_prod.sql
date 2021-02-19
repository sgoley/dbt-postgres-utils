{% macro grant_select_on_prod(schemas, user) %}
{% if 'prod' in target.name %}
  {% for schema in schemas %}
    grant usage on schema {{ schema }} to "{{ user }}";
    grant select on all tables in schema {{ schema }} to "{{ user }}";
    grant select on all views in schema {{ schema }} to "{{ user }}";
    grant select on future tables in schema {{ schema }} to "{{ user }}";
    grant select on future views in schema {{ schema }} to "{{ user }}";
  {% endfor %}
{% else %}
select 1; -- hooks will error if they don't have valid SQL in them, this handles that!
{% endif %}
{% endmacro %}