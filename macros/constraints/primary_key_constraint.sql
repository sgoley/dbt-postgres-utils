{% macro pg_primary_key(model, column_names) %}
  {% if not is_incremental() and model.config.materialized == 'table' %}
    {%- if column_names is string -%}
      {% set columns = [column_names] %}
    {%- else -%}
      {% set columns = column_names %}
    {%- endif -%}
    
    {% set constraint_name = model.name + '_pkey' %}
    
    {% call statement('add_primary_key_constraint', fetch_result=True, auto_begin=False) -%}
      ALTER TABLE {{ model }}
      ADD CONSTRAINT {{ constraint_name }}
      PRIMARY KEY ({{ columns | join(', ') }});
    {%- endcall %}
    
    {{ log("Added primary key constraint " ~ constraint_name ~ " to " ~ model, info=True) }}
  {% endif %}
{% endmacro %} 