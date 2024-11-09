{% macro pg_exclusion(model, elements, using='gist') %}
  {% if not is_incremental() and model.config.materialized == 'table' %}
    {% set constraint_name = model.name + '_excl' %}
    
    {% call statement('add_exclusion_constraint', fetch_result=True, auto_begin=False) -%}
      ALTER TABLE {{ model }}
      ADD CONSTRAINT {{ constraint_name }}
      EXCLUDE USING {{ using }} ({{ elements }});
    {%- endcall %}
    
    {{ log("Added exclusion constraint " ~ constraint_name ~ " to " ~ model, info=True) }}
  {% endif %}
{% endmacro %} 