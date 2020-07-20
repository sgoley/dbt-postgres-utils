{% macro drop_custom_type( type_name, schema_name = target.schema) %}

{% if type_name %}

    {{ log("Dropping type " ~ type_name ~ " on schema " ~ schema_name ~ "...", info=True) }}


    {% call statement('drop_custom_type', fetch_result=True, auto_begin=False) -%}
        DROP TYPE {{schema_name}}.{{type_name}}
    {%- endcall %}

    {%- set result = load_result('drop_custom_type') -%}
    {{ log(result['data'][0][0], info=True)}}

  {% else %}
    
    {{ exceptions.raise_compiler_error("Invalid arguments. Missing type name") }}

  {% endif %}

{% endmacro %}