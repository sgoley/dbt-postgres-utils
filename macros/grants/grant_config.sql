{% macro pg_configure_access_roles() %}
    {# Create basic roles #}
    {% do pg_create_role('analyst_role', login=true) %}
    {% do pg_create_role('reader_role', login=true) %}
    {% do pg_create_role('reporter_role', login=true) %}
    
    {# Grant schema access #}
    {% do pg_grant_schema(target.schema, 'USAGE', 'reader_role') %}
    {% do pg_grant_schema(target.schema, 'USAGE,CREATE', 'analyst_role') %}
    
    {# Grant access based on tags #}
    {% do pg_grant_by_tags(
        'reader_role', 
        'SELECT', 
        exclude_tags=['sensitive', 'pii', 'financial']
    ) %}
    
    {% do pg_grant_by_tags(
        'analyst_role',
        'SELECT,INSERT,UPDATE,DELETE',
        exclude_tags=['sensitive']
    ) %}
    
    {# Record the permission graph #}
    {% do pg_record_grants() %}
{% endmacro %} 