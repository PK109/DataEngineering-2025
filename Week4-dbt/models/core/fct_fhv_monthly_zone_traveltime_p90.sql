{{ config(materialized="table") }}

with
    fhv_data as (select * from {{ ref("dim_fhv_trips") }}),
    fhv_data_enhanced as (
        select
            *,
            timestamp_diff(dropoff_datetime, pickup_datetime, second) as trip_duration
        from fhv_data
    ),
    percentile_data as (
        select
            year,
            month,
            pickup_zone,
            dropoff_zone,
            approx_quantiles(trip_duration, 100)[offset(90)] as p90

        from fhv_data_enhanced
        group by year, month, pickup_zone, dropoff_zone
    )
select *
from percentile_data
where
    year = 2019
    and month = 11
    and pickup_zone in ('Newark Airport', 'SoHo', 'Yorkville East')
order by pickup_zone, p90 desc
