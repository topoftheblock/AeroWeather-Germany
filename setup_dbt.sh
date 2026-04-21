#!/bin/bash
mkdir -p data/raw data/reference scripts sql/ddl sql/ml notebooks docs
dbt init deuflight
cd deuflight || exit
rm -rf models/example
mkdir -p models/staging models/marts
touch models/staging/_sources.yml models/staging/stg_weather.sql models/staging/stg_flights.sql
touch models/marts/_models.yml models/marts/fct_flight_weather.sql models/marts/fct_cascading_delays.sql models/marts/v_dashboard_reporting.sql
echo "✅ Project folders and dbt files created!"