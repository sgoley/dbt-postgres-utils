-- original credits to https://github.com/fishtown-analytics/postgres
{% macro index(this, column) %}

create index if not exists "{{ this.name }}__index_on_{{ column }}" on {{ this }} ("{{ column }}")

{% endmacro %}