CREATE OR REPLACE TABLE `your_project.aviation.flights_with_weather` AS

-- 1. DEFINE AIRPORT COORDINATES (Space)
-- Eurocontrol usually uses 4-letter ICAO codes (EDDF = Frankfurt, EDDM = Munich, EDDB = Berlin)
WITH airport_locations AS (
    SELECT 'EDDF' AS airport_code, ST_GEOGPOINT(8.5706, 50.0333) AS airport_geo UNION ALL
    SELECT 'EDDM' AS airport_code, ST_GEOGPOINT(11.7861, 48.3538) AS airport_geo UNION ALL
    SELECT 'EDDB' AS airport_code, ST_GEOGPOINT(13.5016, 52.3667) AS airport_geo
),

-- 2. DEFINE WEATHER STATION COORDINATES (Space)
station_locations AS (
    SELECT 1420 AS station_id, ST_GEOGPOINT(8.598, 50.048) AS station_geo UNION ALL -- Frankfurt DWD
    SELECT 1262 AS station_id, ST_GEOGPOINT(11.813, 48.348) AS station_geo UNION ALL -- Munich DWD
    SELECT 3987 AS station_id, ST_GEOGPOINT(13.486, 52.380) AS station_geo           -- Berlin DWD
),

-- 3. THE SPATIAL JOIN: Find the closest station to each airport
nearest_stations AS (
    SELECT 
        a.airport_code,
        s.station_id,
        ST_DISTANCE(a.airport_geo, s.station_geo) AS distance_meters
    FROM airport_locations a
    CROSS JOIN station_locations s
    -- QUALIFY keeps only the #1 closest station for each airport
    QUALIFY ROW_NUMBER() OVER(PARTITION BY a.airport_code ORDER BY distance_meters ASC) = 1
),

-- 4. THE TEMPORAL ALIGNMENT: Round flight departures to the nearest hour (Time)
flights_time_aligned AS (
    SELECT 
        *,
        -- DWD data is hourly, so we truncate the flight's actual departure to the hour
        TIMESTAMP_TRUNC(actual_departure, HOUR) AS departure_hour
    FROM `your_project.aviation.flights_clean`
)

-- 5. THE FINAL SPATIO-TEMPORAL JOIN
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
-- Join flight to the mapping table to get the correct station ID
JOIN nearest_stations n 
    ON f.departure_airport = n.airport_code
-- Join to the weather data using BOTH the station ID and the exact hour
JOIN `your_project.aviation.weather_clean` w
    ON n.station_id = w.station_id 
    AND f.departure_hour = w.measurement_timestamp;