#  Weather-Driven Cascading Flight Delays — German Domestic Aviation Network

This project analyzes how localized weather events cause cascading delays across the German domestic aviation network. By joining **DWD (Deutscher Wetterdienst)** weather records with **Eurocontrol** flight data using spatial and temporal SQL joins, this pipeline tracks whether a plane delayed by a snowstorm in Munich (MUC) carries that delay into its next departure from a sunny Frankfurt (FRA).

---

##  Tech Stack

| Layer | Technology |
|---|---|
| Language | SQL (BigQuery Dialect), Python 3 |
| Data Warehouse | Google BigQuery |
| Storage | Google Cloud Storage |
| Key SQL Concepts | Geospatial Joins (`ST_DISTANCE`), Window Functions (`LAG()`, `QUALIFY`), CTEs, Time-series alignment |

---

##  Project Structure

```text
├── data/
│   ├── raw/            # Ignored in git. Contains raw CSVs from DWD & Eurocontrol
│   └── reference/      # Mapping files
├── scripts/
│   └── download_dwd.py # Python script to fetch historical DWD weather data
├── sql/
│   ├── ddl/            # Schema definitions (weather_schema.sql, flights_schema.sql)
│   ├── transformations/ # Cleaning and Spatio-Temporal Joins
│   └── analysis/       # Window function queries for cascading delays
├── notebooks/          # Jupyter notebooks for initial EDA
├── docs/               # Architecture diagrams and visualization exports
└── README.md
```

---

##  Data Pipeline & Methodology

### Phase 1: Data Acquisition

- **Weather:** Extracted historical hourly temperature and precipitation data for Frankfurt (1420), Munich (1262), and Berlin (3987) via the DWD Open Data portal using Python.
- **Flights:** Sourced scheduled vs. actual flight trajectories from the Eurocontrol Aviation Data Repository for Research (ADRR).

### Phase 2: Transformation & Cleaning

- **Timestamp Alignment:** Converted DWD's `YYYYMMDDHH` string format into BigQuery `TIMESTAMP` objects.
- **Null Handling:** Standardized missing aviation delay data (imputing `0` for on-time flights) and scrubbed DWD `-999.0` error codes.

### Phase 3: The Spatio-Temporal Join

- Utilized BigQuery's Geospatial functions (`ST_GEOGPOINT`, `ST_DISTANCE`) to dynamically map each departure airport (EDDF, EDDM, EDDB) to its nearest DWD weather station.
- Matched flight departure times to the nearest hourly weather reading using `TIMESTAMP_TRUNC()`.

### Phase 4: Sequential Delay Tracking (The Domino Effect)

- Used `LAG()` window functions, partitioned by `aircraft_id` and ordered by `actual_departure`, to track individual plane airframes across multiple legs of their daily journey.
- Engineered an `is_cascading_delay` boolean flag to isolate flights that departed late specifically because their inbound flight arrived late from a previous destination.

---

##  How to Reproduce

1. **Clone the repository.**

2. **Fetch weather data** by running the DWD download script:
   ```bash
   python scripts/download_dwd.py
   ```
   This pulls historical hourly data into `data/raw/`.

3. **Download flight data** from the [Eurocontrol ADRR](https://www.eurocontrol.int/tool/aviation-data-repository-research) and place the files in `data/raw/`.

4. **Upload to Google Cloud Storage** and execute the DDL scripts via the BigQuery console:
   ```
   sql/ddl/weather_schema.sql
   sql/ddl/flights_schema.sql
   ```

5. **Run the transformation pipeline** by executing scripts in `sql/transformations/` in numerical order, followed by the analysis query:
   ```
   sql/analysis/01_domino_effect.sql
   ```