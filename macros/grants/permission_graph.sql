{% macro pg_record_grants(target_schema='public', target_table='grants') %}
    {% set create_table_sql %}
        CREATE TABLE IF NOT EXISTS {{ target_schema }}.{{ target_table }} (
            recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            schema_name TEXT,
            relation_name TEXT,
            relation_type TEXT,
            grantee TEXT,
            privilege_type TEXT,
            is_grantable BOOLEAN,
            column_name TEXT
        );
        
        TRUNCATE {{ target_schema }}.{{ target_table }};
        
        INSERT INTO {{ target_schema }}.{{ target_table }} (
            schema_name,
            relation_name,
            relation_type,
            grantee,
            privilege_type,
            is_grantable,
            column_name
        )
        SELECT 
            table_schema,
            table_name,
            table_type,
            grantee,
            privilege_type,
            is_grantable = 'YES',
            column_name
        FROM information_schema.role_column_grants
        UNION ALL
        SELECT 
            table_schema,
            table_name,
            table_type,
            grantee,
            privilege_type,
            is_grantable = 'YES',
            NULL as column_name
        FROM information_schema.role_table_grants;
    {% endset %}
    
    {% do run_query(create_table_sql) %}
    {% do log("Recorded grants in " ~ target_schema ~ "." ~ target_table, info=true) %}
{% endmacro %} 