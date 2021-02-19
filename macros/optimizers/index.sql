-- original credits to https://github.com/fishtown-analytics/postgres
{% macro index(this, column, indextype=btree) %}

    create or replace index if not exists "{{ this.name }}__index_on_{{ column }}" on {{ this }} 
    {%- if indextype != 'btree' -%}
    using {{ indextype }}
    {%- else -%}
    using 'btree'
    {%- endif -%}
      ("{{ column }}")

{% endmacro %}