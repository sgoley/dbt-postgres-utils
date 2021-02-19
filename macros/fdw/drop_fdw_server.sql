{% macro drop_fdw_server(server_name) %}

{% if server_name %}

    {{ log("Dropping server " ~ server_name ~ "...", info=True) }}


    {% call statement('drop_fdw_server', fetch_result=True, auto_begin=False) -%}
        DROP SERVER {{ server_name }}
    {%- endcall %}

    {%- set result = load_result('drop_fdw_server') -%}
    {{ log(result['data'][0][0], info=True)}}

  {% else %}
    
    {{ exceptions.raise_compiler_error("Invalid arguments. Missing server name") }}

  {% endif %}

{% endmacro %}