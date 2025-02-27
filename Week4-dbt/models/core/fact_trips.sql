{{
    config(
        materialized='table'
    )
}}

with green_tripdata as (
    select *,
        "Green" as service_type
        from {{ ref('stg_green_tripdata') }}
),
yellow_tripdata as (
    select *,
        "Yellow" as service_type
        from {{ ref('stg_yellow_tripdata') }}
),
trips_unioned as (
    select * from green_tripdata
    union all
    select * from yellow_tripdata
),
dim_zones as (
    select * from {{ ref("dim_zones") }}
    where borough != "Unknown"
)
select trips_unioned.trip_id, 
    trips_unioned.vendorid, 
    trips_unioned.service_type,
    trips_unioned.ratecodeid, 
    trips_unioned.pickup_locationid, 
    pu_zone.borough as pickup_borough, 
    pu_zone.zone as pickup_zone, 
    trips_unioned.dropoff_locationid,
    do_zone.borough as dropoff_borough, 
    do_zone.zone as dropoff_zone,  
    trips_unioned.pickup_datetime, 
    trips_unioned.dropoff_datetime, 
    trips_unioned.store_and_fwd_flag, 
    trips_unioned.passenger_count, 
    trips_unioned.trip_distance, 
    trips_unioned.trip_type, 
    trips_unioned.fare_amount, 
    trips_unioned.extra, 
    trips_unioned.mta_tax, 
    trips_unioned.tip_amount, 
    trips_unioned.tolls_amount, 
    trips_unioned.improvement_surcharge, 
    trips_unioned.total_amount, 
    trips_unioned.payment_type, 
    trips_unioned.payment_type_description
    from trips_unioned
    join dim_zones as pu_zone
        on trips_unioned.pickup_locationid = pu_zone.locationid
    join dim_zones as do_zone
        on trips_unioned.dropoff_locationid = do_zone.locationid
