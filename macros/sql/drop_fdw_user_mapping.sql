{% macro drop_fdw_user_mapping( mapped_user, server_name) %}

{% if mapped_user %}

    {{ log("Dropping user mapping " ~ extension_name ~ "on foreign server " ~ server_name ~ "...", info=True) }}


    {% call statement('drop_fdw_user_mapping', fetch_result=True, auto_begin=False) -%}
        DROP USER MAPPING FOR {{ mapped_user }} server {{ server_name }}
    {%- endcall %}

    {%- set result = load_result('drop_fdw_user_mapping') -%}
    {{ log(result['data'][0][0], info=True)}}

  {% else %}
    
    {{ exceptions.raise_compiler_error("Invalid arguments. Missing mapped user or server name") }}

  {% endif %}

{% endmacro %}