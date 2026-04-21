WITH flight_sequence AS (
    SELECT 
        aircraft_id,
        flight_id,
        actual_departure,
        departure_airport AS current_origin,
        arrival_airport AS current_destination,
        departure_temp_c AS current_temp_c,
        departure_delay_minutes AS current_departure_delay,
        
        LAG(departure_airport) OVER (
            PARTITION BY aircraft_id ORDER BY actual_departure
        ) AS previous_origin,
        
        LAG(departure_temp_c) OVER (
            PARTITION BY aircraft_id ORDER BY actual_departure
        ) AS previous_origin_temp_c,
        
        LAG(arrival_delay_minutes) OVER (
            PARTITION BY aircraft_id ORDER BY actual_departure
        ) AS previous_arrival_delay
        
    -- Notice how we reference the upstream model here!
    FROM {{ ref('fct_flight_weather') }} 
    WHERE aircraft_id IS NOT NULL 
)

SELECT 
    *,
    CASE 
        WHEN previous_arrival_delay > 15 AND current_departure_delay > 15 THEN TRUE 
        ELSE FALSE 
    END AS is_cascading_delay
FROM flight_sequence
WHERE previous_arrival_delay IS NOT NULL