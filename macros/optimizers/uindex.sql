{% macro uindex(this, column) %}

create unique index if not exists "{{ this.name }}__uindex_on_{{ column }}" on {{ this }} ("{{ column }}")

{% endmacro %}