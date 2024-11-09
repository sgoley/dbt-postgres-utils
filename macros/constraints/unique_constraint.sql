{% macro pg_unique(model, column_names) %}
  {% if not is_incremental() and model.config.materialized == 'table' %}
    {%- if column_names is string -%}
      {% set columns = [column_names] %}
    {%- else -%}
      {% set columns = column_names %}
    {%- endif -%}
    
    {% set constraint_name = model.name + '_' + '_'.join(columns) + '_unique' %}
    
    {% call statement('add_unique_constraint', fetch_result=True, auto_begin=False) -%}
      ALTER TABLE {{ model }}
      ADD CONSTRAINT {{ constraint_name }}
      UNIQUE ({{ columns | join(', ') }});
    {%- endcall %}
    
    {{ log("Added unique constraint " ~ constraint_name ~ " to " ~ model, info=True) }}
  {% endif %}
{% endmacro %} 