# DeuFlight-Analytics: German Flight & Weather Correlation

##  Project Overview
This project analyzes the "domino effect" of weather-related delays across the German aviation network. By joining **DWD (Deutscher Wetterdienst)** weather records with **OpenSky Network** flight data using SQL, I aim to visualize how a storm in Frankfurt cascades into delays in Berlin or Munich.

##  Tech Stack
* **Language:** SQL (BigQuery Dialect)
* **Storage:** Google Cloud Storage / BigQuery
* **Data Sources:** * [DWD Open Data](https://opendata.dwd.de/)
    * [OpenSky Network Historical Data](https://opensky-network.org/)

##  Project Structure
* `sql/ddl/`: Table definitions and schemas.
* `sql/transformations/`: Cleaning scripts and complex JOINs.
* `sql/analysis/`: Queries for delay propagation and patterns.

##  Key Findings
*(Coming Soon - I will document my insights here once the analysis is complete!)*