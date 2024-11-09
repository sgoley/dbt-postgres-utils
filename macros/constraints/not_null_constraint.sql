{% macro pg_not_null(model, column_name) %}
  {% if not is_incremental() and model.config.materialized == 'table' %}
    {% set constraint_name = model.name + '_' + column_name + '_not_null' %}
    
    {% call statement('add_not_null_constraint', fetch_result=True, auto_begin=False) -%}
      ALTER TABLE {{ model }}
      ALTER COLUMN {{ column_name }} SET NOT NULL;
    {%- endcall %}
    
    {{ log("Added NOT NULL constraint on " ~ column_name ~ " to " ~ model, info=True) }}
  {% endif %}
{% endmacro %} 