CREATE OR REPLACE TABLE `your_project.aviation.weather_clean` AS
SELECT 
    STATIONS_ID AS station_id,
    
    -- 1. THE TIMESTAMP FIX: Convert 'YYYYMMDDHH' to a BigQuery TIMESTAMP
    PARSE_TIMESTAMP('%Y%m%d%H', MESS_DATUM) AS measurement_timestamp,
    
    -- 2. THE NULL FIX: Convert DWD's -999.0 error codes into actual NULLs
    NULLIF(TT_TU, -999.0) AS temperature_c,
    NULLIF(RF_TU, -999.0) AS humidity_percent,
    
    -- Keep the quality control indicator just in case
    QN_9 AS quality_level
    
FROM `your_project.aviation.weather_raw`
WHERE MESS_DATUM IS NOT NULL;