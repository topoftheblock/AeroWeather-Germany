SELECT
    flight_id,
    aircraft_id,
    departure_airport,
    arrival_airport,
    scheduled_departure,
    actual_departure,
    scheduled_arrival,
    actual_arrival,
    COALESCE(departure_delay_minutes, 0) AS departure_delay_minutes,
    COALESCE(arrival_delay_minutes, 0) AS arrival_delay_minutes,
    CASE 
        WHEN COALESCE(departure_delay_minutes, 0) > 15 THEN TRUE 
        ELSE FALSE 
    END AS is_delayed_departure
FROM {{ source('aviation_raw', 'flights_raw') }}
WHERE actual_departure IS NOT NULL