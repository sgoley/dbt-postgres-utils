{% macro pg_foreign_key(model, column_names, reference_table, reference_columns) %}
  {% if not is_incremental() and model.config.materialized == 'table' %}
    {%- if column_names is string -%}
      {% set columns = [column_names] %}
    {%- else -%}
      {% set columns = column_names %}
    {%- endif -%}
    
    {%- if reference_columns is string -%}
      {% set ref_columns = [reference_columns] %}
    {%- else -%}
      {% set ref_columns = reference_columns %}
    {%- endif -%}
    
    {% set constraint_name = model.name + '_' + '_'.join(columns) + '_fkey' %}
    
    {% call statement('add_foreign_key_constraint', fetch_result=True, auto_begin=False) -%}
      ALTER TABLE {{ model }}
      ADD CONSTRAINT {{ constraint_name }}
      FOREIGN KEY ({{ columns | join(', ') }})
      REFERENCES {{ reference_table }} ({{ ref_columns | join(', ') }});
    {%- endcall %}
    
    {{ log("Added foreign key constraint " ~ constraint_name ~ " to " ~ model, info=True) }}
  {% endif %}
{% endmacro %} 