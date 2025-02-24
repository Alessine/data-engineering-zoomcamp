{{ config(materialized="table") }}

with
    trips_data as (select * from {{ ref("fact_trips") }}),
    prep as (
        select
            service_type,
            year,
            month,
            percentile_cont(fare_amount, 0.97) over (
                partition by service_type, year, month
            ) as p97,
            percentile_cont(fare_amount, 0.95) over (
                partition by service_type, year, month
            ) as p95,
            percentile_cont(fare_amount, 0.90) over (
                partition by service_type, year, month
            ) as p90
        from trips_data
        where
            fare_amount > 0
            and trip_distance > 0
            and payment_type_description in ('Cash', 'Credit card')
    )
select service_type, year, month, max(p97) as p97, max(p95) as p95, max(p90) as p90,
from prep
group by service_type, year, month
