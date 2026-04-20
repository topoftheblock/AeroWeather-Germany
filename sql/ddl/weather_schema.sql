CREATE OR REPLACE TABLE `your_project.german_weather.raw_stations` (
    station_id STRING,
    measurement_date TIMESTAMP,
    temperature_c FLOAT64,
    wind_speed_ms FLOAT64,
    precipitation_mm FLOAT64,
    snow_depth_cm FLOAT64,
    visibility_m INT64
);