{% macro pg_check_constraint(model, column_name, condition) %}
  {% if not is_incremental() and model.config.materialized == 'table' %}
    {% set constraint_name = model.name + '_' + column_name + '_check' %}
    
    {% call statement('add_check_constraint', fetch_result=True, auto_begin=False) -%}
      ALTER TABLE {{ model }}
      ADD CONSTRAINT {{ constraint_name }}
      CHECK ({{ condition }});
    {%- endcall %}
    
    {{ log("Added check constraint " ~ constraint_name ~ " to " ~ model, info=True) }}
  {% endif %}
{% endmacro %} 