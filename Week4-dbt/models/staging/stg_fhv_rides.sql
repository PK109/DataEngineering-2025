with 

source as (

    select * from {{ source('homework_staging', 'fhv_rides') }}

),

renamed as (

    select
        dispatching_base_num,
        pickup_datetime,
        drop_off_datetime as dropoff_datetime,
        p_ulocation_id as pickup_locationid,
        d_olocation_id as dropoff_locationid,
        sr_flag,
        affiliated_base_number

    from source
    Where dispatching_base_num is not null

)

select * from renamed
