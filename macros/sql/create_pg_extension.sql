{% macro create_pg_extension(extension_name) %}

{% if extension_name %}

    {{ log("Creating extension " ~ extension_name ~ "...", info=True) }}


    {% call statement('create_pg_extension', fetch_result=True, auto_begin=False) -%}
        CREATE EXTENSION IF NOT EXISTS {{ extension_name }}
    {%- endcall %}

    {%- set result = load_result('create_pg_extension') -%}
    {{ log(result['data'][0][0], info=True)}}

  {% else %}
    
    {{ exceptions.raise_compiler_error("Invalid arguments. Missing extension name") }}

  {% endif %}

{% endmacro %}