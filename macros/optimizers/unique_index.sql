{% macro unique_index(this, column) %}

create unique_index if not exists "{{ this.name }}__uindex_on_{{ column }}" on {{ this }} ("{{ column }}")

{% endmacro %}