{{
    config(
        materialized='table'
    )
}}

with fhv_rides as (
    select *
    from {{ ref('stg_fhv_rides') }}
), 
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select         
    dispatching_base_num,
    pickup_datetime,
    EXTRACT (YEAR from DATE(pickup_datetime)) as year, 
    EXTRACT (MONTH from DATE(pickup_datetime)) as month, 
    dropoff_datetime,
    pickup_locationid,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,
    sr_flag,
    affiliated_base_number
from fhv_rides
inner join dim_zones as pickup_zone
on fhv_rides.pickup_locationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on fhv_rides.dropoff_locationid = dropoff_zone.locationid