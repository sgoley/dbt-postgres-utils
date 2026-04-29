{% macro dateadd(datepart, interval, from_date_or_timestamp) -%}
{%- set part = datepart | lower -%}
{%- if part in ['quarter', 'quarters'] -%}
({{ from_date_or_timestamp }} + ({{ interval }} * interval '3 month'))
{%- elif part in ['week', 'weeks'] -%}
({{ from_date_or_timestamp }} + ({{ interval }} * interval '1 week'))
{%- elif part in ['millisecond', 'milliseconds'] -%}
({{ from_date_or_timestamp }} + ({{ interval }} * interval '1 millisecond'))
{%- elif part in ['microsecond', 'microseconds'] -%}
({{ from_date_or_timestamp }} + ({{ interval }} * interval '1 microsecond'))
{%- elif part in ['second', 'seconds'] -%}
({{ from_date_or_timestamp }} + ({{ interval }} * interval '1 second'))
{%- else -%}
({{ from_date_or_timestamp }} + ({{ interval }} * interval '1 {{ part.rstrip("s") }}'))
{%- endif -%}
{%- endmacro %}

{% macro datediff(datepart, start_date_or_timestamp, end_date_or_timestamp) -%}
{%- set part = datepart | lower -%}
{%- if part in ['year', 'years'] -%}
floor(extract(year from age({{ end_date_or_timestamp }}, {{ start_date_or_timestamp }})))::integer
{%- elif part in ['quarter', 'quarters'] -%}
floor((((extract(year from age({{ end_date_or_timestamp }}, {{ start_date_or_timestamp }})) * 12) + extract(month from age({{ end_date_or_timestamp }}, {{ start_date_or_timestamp }}))) / 3))::integer
{%- elif part in ['month', 'months'] -%}
floor((extract(year from age({{ end_date_or_timestamp }}, {{ start_date_or_timestamp }})) * 12) + extract(month from age({{ end_date_or_timestamp }}, {{ start_date_or_timestamp }})))::integer
{%- elif part in ['week', 'weeks'] -%}
floor(extract(epoch from ({{ end_date_or_timestamp }} - {{ start_date_or_timestamp }})) / 604800)::integer
{%- elif part in ['day', 'days'] -%}
floor(extract(epoch from ({{ end_date_or_timestamp }} - {{ start_date_or_timestamp }})) / 86400)::integer
{%- elif part in ['hour', 'hours'] -%}
floor(extract(epoch from ({{ end_date_or_timestamp }} - {{ start_date_or_timestamp }})) / 3600)::integer
{%- elif part in ['minute', 'minutes'] -%}
floor(extract(epoch from ({{ end_date_or_timestamp }} - {{ start_date_or_timestamp }})) / 60)::integer
{%- elif part in ['second', 'seconds'] -%}
floor(extract(epoch from ({{ end_date_or_timestamp }} - {{ start_date_or_timestamp }})))::bigint
{%- elif part in ['millisecond', 'milliseconds'] -%}
floor(extract(epoch from ({{ end_date_or_timestamp }} - {{ start_date_or_timestamp }})) * 1000)::bigint
{%- elif part in ['microsecond', 'microseconds'] -%}
floor(extract(epoch from ({{ end_date_or_timestamp }} - {{ start_date_or_timestamp }})) * 1000000)::bigint
{%- else -%}
floor(extract(epoch from ({{ end_date_or_timestamp }} - {{ start_date_or_timestamp }})))::bigint
{%- endif -%}
{%- endmacro %}

{% macro date_spine(datepart, start_date, end_date, date_column='date_value') -%}
select generated_date::date as {{ postgres_utils__quote_identifier(date_column) }}
from generate_series(
    {{ start_date }}::timestamp,
    {{ end_date }}::timestamp,
    interval '1 {{ datepart | lower }}'
) as generated_date
{%- endmacro %}

{% macro date_dim(start_date, end_date, date_column='date_day') -%}
with dates as (
    {{ date_spine('day', start_date, end_date, date_column) }}
)
select
    {{ postgres_utils__quote_identifier(date_column) }},
    extract(year from {{ postgres_utils__quote_identifier(date_column) }})::integer as year_number,
    extract(quarter from {{ postgres_utils__quote_identifier(date_column) }})::integer as quarter_number,
    extract(month from {{ postgres_utils__quote_identifier(date_column) }})::integer as month_number,
    extract(day from {{ postgres_utils__quote_identifier(date_column) }})::integer as day_of_month,
    extract(doy from {{ postgres_utils__quote_identifier(date_column) }})::integer as day_of_year,
    extract(isodow from {{ postgres_utils__quote_identifier(date_column) }})::integer as iso_day_of_week,
    extract(week from {{ postgres_utils__quote_identifier(date_column) }})::integer as iso_week_number,
    date_trunc('week', {{ postgres_utils__quote_identifier(date_column) }})::date as week_start_date,
    date_trunc('month', {{ postgres_utils__quote_identifier(date_column) }})::date as month_start_date,
    (date_trunc('month', {{ postgres_utils__quote_identifier(date_column) }}) + interval '1 month - 1 day')::date as month_end_date,
    date_trunc('quarter', {{ postgres_utils__quote_identifier(date_column) }})::date as quarter_start_date,
    (date_trunc('quarter', {{ postgres_utils__quote_identifier(date_column) }}) + interval '3 month - 1 day')::date as quarter_end_date,
    date_trunc('year', {{ postgres_utils__quote_identifier(date_column) }})::date as year_start_date,
    (date_trunc('year', {{ postgres_utils__quote_identifier(date_column) }}) + interval '1 year - 1 day')::date as year_end_date
from dates
{%- endmacro %}
