CREATE OR REPLACE TABLE `your_project.aviation.weather_raw` (
    STATIONS_ID INT64,
    MESS_DATUM STRING, -- DWD uses YYYYMMDDHH format
    QN_9 INT64,
    TT_TU FLOAT64,     -- Air Temperature
    RF_TU FLOAT64,     -- Humidity
    eor STRING
);