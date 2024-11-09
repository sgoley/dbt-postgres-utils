{% macro pg_preserve_grants(relation) %}
    {% if execute %}
        {# Get existing grants #}
        {% set get_grants_query %}
            SELECT 
                grantee,
                privilege_type,
                CASE 
                    WHEN is_grantable = 'YES' THEN true 
                    ELSE false 
                END as with_grant_option,
                column_name
            FROM information_schema.role_column_grants
            WHERE table_schema = '{{ relation.schema }}'
            AND table_name = '{{ relation.identifier }}'
            UNION ALL
            SELECT 
                grantee,
                privilege_type,
                CASE 
                    WHEN is_grantable = 'YES' THEN true 
                    ELSE false 
                END as with_grant_option,
                NULL as column_name
            FROM information_schema.role_table_grants
            WHERE table_schema = '{{ relation.schema }}'
            AND table_name = '{{ relation.identifier }}';
        {% endset %}
        
        {% set results = run_query(get_grants_query) %}
        
        {% if results %}
            {% for row in results %}
                {% do pg_grant_core(
                    relation,
                    row['privilege_type'],
                    row['grantee'],
                    columns=row['column_name'],
                    with_grant_option=row['with_grant_option']
                ) %}
            {% endfor %}
        {% endif %}
    {% endif %}
{% endmacro %} 