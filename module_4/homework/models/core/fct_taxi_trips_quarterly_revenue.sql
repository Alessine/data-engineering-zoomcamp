{{ config(materialized="table") }}

with
    trips_data as (select * from {{ ref("fact_trips") }}),
    prep as (
        select
            year_quarter,
            service_type,
            sum(total_amount) as quarterly_revenue,
            lag(sum(total_amount), 4) over (
                partition by service_type order by year_quarter
            ) as prev_year_revenue
        from trips_data
        group by service_type, year_quarter
    )
select *, (quarterly_revenue / prev_year_revenue - 1) * 100 as yoy_growth
from prep
