CREATE OR REPLACE TABLE `your_project.aviation.cascading_delays` AS
WITH flight_sequence AS (
    SELECT 
        aircraft_id,
        flight_id,
        actual_departure,
        
        -- Details about the CURRENT leg
        departure_airport AS current_origin,
        arrival_airport AS current_destination,
        departure_temp_c AS current_temp_c,
        departure_delay_minutes AS current_departure_delay,
        
        -- Use LAG() to get details about this plane's PREVIOUS leg
        LAG(departure_airport) OVER (
            PARTITION BY aircraft_id 
            ORDER BY actual_departure
        ) AS previous_origin,
        
        LAG(departure_temp_c) OVER (
            PARTITION BY aircraft_id 
            ORDER BY actual_departure
        ) AS previous_origin_temp_c,
        
        LAG(arrival_delay_minutes) OVER (
            PARTITION BY aircraft_id 
            ORDER BY actual_departure
        ) AS previous_arrival_delay
        
    FROM `your_project.aviation.flights_with_weather`
    -- Ensure we only track known aircraft
    WHERE aircraft_id IS NOT NULL 
)

SELECT 
    aircraft_id,
    flight_id,
    actual_departure,
    previous_origin,
    previous_origin_temp_c,
    previous_arrival_delay,
    current_origin,
    current_temp_c,
    current_departure_delay,
    
    -- FEATURE ENGINEERING: The "Domino Effect" Flag
    -- True if the plane arrived late from its last destination AND is departing late now
    CASE 
        WHEN previous_arrival_delay > 15 AND current_departure_delay > 15 THEN TRUE 
        ELSE FALSE 
    END AS is_cascading_delay

FROM flight_sequence
-- Filter out the very first flight of the day for each aircraft (where LAG returns NULL)
WHERE previous_arrival_delay IS NOT NULL;