SELECT 
    STATIONS_ID AS station_id,
    PARSE_TIMESTAMP('%Y%m%d%H', MESS_DATUM) AS measurement_timestamp,
    NULLIF(TT_TU, -999.0) AS temperature_c,
    NULLIF(RF_TU, -999.0) AS humidity_percent,
    QN_9 AS quality_level
FROM {{ source('aviation_raw', 'weather_raw') }}
WHERE MESS_DATUM IS NOT NULL