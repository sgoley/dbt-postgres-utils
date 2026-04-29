{% macro create_role(role_name, login=false, password=none, superuser=false, createdb=false, createrole=false, inherit=true) -%}
do $$
begin
    if not exists (select 1 from pg_roles where rolname = '{{ postgres_utils__escape_literal(role_name) }}') then
        create role {{ postgres_utils__quote_identifier(role_name) }}
        {% if login %} login{% else %} nologin{% endif %}
        {% if password %} password '{{ postgres_utils__escape_literal(password) }}'{% endif %}
        {% if superuser %} superuser{% else %} nosuperuser{% endif %}
        {% if createdb %} createdb{% else %} nocreatedb{% endif %}
        {% if createrole %} createrole{% else %} nocreaterole{% endif %}
        {% if inherit %} inherit{% else %} noinherit{% endif %};
    end if;
end $$;
{%- endmacro %}

{% macro create_user(user_name, password=none, superuser=false, createdb=false, createrole=false, inherit=true) -%}
{{ create_role(user_name, login=true, password=password, superuser=superuser, createdb=createdb, createrole=createrole, inherit=inherit) }}
{%- endmacro %}

{% macro drop_role(role_name) -%}
drop role if exists {{ postgres_utils__quote_identifier(role_name) }}
{%- endmacro %}

{% macro drop_user(user_name) -%}
{{ drop_role(user_name) }}
{%- endmacro %}

{% macro grant_role(role_name, grantee) -%}
grant {{ postgres_utils__quote_identifier(role_name) }} to {{ postgres_utils__quote_identifier(grantee) }}
{%- endmacro %}

{% macro revoke_role(role_name, grantee) -%}
revoke {{ postgres_utils__quote_identifier(role_name) }} from {{ postgres_utils__quote_identifier(grantee) }}
{%- endmacro %}

{% macro grant_schema_privileges(schema, grantee, privileges='usage') -%}
grant {{ postgres_utils__render_csv(privileges) }} on schema {{ postgres_utils__quote_qualified_identifier(schema) }} to {{ postgres_utils__quote_identifier(grantee) }}
{%- endmacro %}

{% macro revoke_schema_privileges(schema, grantee, privileges='usage') -%}
revoke {{ postgres_utils__render_csv(privileges) }} on schema {{ postgres_utils__quote_qualified_identifier(schema) }} from {{ postgres_utils__quote_identifier(grantee) }}
{%- endmacro %}

{% macro grant_relation_privileges(relation, grantee, privileges='select') -%}
grant {{ postgres_utils__render_csv(privileges) }} on {{ relation }} to {{ postgres_utils__quote_identifier(grantee) }}
{%- endmacro %}

{% macro revoke_relation_privileges(relation, grantee, privileges='select') -%}
revoke {{ postgres_utils__render_csv(privileges) }} on {{ relation }} from {{ postgres_utils__quote_identifier(grantee) }}
{%- endmacro %}

{% macro grant_all_tables_in_schema(schema, grantee, privileges='select') -%}
grant {{ postgres_utils__render_csv(privileges) }} on all tables in schema {{ postgres_utils__quote_qualified_identifier(schema) }} to {{ postgres_utils__quote_identifier(grantee) }}
{%- endmacro %}

{% macro grant_all_sequences_in_schema(schema, grantee, privileges='usage') -%}
grant {{ postgres_utils__render_csv(privileges) }} on all sequences in schema {{ postgres_utils__quote_qualified_identifier(schema) }} to {{ postgres_utils__quote_identifier(grantee) }}
{%- endmacro %}

{% macro alter_default_table_privileges(schema, grantee, privileges='select', owner=none) -%}
alter default privileges {% if owner %}for role {{ postgres_utils__quote_identifier(owner) }} {% endif %}in schema {{ postgres_utils__quote_qualified_identifier(schema) }}
grant {{ postgres_utils__render_csv(privileges) }} on tables to {{ postgres_utils__quote_identifier(grantee) }}
{%- endmacro %}

{% macro grant_permissions_on_target_to_role(role_name, privileges='select', schema=target.schema, include_schema_usage=true, include_future_tables=true) -%}
{% if include_schema_usage %}{{ grant_schema_privileges(schema, role_name, 'usage') }};{% endif %}
{{ grant_all_tables_in_schema(schema, role_name, privileges) }};
{% if include_future_tables %}{{ alter_default_table_privileges(schema, role_name, privileges) }};{% endif %}
{%- endmacro %}

{% macro grant_permissions_on_target_to_user(user_name, privileges='select', schema=target.schema, include_schema_usage=true, include_future_tables=true) -%}
{{ grant_permissions_on_target_to_role(user_name, privileges, schema, include_schema_usage, include_future_tables) }}
{%- endmacro %}
