
// lib/config/constants.dart

/// Defines constant values used throughout the application.
/// This helps maintain consistency and reduces magic strings.

// --- Food Sources ---
/// Represents food data originating from the USDA Foundation Foods dataset.
const String FOOD_SOURCE_FOUNDATION = 'foundation';

/// Represents food data cached from the Open Food Facts API.
const String FOOD_SOURCE_OFF_CACHE = 'off_cache';

/// Represents food data created and managed by the user.
const String FOOD_SOURCE_USER_CREATED = 'user_created';

// --- Unit Names ---
/// Represents a standard serving unit, typically used for recipes.
const String UNIT_NAME_SERVING = 'serving';

/// Represents the gram unit of mass.
const String UNIT_NAME_GRAM = 'g';

/// Represents the ounce unit of mass.
const String UNIT_NAME_OUNCE = 'oz';

// --- Nutrient Names (for consistency, e.g., in UI or data mapping) ---
const String NUTRIENT_CALORIES = 'calories';
const String NUTRIENT_PROTEIN = 'protein';
const String NUTRIENT_FAT = 'fat';
const String NUTRIENT_CARBS = 'carbs';
const String NUTRIENT_FIBER = 'fiber';

// --- Meal Names (for logging) ---
const String MEAL_BREAKFAST = 'Breakfast';
const String MEAL_LUNCH = 'Lunch';
const String MEAL_DINNER = 'Dinner';
const String MEAL_SNACK = 'Snack';
