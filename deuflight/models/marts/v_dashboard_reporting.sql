{{ config(materialized='view') }}

SELECT 
    flight_id,
    actual_departure,
    CASE 
        WHEN current_origin = 'EDDF' THEN 'Frankfurt (FRA)'
        WHEN current_origin = 'EDDM' THEN 'Munich (MUC)'
        WHEN current_origin = 'EDDB' THEN 'Berlin (BER)'
        ELSE current_origin 
    END AS origin_city,
    CASE 
        WHEN current_destination = 'EDDF' THEN 'Frankfurt (FRA)'
        WHEN current_destination = 'EDDM' THEN 'Munich (MUC)'
        WHEN current_destination = 'EDDB' THEN 'Berlin (BER)'
        ELSE current_destination 
    END AS destination_city,
    current_temp_c,
    current_departure_delay,
    previous_origin,
    previous_origin_temp_c,
    previous_arrival_delay,
    CASE 
        WHEN current_departure_delay > 15 AND current_temp_c <= 0 THEN 'Local Winter Weather'
        WHEN is_cascading_delay = TRUE AND current_temp_c > 0 THEN 'Imported Domino Delay'
        WHEN current_departure_delay > 15 THEN 'Other Operational Delay'
        ELSE 'On Time'
    END AS delay_category
FROM {{ ref('fct_cascading_delays') }}