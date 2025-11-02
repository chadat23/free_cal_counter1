# FreeCal Counter: Architectural Action Plan

## 1. Overview & Core Principles

This document outlines the data architecture and implementation plan for the FreeCal Counter application. It serves as a point of reference for all future development decisions.

Our design is guided by four core principles:

*   **Stability & Immutability:** User trust is paramount. A logged entry must never change, even if the underlying data sources are updated. This ensures historical accuracy and reliability.
*   **Performance:** The application must be fast and responsive. This is achieved through a lightweight, offline-first approach with a local database, aggressive data pruning, and a local-first search strategy.
*   **Flexibility:** The data model must support a user-friendly and intuitive logging experience (e.g., logging by "cup" or "gram") and be extensible for future features.
*   **Maintainability:** The architecture must be robust and easy to maintain, with clear separation of concerns and a plan for future database schema upgrades.

## 2. System Architecture: The "Live vs. Reference" Model

To achieve our goals, we will use a two-database model that separates pristine reference data from active user data.

*   **`reference.db` (The Library):**
    *   **Contents:** A read-only SQLite database containing curated data from the USDA Foundation Foods dataset.
    *   **Purpose:** Acts as a bundled, local "API" that the app can query for standard, raw food items.
    *   **Updates:** This entire file will be generated and replaced by an external script during development. A new app release will ship with the updated `reference.db` file.

*   **`live.db` (The User's Journal):**
    *   **Contents:** A writable SQLite database that holds all data the user has personally interacted with. This includes cached items from Open Food Facts, user-created foods, user-created recipes, and **copies** of items from `reference.db` the first time a user logs them.
    *   **Purpose:** This is the single source of truth for all logged data. Every food or recipe log entry links *only* to records in this database.

*   **Rationale:** This model brilliantly solves the data update problem. We can completely overhaul the `reference.db` in an app update without any risk of breaking users' existing logs, as those logs have no direct link to the reference data. It provides perfect immutability.

## 3. Database Schema (`live.db`)

The following tables will be implemented in `live.db`. The `reference.db` will contain a read-only subset of this schema (primarily `foods` and `food_units`).

| `foods` Table - Stores individual food items. | |
|---|---|
| **Column** | **Type** | **Notes** |
| `id` | INTEGER | Primary Key |
| `name` | TEXT | e.g., "Apple, raw, with skin" |
| `source` | TEXT | 'foundation', 'off_cache', 'user_created' |
| `image_url` | TEXT | Nullable. URL for OFF food images. |
| `calories_per_100g` | REAL | |
| `protein_per_100g` | REAL | |
| `fat_per_100g` | REAL | |
| `carbs_per_100g` | REAL | |
| `fiber_per_100g` | REAL | |
| `source_fdc_id` | INTEGER | Nullable. The original FDC ID from `reference.db` to prevent duplicate copying. |
| `source_barcode` | TEXT | Nullable. The barcode from OFF. Used for search. |

| `food_units` Table - Defines valid measurement units for each food. | |
|---|---|
| **Column** | **Type** | **Notes** |
| `id` | INTEGER | Primary Key |
| `food_id` | INTEGER | Foreign Key to `foods.id` |
| `unit_name` | TEXT | The display name, e.g., "cup", "slice", "medium" |
| `grams_per_unit` | REAL | The corresponding weight in grams for one unit. |

| `recipes` Table - Stores high-level recipe information. | |
|---|---|
| **Column** | **Type** | **Notes** |
| `id` | INTEGER | Primary Key |
| `name` | TEXT | e.g., "Mom's Chili" |
| `servings_created` | REAL | The total number of servings the recipe yields. |
| `final_weight_grams`| REAL | Nullable. The final weight of the cooked dish for density calculation. |
| `notes` | TEXT | Nullable. User-provided instructions. |

| `recipe_items` Table - Defines the ingredients of a recipe. | |
|---|---|
| **Column** | **Type** | **Notes** |
| `id` | INTEGER | Primary Key |
| `recipe_id` | INTEGER | Foreign Key to `recipes.id` |
| `ingredient_food_id` | INTEGER | Nullable FK to `foods.id`. |
| `ingredient_recipe_id` | INTEGER | Nullable FK to `recipes.id` for nested recipes. |
| `quantity` | REAL | The amount of this ingredient. |
| `unit_name` | TEXT | The unit for the quantity, e.g., "cups", "g". |

| `logged_foods` Table (Revised) - The user's daily food log. | |
|---|---|
| **Column** | **Type** | **Notes** |
| `id` | INTEGER | Primary Key |
| `log_timestamp` | INTEGER | Unix timestamp for the log entry. |
| `meal_name` | TEXT | e.g., "Breakfast", "Lunch" |
| `food_id` | INTEGER | Nullable FK to `foods.id`. |
| `recipe_id` | INTEGER | Nullable FK to `recipes.id`. |
| `quantity` | REAL | The numeric quantity consumed. Replaces `num_servings`. |
| `unit_name` | TEXT | The unit for the quantity, e.g., "g", "cup", "slice", "serving". |

## 4. Core Concepts & Logic

*   **Immutability ("Implicit Copy on Edit"):** A food or recipe in `live.db` is mutable until it has been logged at least once. If a user "edits" an item that has been previously logged, the application creates a **new** record with the changes and leaves the original untouched. Past logs point to the original; new logs will point to the new record.
*   **Barcode Scanning Flow:** Scan -> Search `live.db` by barcode -> On miss, fetch from OFF API -> Adapt and cache result in `live.db` -> Log.
*   **OFF Image Handling:** Image URLs from OFF will be stored in the `image_url` field. The app will **not** store image binaries in the database. A Flutter package like `cached_network_image` will be used to load images on-demand from the URL and cache them on the device's file system.
*   **Recipe Features:**
    *   **Logging:** A recipe can be logged as a single item (e.g., "1.5 servings of Chili").
    *   **Templating ("Expand Ingredients"):** A recipe can also be used as a template to add its ingredients to a meal as individual, editable items.
    *   **Mass Scaling:** A user can optionally weigh their final cooked recipe and enter the `final_weight_grams`. The app will use this to calculate the nutrient density of the finished dish, allowing for accurate logging by weight (e.g., "150g of cooked chili").

## 5. Action Plan: Implementation Tasks

These tasks are broken down into phases. Each task is designed to be a self-contained unit of work.

### Phase 1: Foundational Setup

**Task 1.1: Choose & Configure Database Library**
*   **Goal:** Establish the core database infrastructure within the Flutter project.
*   **Action:** Research and select a high-level Flutter database library that provides robust, built-in support for schema migrations.
*   **Recommendation:** The **`drift`** package is strongly recommended as it is feature-rich, type-safe, and handles migrations automatically.
*   **Testing Strategy:** N/A. This is a selection and configuration task.
*   **Acceptance Criteria:** A new Flutter project can successfully open a database connection using the chosen library. The project includes the necessary boilerplate for defining tables and handling schema versions.

**Task 1.2: Implement Foundation Data Ingestion Script**
*   **Goal:** Create the `reference.db` file containing pristine USDA data.
*   **Details & Constraints:**
    *   The script should be located at `/scripts/ingest_foundation_data.py`.
    *   It must only use modules from the Python standard library (e.g., `json`, `csv`, `sqlite3`). No external dependencies to install.
    *   It must validate each food record and discard any that do not contain all required fields: description, calories, protein, fat, and fiber.
    *   The script's output must be the `reference.db` file, placed at `/assets/reference.db`. The `pubspec.yaml` file must be updated to include this asset path.
*   **Testing Strategy:** The script should be runnable and produce a verifiable database file. Manual inspection of the output DB is sufficient.
*   **Acceptance Criteria:** The script runs successfully and produces a `reference.db` file that can be bundled as a Flutter asset.

### Phase 2: Core Data Models & Services

**Task 2.1: Define Database Schema in Dart**
*   **Goal:** Translate the database design into Dart code.
*   **Prerequisites:** Task 1.1
*   **Action:** Using the chosen database library (`drift`), define the `foods`, `food_units`, `recipes`, `recipe_items`, and `logged_foods` tables as Dart classes. Establish this as `schema version 1`.
*   **Testing Strategy:** The generated code from `drift` will be tested implicitly in subsequent tasks.
*   **Acceptance Criteria:** The application compiles, and on first launch, it creates an empty `live.db` file with the correct tables and columns.

**Task 2.2: Implement Database Services**
*   **Goal:** Create a data access layer to abstract database operations.
*   **Prerequisites:** Task 2.1
*   **Action:** Create service classes (`ReferenceDbService`, `LiveDbService`) that expose methods for all required database interactions (e.g., `searchFoodsByName(String query)`, `getFoodById(int id)`, `saveNewFood(Food food)`).
*   **Testing Strategy:** This is critical. All public methods in these services must be fully unit tested. Use an in-memory version of the database provided by `drift` for testing to verify all logic.
*   **Acceptance Criteria:** All service methods have 80%+ unit test coverage.

### Phase 3: Food Search & Logging

**Task 3.1: Implement Open Food Facts API Service**
*   **Goal:** Integrate with the Open Food Facts API for barcode lookups and packaged food search.
*   **Action:**
    1.  Add a suitable package (e.g., `openfoodfacts`) to `pubspec.yaml`.
    2.  Create an `OffApiService` class that wraps the package.
    3.  Implement the "Adapter" logic within this service. This function will take the raw response from the API and attempt to convert it into our standard `(food, food_units)` model.
*   **Adapter Logic Details:**
    *   It must normalize nutrient data to per-100g, even if the source provides it in other mass units (e.g., per-ounce).
    *   It must reject any item that does not yield valid data for: description, calories, protein, and fat per 100g. Fiber may default to 0 if missing.
*   **Testing Strategy:** Unit test the Adapter logic thoroughly with mock API responses representing different scenarios (complete data, incomplete data, per-serving data, etc.).
*   **Acceptance Criteria:** The service can fetch data for a given barcode and correctly transform it into our app's data model, or correctly identify it as incomplete.

**Task 3.2: Build Combined Search Logic**
*   **Goal:** Create the main search provider/bloc that orchestrates searching across all data sources.
*   **Prerequisites:** Task 2.2, 3.1
*   **Action:** Implement the full search flow:
    1.  Query `LiveDbService` and `ReferenceDbService` in parallel for text searches.
    2.  For barcode searches, query `LiveDbService` first, then `OffApiService` on a miss.
    3.  Implement the on-demand copy logic: when a user selects a food from `reference.db`, check `live.db` for an existing copy (using `source_fdc_id`) before creating a new one.
*   **Testing Strategy:** Unit test the provider/bloc logic, mocking the underlying services to ensure the correct service methods are called in the correct order.
*   **Acceptance Criteria:** A search controller/provider can be used in the UI to search for food, and the data flows correctly through all sources.

**Task 3.3: Implement Food Logging UI**
*   **Goal:** Allow users to select a food and log it to a meal.
*   **Prerequisites:** Task 3.2
*   **Action:** Build the UI that allows a user to specify a `quantity` and select from the available `unit_name` options for a given food. On save, this will create a new record in the `logged_foods` table.
*   **Testing Strategy:** Implement widget tests to verify that the UI correctly displays food data, populates the units dropdown, and calls the appropriate service method on save.
*   **Acceptance Criteria:** A user can successfully search for a food, specify a portion, and save it. The new entry is verifiable in the `live.db`.

### Phase 4: Recipe Implementation

**Task 4.1: Create/Edit Recipe Logic & UI**
*   **Goal:** Allow users to create, view, and edit recipes.
*   **Prerequisites:** Task 3.2
*   **Action:** Build the UI for managing recipes. The "save" logic must implement the "Implicit Copy on Edit" pattern. Also include UI for the `final_weight_grams` (Mass Scaling) feature.
*   **Testing Strategy:** Widget test the recipe creation and editing flow. Unit test the "Copy on Edit" logic within the responsible provider/bloc.
*   **Acceptance Criteria:** A user can create a recipe. Editing a logged recipe correctly creates a new, distinct recipe in the database. The mass scaling feature is functional.

**Task 4.2: Implement Recipe Logging**
*   **Goal:** Allow users to log a recipe in two different ways.
*   **Prerequisites:** Task 4.1
*   **Action:** In the UI, provide two logging options for a recipe:
    1.  **"Log Recipe"**: Creates a single `logged_foods` entry that links to the `recipe_id`, with a `quantity` and a `unit_name` of "serving".
    2.  **"Expand Ingredients"**: Reads the `recipe_items` for the recipe and creates multiple, individual `logged_foods` entries.
*   **Testing Strategy:** Widget test the dialog/menu that presents these two options. Unit test the underlying logic to ensure the correct database entries are created for each case.
*   - **Acceptance Criteria:** Both logging methods function as described and produce the correct entries in the `logged_foods` table.
