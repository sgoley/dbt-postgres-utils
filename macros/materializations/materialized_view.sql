{% materialization materialized_view, adapter='postgres' %}
    {%- set target_relation = api.Relation.create(database=database, schema=schema, identifier=identifier, type='table') -%}
    {%- set existing_relation = load_relation(target_relation) -%}
    {%- set indexes = config.get('indexes', []) -%}
    {%- set refresh_concurrently = config.get('refresh_concurrently', false) -%}

    {{ run_hooks(pre_hooks) }}

    {% if existing_relation is none or flags.FULL_REFRESH %}
        {% call statement('drop_existing_materialized_view') %}
            drop materialized view if exists {{ target_relation }} cascade;
            drop view if exists {{ target_relation }} cascade;
            drop table if exists {{ target_relation }} cascade;
        {% endcall %}

        {% call statement('create_materialized_view') %}
            create materialized view {{ target_relation }} as
            {{ sql }}
        {% endcall %}

        {% for idx in indexes %}
            {% call statement('create_materialized_view_index_' ~ loop.index) %}
                {% if idx.get('unique', false) %}
                    {{ uindex(target_relation, idx.get('columns'), type=idx.get('type'), where=idx.get('where'), name=idx.get('name'), include=idx.get('include')) }}
                {% else %}
                    {{ index(target_relation, idx.get('columns'), type=idx.get('type'), where=idx.get('where'), name=idx.get('name'), include=idx.get('include')) }}
                {% endif %}
            {% endcall %}
        {% endfor %}
    {% else %}
        {% call statement('refresh_materialized_view') %}
            {{ refresh_materialized_view(target_relation, refresh_concurrently) }}
        {% endcall %}
    {% endif %}

    {{ run_hooks(post_hooks) }}

    {{ return({'relations': [target_relation]}) }}
{% endmaterialization %}
