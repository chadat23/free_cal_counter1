import 'package:free_cal_counter1/services/emoji_service.dart';
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

    // --- Step 1: Determine the best anchor and calculate baseline per gram values ---
    double? baseEnergyPerGram;
    double? baseProteinPerGram;
    double? baseFatPerGram;
    double? baseCarbsPerGram;

    // Option A: Direct per 100g data (highest priority anchor)
    final energy100g = nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams);
    final protein100g = nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams);
    final fat100g = nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams);
    final carbs100g = nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams);

    if (energy100g != null && protein100g != null && fat100g != null && carbs100g != null) {
      baseEnergyPerGram = energy100g / 100.0;
      baseProteinPerGram = protein100g / 100.0;
      baseFatPerGram = fat100g / 100.0;
      baseCarbsPerGram = carbs100g / 100.0;
    } else {
      // Option B: Serving size with explicit grams or volume (secondary anchor)
      double? servingGrams;
      final servingSizeText = product.servingSize;
      final servingQuantity = product.servingQuantity;

      if (servingSizeText != null && servingQuantity != null) {
        final RegExp gramRegex = RegExp(r'(\d+(\.\d+)?)\s*g');
        final gramMatch = gramRegex.firstMatch(servingSizeText);
        if (gramMatch != null) {
          servingGrams = double.tryParse(gramMatch.group(1)!);
        }

        if (servingGrams == null) {
          final RegExp mlRegex = RegExp(r'(\d+(\.\d+)?)\s*ml');
          final mlMatch = mlRegex.firstMatch(servingSizeText);
          if (mlMatch != null) {
            servingGrams = double.tryParse(mlMatch.group(1)!);
          }
        }

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
          // Calculate per gram values from this serving anchor
          final double ratio = 1.0 / servingGrams;
          baseEnergyPerGram = servingEnergy * ratio;
          baseProteinPerGram = servingProtein * ratio;
          baseFatPerGram = servingFat * ratio;
          baseCarbsPerGram = servingCarbs * ratio;
        }
      }
    }

    // If we still don't have complete per gram data, we can't proceed
    if (baseEnergyPerGram == null || baseProteinPerGram == null || baseFatPerGram == null || baseCarbsPerGram == null) {
      return null;
    }

    // --- Step 2: Populate the units list ---
    List<model_unit.FoodUnit> units = [];
    final caloriesPerGram = baseEnergyPerGram; // Bridging ratio

    // Always add the 'g' unit now that our base is per-gram
    units.add(model_unit.FoodUnit(id: null, foodId: 0, name: 'g', grams: 1.0));

    // Add serving size unit if available
    final servingSizeText = product.servingSize;
    if (servingSizeText != null) {
      double? currentServingGrams;
      final RegExp gramRegex = RegExp(r'(\d+(\.\d+)?)\s*g');
      final gramMatch = gramRegex.firstMatch(servingSizeText);
      if (gramMatch != null) {
        currentServingGrams = double.tryParse(gramMatch.group(1)!);
      }

      if (currentServingGrams == null) {
        final RegExp mlRegex = RegExp(r'(\d+(\.\d+)?)\s*ml');
        final mlMatch = mlRegex.firstMatch(servingSizeText);
        if (mlMatch != null) {
          currentServingGrams = double.tryParse(mlMatch.group(1)!);
        }
      }

      if (currentServingGrams == null && product.servingQuantity != null && product.servingQuantity! > 0 && product.servingQuantity! < 1000) {
        currentServingGrams = product.servingQuantity;
      }

      if (currentServingGrams != null && currentServingGrams > 0) {
        // If we have explicit grams for this serving, add it, but only if it's not 'g' or '1g'
        if (servingSizeText.toLowerCase() != 'g' && servingSizeText.toLowerCase() != '1g') {
            units.add(model_unit.FoodUnit(id: null, foodId: 0, name: servingSizeText, grams: currentServingGrams));
        }
      } else {
        // This is an abstract unit, try to bridge its grams using caloriesPerGram
        final servingEnergy = nutriments.getValue(Nutrient.energyKCal, PerSize.serving);
        if (servingEnergy != null && caloriesPerGram > 0) {
          final bridgedGrams = servingEnergy / caloriesPerGram;
          units.add(model_unit.FoodUnit(id: null, foodId: 0, name: servingSizeText, grams: bridgedGrams));
        }
      }
    }

    // Ensure units list is not empty
    if (units.isEmpty) {
      // This should be rare now that we always add 'g'
      return null;
    }

    final foodName = product.productName ?? product.genericName ?? 'Unknown Food';
    final emoji = emojiForFoodName(foodName);

    return model.Food(
      id: 0, // Not from our DB
      source: 'off',
      name: foodName,
      emoji: emoji,
      thumbnail: product.imageFrontUrl,
      calories: baseEnergyPerGram,
      protein: baseProteinPerGram,
      fat: baseFatPerGram,
      carbs: baseCarbsPerGram,
      units: units,
    );
  }
}

