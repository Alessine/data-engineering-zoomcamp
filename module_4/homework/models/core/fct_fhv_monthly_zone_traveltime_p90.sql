{{ config(materialized="table") }}

with
    trips_data as (select * from {{ ref("dim_fhv_trips") }}),
    prep as (
        select
            year,
            month,
            pickup_locationid,
            pickup_zone,
            dropoff_locationid,
            dropoff_zone,
            timestamp_diff(dropoff_datetime, pickup_datetime, second) as trip_duration,
        from trips_data
    ),
    p90_trips as (
        select
            *,
            percentile_cont(trip_duration, 0.90) over (
                partition by year, month, pickup_locationid, dropoff_locationid
            ) as p90
        from prep
    )

select year, month, pickup_zone, dropoff_zone, max(p90) as p90
from p90_trips
group by year, month, pickup_zone, dropoff_zone
