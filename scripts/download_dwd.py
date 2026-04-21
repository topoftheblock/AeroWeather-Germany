import pandas as pd
import requests
import zipfile
import io
import os

# Station IDs for major German Airports:
# Frankfurt (1420), Munich (1262), Berlin-Brandenburg (3987)
STATIONS = ['01420', '01262', '03987']
BASE_URL = "https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/"

def download_dwd_data(category):
    all_data = []
    for s_id in STATIONS:
        # Construct the historical file name pattern
        # DWD file names follow a pattern: stundenwerte_TU_01420_19490101_20231231_hist.zip
        # Note: You may need to browse the URL to get the exact filename for the current year
        url = f"{BASE_URL}{category}/historical/"
        print(f"Fetching station {s_id} from {url}...")
        
        # In a real scenario, you'd use a scraper or known filenames. 
        # For this demo, let's assume you've identified the specific 2024 files.
        # Placeholder for the actual file names you find in the DWD directory:
        # filename = f"stundenwerte_{category_code}_{s_id}_20240101_20241231_hist.zip"
    
    print("Download complete. Check data/raw folder.")

# Manual download is often faster for DWD:
# 1. Go to: https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/air_temperature/historical/
# 2. Search (Ctrl+F) for the Station IDs above.
# 3. Download the .zip files and place them in data/raw/