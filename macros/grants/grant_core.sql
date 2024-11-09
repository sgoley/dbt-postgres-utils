{% macro pg_grant_core(relation, privilege, role, columns=none, with_grant_option=false) %}
    {% if columns is not none and columns is string %}
        {% set columns = [columns] %}
    {% endif %}

    {% set grant_sql %}
        GRANT {{ privilege }} 
        {%- if columns is not none %}
            ({{ columns|join(', ') }})
        {%- endif %}
        ON {{ relation }}
        TO {{ role }}
        {%- if with_grant_option %}
            WITH GRANT OPTION
        {%- endif %}
    {% endset %}

    {% do run_query(grant_sql) %}
    {% do log("Granted " ~ privilege ~ " on " ~ relation ~ " to " ~ role, info=true) %}
{% endmacro %} 