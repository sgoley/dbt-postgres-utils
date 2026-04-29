{% macro add_primary_key(relation, columns, constraint_name=none) -%}
{%- set cols = postgres_utils__as_list(columns) -%}
{%- set name = constraint_name or postgres_utils__default_constraint_name(relation, 'pk', cols) -%}
do $$
begin
    if not exists (
        select 1 from pg_constraint
        where conname = '{{ postgres_utils__escape_literal(name) }}'
          and conrelid = '{{ postgres_utils__escape_literal(relation) }}'::regclass
    ) then
        alter table {{ relation }}
        add constraint {{ postgres_utils__quote_identifier(name) }}
        primary key ({{ postgres_utils__render_identifier_list(cols) }});
    end if;
end $$;
{%- endmacro %}

{% macro add_unique_key(relation, columns, constraint_name=none) -%}
{%- set cols = postgres_utils__as_list(columns) -%}
{%- set name = constraint_name or postgres_utils__default_constraint_name(relation, 'uk', cols) -%}
do $$
begin
    if not exists (
        select 1 from pg_constraint
        where conname = '{{ postgres_utils__escape_literal(name) }}'
          and conrelid = '{{ postgres_utils__escape_literal(relation) }}'::regclass
    ) then
        alter table {{ relation }}
        add constraint {{ postgres_utils__quote_identifier(name) }}
        unique ({{ postgres_utils__render_identifier_list(cols) }});
    end if;
end $$;
{%- endmacro %}

{% macro add_foreign_key(relation, columns, foreign_relation, foreign_columns, constraint_name=none, on_delete=none, on_update=none, deferrable=false, initially_deferred=false) -%}
{%- set cols = postgres_utils__as_list(columns) -%}
{%- set foreign_cols = postgres_utils__as_list(foreign_columns) -%}
{%- set name = constraint_name or postgres_utils__default_constraint_name(relation, 'fk', cols) -%}
do $$
begin
    if not exists (
        select 1 from pg_constraint
        where conname = '{{ postgres_utils__escape_literal(name) }}'
          and conrelid = '{{ postgres_utils__escape_literal(relation) }}'::regclass
    ) then
        alter table {{ relation }}
        add constraint {{ postgres_utils__quote_identifier(name) }}
        foreign key ({{ postgres_utils__render_identifier_list(cols) }})
        references {{ foreign_relation }} ({{ postgres_utils__render_identifier_list(foreign_cols) }})
        {% if on_delete %} on delete {{ on_delete }}{% endif %}
        {% if on_update %} on update {{ on_update }}{% endif %}
        {% if deferrable %} deferrable{% if initially_deferred %} initially deferred{% endif %}{% endif %};
    end if;
end $$;
{%- endmacro %}

{% macro add_column_reference(relation, column, foreign_relation, foreign_column='id', constraint_name=none, on_delete=none, on_update=none, deferrable=false, initially_deferred=false) -%}
{{ add_foreign_key(relation, column, foreign_relation, foreign_column, constraint_name, on_delete, on_update, deferrable, initially_deferred) }}
{%- endmacro %}

{% macro drop_constraint(relation, constraint_name, cascade=false) -%}
alter table {{ relation }}
drop constraint if exists {{ postgres_utils__quote_identifier(constraint_name) }}{% if cascade %} cascade{% endif %}
{%- endmacro %}
