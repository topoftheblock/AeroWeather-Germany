import os

# Station IDs: Frankfurt (01420), Munich (01262), Berlin-Brandenburg (03987)
STATIONS = ['01420', '01262', '03987']
BASE_URL = "https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/"

def print_download_instructions():
    print("--- DWD Weather Data Download Instructions ---")
    print(f"Data Source: {BASE_URL}")
    print("To avoid scraping blocks, please manually download the historical zip files for:")
    print("1. air_temperature")
    print("2. precipitation")
    print(f"Look for the following station IDs: {', '.join(STATIONS)}")
    print("Extract the CSV files and place them in your 'data/raw/' directory.")
    print("\nFor flight data, visit Eurocontrol ADRR and download the 2024 monthly CSVs to 'data/raw/'.")

if __name__ == "__main__":
    os.makedirs('data/raw', exist_ok=True)
    print_download_instructions()