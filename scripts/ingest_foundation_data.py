import os
import sqlite3
import zipfile
import json
from io import BytesIO
from urllib.request import urlopen

# --- Configuration ---
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
DB_FILE = os.path.join(PROJECT_ROOT, 'assets', 'reference.db')
USDA_BASE = "https://fdc.nal.usda.gov/fdc-datasets/"

# Nutrients we want, mapping the names found in the JSON to our DB column names
WANTED_NUTRIENTS = {
    "Energy": "calories_per_100g",
    "Protein": "protein_per_100g",
    "Total lipid (fat)": "fat_per_100g",
    "Carbohydrate, by difference": "carbs_per_100g",
    "Fiber, total dietary": "fiber_per_100g",
}

def init_db(conn):
    """Creates the database schema based on the application's requirements."""
    cur = conn.cursor()

    # Main foods table, matching the schema expected by database_service.dart
    cur.execute("""
        CREATE TABLE IF NOT EXISTS foods (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            source TEXT NOT NULL,
            source_fdc_id INTEGER UNIQUE,
            calories_per_100g REAL,
            protein_per_100g REAL,
            fat_per_100g REAL,
            carbs_per_100g REAL,
            fiber_per_100g REAL
        );
    """
    )

    # food_units table, matching the schema expected by database_service.dart
    cur.execute("""
        CREATE TABLE IF NOT EXISTS food_units (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            food_id INTEGER NOT NULL,
            unit_name TEXT NOT NULL,
            grams_per_unit REAL NOT NULL,
            FOREIGN KEY (food_id) REFERENCES foods(id)
        );
    """
    )

    conn.commit()
    print("Database schema created/verified successfully.")

def download_and_extract(url):
    """Downloads a zip file from a URL and extracts the first JSON file found."""
    print(f"🔽 Downloading: {url}")
    with urlopen(url) as resp:
        data = resp.read()

    zf = zipfile.ZipFile(BytesIO(data))
    json_data = None
    for name in zf.namelist():
        if name.endswith(".json"):
            print(f"📂 Extracting: {name}")
            raw = zf.read(name).decode("utf-8").strip()
            
            try:
                parsed = json.loads(raw)
                # Assuming the main food data is under a key like 'FoundationFoods' or 'SRLegacyFoods'
                # or is a top-level list
                if isinstance(parsed, dict):
                    if "FoundationFoods" in parsed:
                        json_data = parsed["FoundationFoods"]
                    elif "SRLegacyFoods" in parsed:
                        json_data = parsed["SRLegacyFoods"]
                    # Add other top-level keys if needed, e.g., 'SurveyFoods'
                elif isinstance(parsed, list):
                    json_data = parsed  # Top-level array case
                
                if json_data is not None:
                    return json_data

            except json.JSONDecodeError:
                print(f"Could not parse {name} as a single JSON object/array. Trying NDJSON fallback...")
                # NDJSON fallback for potentially branded foods or other formats
                foods = []
                for line in raw.splitlines():
                    line = line.strip()
                    if line:
                        try:
                            foods.append(json.loads(line))
                        except json.JSONDecodeError:
                            continue
                if foods:
                    return foods

    raise FileNotFoundError(f"No valid JSON food data found in the zip from {url}")

def parse_foods(data, source_name):
    """Parses the raw JSON data into a structured list of food dictionaries."""
    foods = []
    for item in data:
        fdc_id = item.get("fdcId")
        description = item.get("description")
        if not fdc_id or not description:
            continue # Skip if essential ID or description is missing

        # --- 1. Extract Nutrients ---
        # Initialize all wanted nutrients to None
        nutrients = {db_col: None for db_col in WANTED_NUTRIENTS.values()}
        
        for n in item.get("foodNutrients", []):
            nutrient_name = n.get("nutrient", {}).get("name")
            amount = n.get("amount")
            unit = n.get("nutrient", {}).get("unitName")

            if nutrient_name in WANTED_NUTRIENTS and amount is not None:
                db_col = WANTED_NUTRIENTS[nutrient_name]
                value = float(amount)
                
                # Convert Energy from kJ to kcal if necessary
                if nutrient_name == "Energy" and unit == "kJ":
                    value /= 4.184  # 1 kcal = 4.184 kJ
                
                nutrients[db_col] = value

        # --- 2. Filter & Prune (Apply Rules) ---
        # Require Calories, Protein, Fat, Carbs. If any are missing, skip food.
        required_macros = ["calories_per_100g", "protein_per_100g", "fat_per_100g", "carbs_per_100g"]
        if any(nutrients[macro] is None for macro in required_macros):
            continue 

        # If Fiber is missing, default to 0
        if nutrients["fiber_per_100g"] is None:
            nutrients["fiber_per_100g"] = 0.0

        # --- 3. Extract Portions ---
        portions = []
        # Always add 100g as a base unit
        portions.append({"unit_name": "100g", "grams_per_unit": 100.0})

        for p in item.get("foodPortions", []):
            gram_weight = p.get("gramWeight")
            if gram_weight is None or gram_weight <= 0:
                continue
            
            # Construct unit name with fallback logic
            unit_name = (
                         p.get("portionDescription") 
                         or p.get("modifier") 
                         or p.get("measureUnit", {}).get("name") 
                         or "serving"
                        )
            
            # Add modifier if present and not already part of description
            modifier = p.get("modifier")
            if modifier and modifier.lower() not in unit_name.lower():
                unit_name = f"{unit_name}, {modifier}"

            portions.append({
                "unit_name": unit_name.strip(),
                "grams_per_unit": float(gram_weight),
            })

        # --- 4. Assemble Food Record ---
        foods.append({
            "name": description.title(), # Title case for consistency
            "source": source_name,
            "source_fdc_id": fdc_id,
            **nutrients,
            "units": portions,
        })
    return foods

def upsert_foods(conn, foods):
    """Inserts or updates food records in the database."""
    cur = conn.cursor()
    upsert_count = 0
    insert_count = 0

    for f in foods:
        # Check if food exists by source_fdc_id
        cur.execute("SELECT id FROM foods WHERE source_fdc_id=?", (f["source_fdc_id"],))
        result = cur.fetchone()
        food_id = result[0] if result else None

        if food_id: # Update existing food
            cur.execute(
                """
                UPDATE foods SET
                   name=?, source=?, calories_per_100g=?, protein_per_100g=?,
                   fat_per_100g=?, carbs_per_100g=?, fiber_per_100g=?
                WHERE id=?
                """,
                (
                    f["name"], f["source"], f["calories_per_100g"], f["protein_per_100g"],
                    f["fat_per_100g"], f["carbs_per_100g"], f["fiber_per_100g"], food_id
                ),
            )
            upsert_count += 1
            # Clear old units before inserting new ones
            cur.execute("DELETE FROM food_units WHERE food_id=?", (food_id,))
        else: # Insert new food
            cur.execute(
                """
                INSERT INTO foods
                (name, source, source_fdc_id, calories_per_100g, protein_per_100g, fat_per_100g, carbs_per_100g, fiber_per_100g)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    f["name"], f["source"], f["source_fdc_id"], f["calories_per_100g"],
                    f["protein_per_100g"], f["fat_per_100g"], f["carbs_per_100g"], f["fiber_per_100g"]
                ),
            )
            insert_count += 1
            food_id = cur.lastrowid

        # Insert units for the food
        for u in f["units"]:
            cur.execute(
                "INSERT INTO food_units (food_id, unit_name, grams_per_unit) VALUES (?, ?, ?)",
                (food_id, u["unit_name"], u["grams_per_unit"]),
            )

    conn.commit()
    print(f"✅ Inserted {insert_count} new foods and updated {upsert_count} existing foods.")


def main():
    """Main function to run the ingestion process."""
    print("--- USDA Foods Database Ingestion Script ---")
    print("This script will download and process datasets from FoodData Central.")
    print(f"The final database will be stored at: {DB_FILE}")
    
    print("\n➡️  Go to: https://fdc.nal.usda.gov/download-datasets.html")
    print("⚠️  Copy the **JSON** download link for the following datasets.")

    foundation_url = input("\nEnter the FOUNDATION dataset URL: ").strip()
    sr_url = input("Enter the SR LEGACY dataset URL: ").strip()

    datasets = {
        "FOUNDATION": foundation_url,
        "SR_LEGACY": sr_url,
    }
    
    output_dir = os.path.dirname(DB_FILE)
    if not os.path.exists(output_dir):
        os.makedirs(output_dir, exist_ok=True) # Use exist_ok=True to prevent error if dir already exists

    # Remove old database file to ensure a clean start or update
    if os.path.exists(DB_FILE):
        os.remove(DB_FILE)
        print(f"\nRemoved old database file at '{DB_FILE}'.")

    conn = sqlite3.connect(DB_FILE)
    init_db(conn)

    for source, url in datasets.items():
        if not url:
            print(f"Skipping {source} due to empty URL.")
            continue
        
        # Prepend base URL if user provides only filename
        if not url.startswith("http"):
            url = USDA_BASE + url
        
        try:
            data = download_and_extract(url)
            foods = parse_foods(data, source)
            print(f"Found {len(foods)} valid foods in {source}.")
            upsert_foods(conn, foods)
        except Exception as e:
            print(f"❌ Failed to process {source} from {url}. Error: {e}")

    conn.close()
    print("\n🎉 Done. The reference database has been updated.")

if __name__ == "__main__":
    main()