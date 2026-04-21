CREATE OR REPLACE TABLE `your_project.aviation.flights_raw` (
    flight_id STRING,
    aircraft_id STRING,
    departure_airport STRING,
    arrival_airport STRING,
    scheduled_departure TIMESTAMP,
    actual_departure TIMESTAMP,
    departure_delay_minutes FLOAT64,
    scheduled_arrival TIMESTAMP,
    actual_arrival TIMESTAMP,
    arrival_delay_minutes FLOAT64
);