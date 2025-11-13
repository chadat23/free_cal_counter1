import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/models/food_unit.dart' as model_unit;
import 'package:free_cal_counter1/services/off_api_client_wrapper.dart';

class OffApiService {
  final OffApiClientWrapper _apiWrapper;

  OffApiService({OffApiClientWrapper? apiWrapper})
    : _apiWrapper = apiWrapper ?? OffApiClientWrapper();

  Future<model.Food?> fetchFoodByBarcode(String barcode) async {
    final productResult = await _apiWrapper.getProductV3(
      ProductQueryConfiguration(barcode, version: ProductQueryVersion.v3),
    );

    if (productResult.status != ProductResultV3.statusSuccess ||
        productResult.product == null) {
      return null;
    }

    return _processProduct(productResult.product!);
  }

  Future<List<model.Food>> searchFoodsByName(String query) async {
    final ProductSearchQueryConfiguration
    configuration = ProductSearchQueryConfiguration(
      parametersList: <Parameter>[
        SearchTerms(terms: [query]),
        PageSize(size: 20),
      ],
      language: OpenFoodFactsLanguage.ENGLISH,
      fields: [
        ProductField.NAME,
        ProductField.BARCODE,
        ProductField.IMAGE_FRONT_URL,
        ProductField.NUTRIMENTS,
        ProductField.SERVING_SIZE,
        ProductField.SERVING_QUANTITY,
      ],
      version: ProductQueryVersion.v3,
    );

    final SearchResult searchResult = await _apiWrapper.searchProducts(
      null, // User can be null for public searches
      configuration,
    );

    if (searchResult.products == null || searchResult.products!.isEmpty) {
      return [];
    }

    final List<model.Food> foods = [];
    for (final Product product in searchResult.products!) {
      final food = await _processProduct(product);
      if (food != null) {
        foods.add(food);
      }
    }

    return foods;
  }

  Future<model.Food?> _processProduct(Product product) async {
    final nutriments = product.nutriments;
    if (nutriments == null) {
      return null;
    }

    // --- Step 1: Determine the best anchor and calculate baseline per 100g values ---
    double? baseEnergyPer100g;
    double? baseProteinPer100g;
    double? baseFatPer100g;
    double? baseCarbsPer100g;
    double? caloriesPerGram; // This will be our bridging ratio

    // Option A: Direct per 100g data (highest priority anchor)
    baseEnergyPer100g = nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams);
    baseProteinPer100g = nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams);
    baseFatPer100g = nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams);
    baseCarbsPer100g = nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams);

    if (baseEnergyPer100g != null && baseProteinPer100g != null && baseFatPer100g != null && baseCarbsPer100g != null) {
      caloriesPerGram = baseEnergyPer100g / 100.0;
    } else {
      // Option B: Serving size with explicit grams or volume (secondary anchor)
      // This part needs to be more robust. OpenFoodFacts has 'portions' field, but it's often empty.
      // We'll rely on parsing servingSize and servingQuantity for now.

      double? servingGrams;
      final servingSizeText = product.servingSize;
      final servingQuantity = product.servingQuantity;

      if (servingSizeText != null && servingQuantity != null) {
        // Try to extract grams from servingSize (e.g., "30g")
        final RegExp gramRegex = RegExp(r'(\d+(\.\d+)?)\s*g');
        final gramMatch = gramRegex.firstMatch(servingSizeText);
        if (gramMatch != null) {
          servingGrams = double.tryParse(gramMatch.group(1)!);
        }

        // Try to extract ml from servingSize (e.g., "15ml") and use 1ml=1g heuristic
        if (servingGrams == null) {
          final RegExp mlRegex = RegExp(r'(\d+(\.\d+)?)\s*ml');
          final mlMatch = mlRegex.firstMatch(servingSizeText);
          if (mlMatch != null) {
            servingGrams = double.tryParse(mlMatch.group(1)!);
          }
        }

        // Fallback to servingQuantity if it seems like a gram value
        if (servingGrams == null && servingQuantity > 0 && servingQuantity < 1000) {
          servingGrams = servingQuantity;
        }
      }

      if (servingGrams != null && servingGrams > 0) {
        final servingEnergy = nutriments.getValue(Nutrient.energyKCal, PerSize.serving);
        final servingProtein = nutriments.getValue(Nutrient.proteins, PerSize.serving);
        final servingFat = nutriments.getValue(Nutrient.fat, PerSize.serving);
        final servingCarbs = nutriments.getValue(Nutrient.carbohydrates, PerSize.serving);

        if (servingEnergy != null && servingProtein != null && servingFat != null && servingCarbs != null) {
          // Calculate per 100g values from this serving anchor
          final double ratio = 100.0 / servingGrams;
          baseEnergyPer100g = servingEnergy * ratio;
          baseProteinPer100g = servingProtein * ratio;
          baseFatPer100g = servingFat * ratio;
          baseCarbsPer100g = servingCarbs * ratio;
          caloriesPerGram = servingEnergy / servingGrams;
        }
      }
    }

    // If we still don't have complete per 100g data, we can't proceed
    if (baseEnergyPer100g == null || baseProteinPer100g == null || baseFatPer100g == null || baseCarbsPer100g == null || caloriesPerGram == null) {
      return null;
    }

    // --- Step 2: Populate the units list using the established baseline and bridging ratio ---
    List<model_unit.FoodUnit> units = [];

    // Always add the 100g unit
    units.add(model_unit.FoodUnit(id: null, foodId: 0, name: '100g', grams: 100.0));

    // Add serving size unit if available and not already covered by 100g
    final servingSizeText = product.servingSize;
    // final servingQuantity = product.servingQuantity; // No longer strictly required for abstract units

    if (servingSizeText != null) { // Check only servingSizeText for now
      double? currentServingGrams;
      // Try to extract grams from servingSize (e.g., "30g")
      final RegExp gramRegex = RegExp(r'(\d+(\.\d+)?)\s*g');
      final gramMatch = gramRegex.firstMatch(servingSizeText);
      if (gramMatch != null) {
        currentServingGrams = double.tryParse(gramMatch.group(1)!);
      }

      // Try to extract ml from servingSize (e.g., "15ml") and use 1ml=1g heuristic
      if (currentServingGrams == null) {
        final RegExp mlRegex = RegExp(r'(\d+(\.\d+)?)\s*ml');
        final mlMatch = mlRegex.firstMatch(servingSizeText);
        if (mlMatch != null) {
          currentServingGrams = double.tryParse(mlMatch.group(1)!);
        }
      }

      // Fallback to product.servingQuantity if it seems like a gram value
      if (currentServingGrams == null && product.servingQuantity != null && product.servingQuantity! > 0 && product.servingQuantity! < 1000) {
        currentServingGrams = product.servingQuantity;
      }

      if (currentServingGrams != null && currentServingGrams > 0) {
        // If we have explicit grams for this serving, add it
        units.add(model_unit.FoodUnit(id: null, foodId: 0, name: servingSizeText, grams: currentServingGrams));
      } else {
        // This is an abstract unit, try to bridge its grams using caloriesPerGram
        final servingEnergy = nutriments.getValue(Nutrient.energyKCal, PerSize.serving);
                  if (servingEnergy != null && caloriesPerGram > 0) {
                    final bridgedGrams = servingEnergy / caloriesPerGram;
                    // Only add if it has calorie data for serving (as per latest clarification)
                    units.add(model_unit.FoodUnit(id: null, foodId: 0, name: servingSizeText, grams: bridgedGrams));
                  }      }
    }

    // Ensure units list is not empty
    if (units.isEmpty) {
      return null;
    }

    return model.Food(
      id: 0, // Not from our DB
      source: 'off',
      name: product.productName ?? product.genericName ?? 'Unknown Food',
      emoji: null, // Not available from OFF
      thumbnail: product.imageFrontUrl,
      calories: baseEnergyPer100g,
      protein: baseProteinPer100g,
      fat: baseFatPer100g,
      carbs: baseCarbsPer100g,
      units: units,
    );
  }
}
