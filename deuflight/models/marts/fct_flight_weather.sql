WITH airport_locations AS (
    SELECT 'EDDF' AS airport_code, ST_GEOGPOINT(8.5706, 50.0333) AS airport_geo UNION ALL
    SELECT 'EDDM' AS airport_code, ST_GEOGPOINT(11.7861, 48.3538) AS airport_geo UNION ALL
    SELECT 'EDDB' AS airport_code, ST_GEOGPOINT(13.5016, 52.3667) AS airport_geo
),
station_locations AS (
    SELECT 1420 AS station_id, ST_GEOGPOINT(8.598, 50.048) AS station_geo UNION ALL
    SELECT 1262 AS station_id, ST_GEOGPOINT(11.813, 48.348) AS station_geo UNION ALL
    SELECT 3987 AS station_id, ST_GEOGPOINT(13.486, 52.380) AS station_geo
),
nearest_stations AS (
    SELECT 
        a.airport_code,
        s.station_id,
        ST_DISTANCE(a.airport_geo, s.station_geo) AS distance_meters
    FROM airport_locations a
    CROSS JOIN station_locations s
    QUALIFY ROW_NUMBER() OVER(PARTITION BY a.airport_code ORDER BY distance_meters ASC) = 1
),
flights_time_aligned AS (
    SELECT 
        *,
        TIMESTAMP_TRUNC(actual_departure, HOUR) AS departure_hour
    FROM {{ ref('stg_flights') }}
)

SELECT 
    f.flight_id,
    f.aircraft_id,
    f.departure_airport,
    f.arrival_airport,
    f.actual_departure,
    f.departure_delay_minutes,
    f.is_delayed_departure,
    w.temperature_c AS departure_temp_c,
    w.humidity_percent AS departure_humidity,
    n.distance_meters AS station_distance_from_airport
FROM flights_time_aligned f
JOIN nearest_stations n ON f.departure_airport = n.airport_code
JOIN {{ ref('stg_weather') }} w ON n.station_id = w.station_id AND f.departure_hour = w.measurement_timestamp