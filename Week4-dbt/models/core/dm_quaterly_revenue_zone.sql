{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
),
revenue_data as(

    select 
    -- Revenue grouping 
    service_type, 
    EXTRACT (YEAR from DATE(pickup_datetime)) as year, 
    EXTRACT (QUARTER from DATE(pickup_datetime)) as quarter, 
    MIN(EXTRACT (MONTH from DATE(pickup_datetime))) as month, 


    -- Revenue calculation 
    sum(total_amount) as revenue_quarterly_total_amount,

    -- Additional calculations
    count(trip_id) as total_quarterly_trips,


    from trips_data
    group by 1,2,3
    having total_quarterly_trips > 1000
),
current_vs_previous AS (
    SELECT 
        s1.service_type as taxi_color,
        s1.year AS current_year,
        s2.year AS previous_year,
        s1.quarter AS quarter,
        s1.revenue_quarterly_total_amount AS current_revenue,
        s2.revenue_quarterly_total_amount AS previous_revenue,
        ROUND(
            (s1.revenue_quarterly_total_amount - s2.revenue_quarterly_total_amount) / NULLIF(s2.revenue_quarterly_total_amount, 0) * 100, 2
        ) AS yoy_growth_percentage
    FROM revenue_data s1
    LEFT JOIN revenue_data s2 
        ON s1.year = s2.year + 1
        AND s1.quarter = s2.quarter
        AND s1.service_type = s2.service_type
)
SELECT * FROM current_vs_previous
ORDER BY taxi_color, current_year, quarter
