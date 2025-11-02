
import sqlite3
import json
import os
import urllib.request
import tempfile
import zipfile

# --- Configuration ---

# Get the absolute path of the directory where the script is located
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
# Get the project root directory by going one level up
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)

# The output path for the generated SQLite database.
# This is now an absolute path to ensure it works regardless of where the script is run from.
OUTPUT_DB_PATH = os.path.join(PROJECT_ROOT, 'assets', 'reference.db')

# The specific nutrient numbers we want to extract from the dataset.
# These numbers are defined by the FoodData Central documentation.
NUTRIENT_IDS = {
    2047: 'calories_per_100g',  # Energy (Atwater General Factors) in kcal
    1003: 'protein_per_100g',
    1004: 'fat_per_100g',
    1005: 'carbs_per_100g',
    1079: 'fiber_per_100g'
}

# --- Main Script ---

def create_database_schema(cursor):
    """Creates the necessary tables for the reference database."""
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS foods (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            source TEXT NOT NULL,
            image_url TEXT,
            calories_per_100g REAL,
            protein_per_100g REAL,
            fat_per_100g REAL,
            carbs_per_100g REAL,
            fiber_per_100g REAL,
            source_fdc_id INTEGER UNIQUE,
            source_barcode TEXT
        )
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS food_units (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            food_id INTEGER NOT NULL,
            unit_name TEXT NOT NULL,
            grams_per_unit REAL NOT NULL,
            FOREIGN KEY (food_id) REFERENCES foods (id)
        )
    ''')
    print("Database schema created successfully.")

def process_foods(cursor, foods_data):
    """Processes the list of foods and inserts them into the database."""
    food_count = 0
    for food_item in foods_data:
        if food_item.get('foodClass') != 'Branded': # Skip branded foods for this import
            nutrients = extract_nutrients(food_item)

            # Validate that we have all the required nutrients
            if all(nutrients.get(field) is not None for field in NUTRIENT_IDS.values()):
                cursor.execute('''
                    INSERT INTO foods (
                        name, source, source_fdc_id,
                        calories_per_100g, protein_per_100g, fat_per_100g,
                        carbs_per_100g, fiber_per_100g
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                ''', (
                    food_item.get('description', 'Unnamed Food'),
                    'foundation',
                    food_item['fdcId'],
                    nutrients['calories_per_100g'],
                    nutrients['protein_per_100g'],
                    nutrients['fat_per_100g'],
                    nutrients['carbs_per_100g'],
                    nutrients['fiber_per_100g']
                ))
                food_db_id = cursor.lastrowid
                process_portions(cursor, food_db_id, food_item.get('foodPortions', []))
                food_count += 1

    print(f"Processed and inserted {food_count} valid food items.")

def extract_nutrients(food_item):
    """Extracts our target nutrients from a food item's nutrient list."""
    nutrients = {}
    for nutrient in food_item.get('foodNutrients', []):
        nutrient_id_str = nutrient.get('nutrient', {}).get('number')
        if nutrient_id_str:
            try:
                # Convert to float first, then to int to handle cases like "676.1"
                nutrient_id = int(float(nutrient_id_str))
                if nutrient_id in NUTRIENT_IDS:
                    field_name = NUTRIENT_IDS[nutrient_id]
                    nutrients[field_name] = nutrient.get('amount', 0.0)
            except (ValueError, TypeError):
                # Ignore if the nutrient number is not a valid number
                continue
    return nutrients

def process_portions(cursor, food_db_id, portions_data):
    """Processes the list of portions for a given food."""
    cursor.execute(
        "INSERT INTO food_units (food_id, unit_name, grams_per_unit) VALUES (?, ?, ?)",
        (food_db_id, '100g', 100.0)
    )
    for portion in portions_data:
        if 'portionDescription' in portion and 'gramWeight' in portion:
            unit_name = portion['portionDescription']
            gram_weight = portion['gramWeight']
            if unit_name and gram_weight is not None:
                cursor.execute(
                    "INSERT INTO food_units (food_id, unit_name, grams_per_unit) VALUES (?, ?, ?)",
                    (food_db_id, unit_name, float(gram_weight))
                )

def download_data(url, temp_path):
    """Downloads data from a URL to a temporary path."""
    print(f"Downloading data from {url}...")
    with urllib.request.urlopen(url) as response, open(temp_path, 'wb') as out_file:
        out_file.write(response.read())
    print("Download complete.")

def main():
    """Main function to run the ingestion process."""
    print("--- USDA Foundation Foods Ingestion Script ---")
    print("\nPlease go to the FoodData Central Download page:")
    print("https://fdc.nal.usda.gov/download-datasets.html")
    print("\nMake sure you are downloading the **JSON** version of the file.")
    print("1. Find the 'FoundationFoods' dataset.")
    print("2. Right-click on the JSON file link.")
    print("3. Click 'Copy Link Address' (or similar).")
    download_url = input("4. Paste the direct download URL here and press Enter:\n> ")

    if not download_url.strip().startswith('http'):
        print("\nInvalid URL. Please provide a valid direct download link.")
        return

    output_dir = os.path.dirname(OUTPUT_DB_PATH)
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    if os.path.exists(OUTPUT_DB_PATH):
        os.remove(OUTPUT_DB_PATH)
        print(f"\nRemoved old database file at '{OUTPUT_DB_PATH}'.")

    conn = None
    download_temp_file = None
    extract_temp_dir = None

    try:
        download_temp_file = tempfile.NamedTemporaryFile(delete=False, suffix=".zip")
        download_path = download_temp_file.name
        download_temp_file.close()

        download_data(download_url, download_path)

        json_file_path = download_path
        if download_url.lower().endswith('.zip'):
            print("ZIP file detected. Extracting...")
            extract_temp_dir = tempfile.TemporaryDirectory()
            with zipfile.ZipFile(download_path, 'r') as zip_ref:
                json_file_name = next((name for name in zip_ref.namelist() if name.lower().endswith('.json')), None)
                if not json_file_name:
                    raise FileNotFoundError("Could not find a .json file in the ZIP archive.")
                zip_ref.extractall(extract_temp_dir.name)
                json_file_path = os.path.join(extract_temp_dir.name, json_file_name)
            print(f"Extracted JSON file to: {json_file_path}")

        conn = sqlite3.connect(OUTPUT_DB_PATH)
        cursor = conn.cursor()
        create_database_schema(cursor)

        with open(json_file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            foundation_foods = data.get('FoundationFoods', [])
        
        process_foods(cursor, foundation_foods)
        conn.commit()
        print(f"\nSuccessfully created reference database at '{OUTPUT_DB_PATH}'.")

    except urllib.error.URLError as e:
        print(f"\nDownload error: {e}. Please check the URL.")
    except (zipfile.BadZipFile, FileNotFoundError) as e:
        print(f"\nArchive error: {e}. Make sure the URL points to a valid ZIP file containing 'FoundationFoods.json'.")
    except sqlite3.Error as e:
        print(f"\nDatabase error: {e}")
    except json.JSONDecodeError as e:
        print(f"\nJSON decoding error: {e}. The extracted file may not be valid JSON.")
    except Exception as e:
        print(f"\nAn unexpected error occurred: {e}")
    finally:
        if conn:
            conn.close()
        if download_temp_file and os.path.exists(download_path):
            os.remove(download_path)
            print(f"Cleaned up temporary download: {download_path}")
        if extract_temp_dir:
            extract_temp_dir.cleanup()
            print("Cleaned up temporary extraction directory.")

if __name__ == '__main__':
    main()
