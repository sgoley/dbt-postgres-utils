{% macro pg_grant_schema(schema_name, privilege, role) %}
    {% set grant_sql %}
        GRANT {{ privilege }} ON SCHEMA {{ schema_name }} TO {{ role }};
        
        -- For future objects
        ALTER DEFAULT PRIVILEGES IN SCHEMA {{ schema_name }}
        GRANT {{ privilege }} ON TABLES TO {{ role }};
        
        ALTER DEFAULT PRIVILEGES IN SCHEMA {{ schema_name }}
        GRANT {{ privilege }} ON SEQUENCES TO {{ role }};
        
        ALTER DEFAULT PRIVILEGES IN SCHEMA {{ schema_name }}
        GRANT {{ privilege }} ON FUNCTIONS TO {{ role }};
    {% endset %}
    
    {% do run_query(grant_sql) %}
    {% do log("Granted schema privileges on " ~ schema_name ~ " to " ~ role, info=true) %}
{% endmacro %} 