{% macro uindex(this, column, indextype='btree') %}

    create or replace unique index if not exists "{{ this.name }}__uindex_on_{{ column }}" on {{ this }} 
    {%- if indextype != 'btree' -%}
    using {{ indextype }}
    {%- else -%}
    using 'btree'
    {%- endif -%}
      ("{{ column }}")

{% endmacro %}