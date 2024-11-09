{% macro pg_create_role(role_name, login=false, superuser=false, inherit=true, connection_limit=-1) %}
    {% set role_sql %}
        DO $$ 
        BEGIN
            IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '{{ role_name }}') THEN
                CREATE ROLE {{ role_name }}
                {%- if login %} LOGIN{% endif %}
                {%- if superuser %} SUPERUSER{% endif %}
                {%- if inherit %} INHERIT{% endif %}
                CONNECTION LIMIT {{ connection_limit }};
            END IF;
        END
        $$;
    {% endset %}
    
    {% do run_query(role_sql) %}
    {% do log("Created role " ~ role_name, info=true) %}
{% endmacro %}

{% macro pg_grant_role(role_name, granted_role) %}
    {% set grant_sql %}
        GRANT {{ granted_role }} TO {{ role_name }};
    {% endset %}
    
    {% do run_query(grant_sql) %}
    {% do log("Granted role " ~ granted_role ~ " to " ~ role_name, info=true) %}
{% endmacro %} 