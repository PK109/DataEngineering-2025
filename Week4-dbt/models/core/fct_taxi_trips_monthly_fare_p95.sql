{{ config(materialized='table') }}

with trips_data as (
    select * 
    from {{ ref('fact_trips') }}
    where
        fare_amount > 0 AND
        trip_distance > 0 AND
        payment_type_description in ("Cash", "Credit Card")
),
percentile_data as(

    select 
    service_type, 
    EXTRACT (YEAR from DATE(pickup_datetime)) as year, 
    EXTRACT (MONTH from DATE(pickup_datetime)) as month, 
    fare_amount

    from trips_data
    where 
        DATE(date_trunc(pickup_datetime, MONTH)) = DATE ("2020-04-01")
        AND service_type = "Green"

)
SELECT 
    service_type, 
    year, 
    month,
    APPROX_QUANTILES(fare_amount, 100)[OFFSET(97)] AS p97,
    APPROX_QUANTILES(fare_amount, 100)[OFFSET(95)] AS p95,
    APPROX_QUANTILES(fare_amount, 100)[OFFSET(90)] AS p90
FROM percentile_data
WHere percentile_data.YEAR = 2020 AND month= 4
GROUP BY service_type, year, month

