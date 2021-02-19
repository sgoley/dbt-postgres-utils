{% macro clean_all_schemas(dryrun=False) %}

  {% set get_schemas_query %}
      select schema_name from `{{ target.database }}.information_schema.schemata` 
      where schema_name like '{{ target.schema }}%')
      order by schema_name desc;
  {% endset %}

  {% set schemas = run_query(get_schemas_query).columns[0].values() %}

  {% for schema in schemas %}
    {% if dryrun | as_bool == False %}
      {% do log('Executing DROP commands...', True) %}
    {% else %}
      {% do log('Printing DROP commands...', True) %}
    {% endif %}
    {% do log("Cleaning up " + schema + " schema", True) %}
    {{ drop_old_relations(schema=schema,dryrun=dryrun) }}
  {% endfor %}

{% endmacro %}%}