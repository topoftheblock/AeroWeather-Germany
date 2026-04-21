CREATE OR REPLACE TABLE `your_project.aviation.flights_clean` AS
SELECT
    flight_id,
    aircraft_id,
    departure_airport,
    arrival_airport,
    
    -- Keep timestamps as they are (Eurocontrol/OpenSky usually format these well)
    scheduled_departure,
    actual_departure,
    scheduled_arrival,
    actual_arrival,
    
    -- 1. THE NULL FIX: If delay is NULL, make it 0 minutes
    COALESCE(departure_delay_minutes, 0) AS departure_delay_minutes,
    COALESCE(arrival_delay_minutes, 0) AS arrival_delay_minutes,
    
    -- 2. FEATURE ENGINEERING: Create an easy True/False flag for >15 min delays
    CASE 
        WHEN COALESCE(departure_delay_minutes, 0) > 15 THEN TRUE 
        ELSE FALSE 
    END AS is_delayed_departure
        
FROM `your_project.aviation.flights_raw`
-- 3. FILTER: Remove completely canceled flights (where it never actually departed)
WHERE actual_departure IS NOT NULL;