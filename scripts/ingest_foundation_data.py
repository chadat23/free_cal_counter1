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
    "Energy": "caloriesPerGram",
    "Protein": "proteinPerGram",
    "Total lipid (fat)": "fatPerGram",
    "Carbohydrate, by difference": "carbsPerGram",
    "Fiber, total dietary": "fiberPerGram",
}

# Whitelist of food categories to include.
# This helps filter out processed foods, meals, and snacks.
ALLOWED_CATEGORIES = {
    "Vegetables and Vegetable Products",
    "Fruits and Fruit Juices",
    "Legumes and Legume Products",
    "Poultry Products",
    "Pork Products",
    "Beef Products",
    "Finfish and Shellfish Products",
    "Dairy and Egg Products",
    "Cereal Grains and Pasta",
    "Spices and Herbs",
    "Nut and Seed Products",
}

# Blacklist of keywords. If a food's description contains any of these, it's excluded.
# This is applied more strictly to SR Legacy than to Foundation data.
EXCLUDED_KEYWORDS = [
    # Preparation
    "canned", "pickled", "fermented", "fried", "roasted", "baked", "cooked",
    "grilled", "broiled", "powder", "instant", "ready-to-eat", "microwaved",
    "toasted", "steamed", "stewed", "scrambled", "babyfood", "mixed"

    # Additives/Commercial types
    "sweetened", "syrup", "dressing", "sauce", "low-fat",
    "reduced-fat", "fat-free", "low-sodium", "unsweetened", "no sugar added",
    "added sugar", "in water", "in oil",

    # Product types
    "bar", "cookie", "cake", "pie", "pastry", "ice cream", "candy", "beverage",
    "shake", "cereal", "infant formula", "toddler formula", "soup", "juice",
    "bread", "roll", "biscuit", "muffin", "pancake", "waffle", "cracker",
    "chips", "snack", "fast food", "restaurant", "entree", "meal", "dinner",
    "breakfast", "lunch", "pudding"
]


def init_db(conn):
    """Creates the database schema based on the application's requirements."""
    cur = conn.cursor()

    # Main foods table, matching the schema expected by database_service.dart
    cur.execute("""
        CREATE TABLE IF NOT EXISTS foods (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            source TEXT NOT NULL,
            emoji TEXT,
            thumbnail TEXT,
            caloriesPerGram REAL NOT NULL,
            proteinPerGram REAL NOT NULL,
            fatPerGram REAL NOT NULL,
            carbsPerGram REAL NOT NULL,
            fiberPerGram REAL NOT NULL,
            sourceFdcId INTEGER UNIQUE,
            sourceBarcode TEXT,
            hidden BOOLEAN NOT NULL DEFAULT 0
        );
    """
    )

    # food_portions table, matching the schema expected by database_service.dart
    cur.execute("""
        CREATE TABLE IF NOT EXISTS food_portions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            foodId INTEGER NOT NULL,
            unitName TEXT NOT NULL,
            gramsPerPortion REAL NOT NULL,
            amountPerPortion REAL NOT NULL,
            FOREIGN KEY (foodId) REFERENCES foods(id)
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

def parse_foods(data, source_name, strict_filtering=False):
    """Parses the raw JSON data into a structured list of food dictionaries."""
    foods = []
    for item in data:
        fdc_id = item.get("fdcId")
        description = item.get("description")
        if not fdc_id or not description:
            continue # Skip if essential ID or description is missing

        # --- 1. Filter & Prune (Apply Rules) ---
        # Rule 1: Category Whitelist (applied to all sources)
        category = item.get("foodCategory", {}).get("description")
        if category not in ALLOWED_CATEGORIES:
            continue

        # Rule 2: Keyword Blacklist (applied only with strict_filtering)
        if strict_filtering:
            description_lower = description.lower()
            if any(keyword in description_lower for keyword in EXCLUDED_KEYWORDS):
                continue

        # --- 2. Extract Nutrients ---
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
                
                # Convert from per-100g to per-gram
                value /= 100.0

                nutrients[db_col] = value

        # --- 3. Validate Nutrients ---
        # Check required macros FIRST before any other validation
        required_macros = ["caloriesPerGram", "proteinPerGram", "fatPerGram", "carbsPerGram"]
        
        # If ANY required macro is missing, skip this food entirely
        if any(nutrients.get(macro) is None for macro in required_macros):
            continue
        
        # Now validate all nutrients are valid numbers (including fiber which might still be None)
        if any(not (isinstance(v, (int, float)) and v >= 0 and v != float('inf')) 
               for v in nutrients.values() if v is not None):
            continue
        
        # Default fiber to 0 AFTER validation ensures other macros exist
        if nutrients["fiberPerGram"] is None:
            nutrients["fiberPerGram"] = 0.0

        # --- 4. Extract Portions ---
        portions = []
        for p in item.get("foodPortions", []):
            gram_weight = p.get("gramWeight")
            if gram_weight is None or gram_weight <= 0:
                continue
            
            # Construct unit name with fallback logic
            unit_name = (
                         p.get("measureUnit", {}).get("abbreviation") 
                         or p.get("measureUnit", {}).get("name") 
                         or "portion"
                        )
            
            # Construct number of units with fallback logic
            amount = (
                p.get("amount")
                or 1
            )
            
            portions.append({
                "unitName": unit_name.strip(),
                "gramsPerPortion": float(gram_weight),
                "amountPerPortion": amount
            })

        # --- 5. Assemble Food Record ---
        foods.append({
            "name": description.title(), # Title case for consistency
            "source": source_name,
            "sourceFdcId": fdc_id,
            **nutrients,
            "portions": portions,
        })
    return foods

def upsert_foods(conn, foods):
    """Inserts or updates food records in the database."""
    cur = conn.cursor()
    upsert_count = 0
    insert_count = 0

    for f in foods:
        # Check if food exists by sourceFdcId
        cur.execute("SELECT id FROM foods WHERE sourceFdcId=?", (f["sourceFdcId"],))
        result = cur.fetchone()
        food_id = result[0] if result else None

        if food_id: # Update existing food
            cur.execute(
                """
                UPDATE foods SET
                   name=?, source=?, caloriesPerGram=?, proteinPerGram=?,
                   fatPerGram=?, carbsPerGram=?, fiberPerGram=?,
                   emoji=?, thumbnail=?, sourceBarcode=?, hidden=?
                WHERE id=?
                """,
                (
                    f["name"], f["source"], f["caloriesPerGram"], f["proteinPerGram"],
                    f["fatPerGram"], f["carbsPerGram"], f["fiberPerGram"],
                    None, None, None, 0, # emoji, thumbnail, sourceBarcode, hidden
                    food_id
                ),
            )
            upsert_count += 1
            # Clear old units before inserting new ones
            cur.execute("DELETE FROM food_portions WHERE foodId=?", (food_id,))
        else: # Insert new food
            cur.execute(
                """
                INSERT INTO foods
                (name, source, sourceFdcId, caloriesPerGram, proteinPerGram, fatPerGram, carbsPerGram, fiberPerGram, emoji, thumbnail, sourceBarcode, hidden)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    f["name"], f["source"], f["sourceFdcId"], f["caloriesPerGram"],
                    f["proteinPerGram"], f["fatPerGram"], f["carbsPerGram"], f["fiberPerGram"],
                    None, None, None, 0 # emoji, thumbnail, sourceBarcode, hidden
                ),
            )
            insert_count += 1
            food_id = cur.lastrowid

        # Insert portions for the food
        for p in f["portions"]:
            cur.execute(
                """
                INSERT INTO food_portions 
                (foodId, unitName, gramsPerPortion, amountPerPortion) 
                VALUES (?, ?, ?, ?)
                """,
                (food_id, p["unitName"], p["gramsPerPortion"], p["amountPerPortion"]),
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

    # We process SR Legacy first with strict filtering, then Foundation with loose filtering.
    # This ensures high-quality Foundation data overwrites any SR Legacy entries if needed.
    datasets = {
        "SR_LEGACY": {"url": sr_url, "strict": True},
        "FOUNDATION": {"url": foundation_url, "strict": False},
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

    for source, config in datasets.items():
        url = config["url"]
        strict_filtering = config["strict"]

        if not url:
            print(f"Skipping {source} due to empty URL.")
            continue
        
        # Prepend base URL if user provides only filename
        if not url.startswith("http"):
            url = USDA_BASE + url
        
        try:
            data = download_and_extract(url)
            foods = parse_foods(data, source, strict_filtering=strict_filtering)
            print(f"Found {len(foods)} valid foods in {source} after filtering.")
            upsert_foods(conn, foods)
        except Exception as e:
            print(f"❌ Failed to process {source} from {url}. Error: {e}")

    conn.close()
    print("\n🎉 Done. The reference database has been updated.")

if __name__ == "__main__":
    main()