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

    double? energyPer100g = nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams);
    double? proteinPer100g = nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams);
    double? fatPer100g = nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams);
    double? carbsPer100g = nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams);

    List<model_unit.FoodUnit> units = [];
    double? anchorGrams;
    double? anchorEnergy;

    // Try to get per 100g as the primary anchor
    if (energyPer100g != null && proteinPer100g != null && fatPer100g != null && carbsPer100g != null) {
      anchorGrams = 100.0;
      anchorEnergy = energyPer100g;
      units.add(model_unit.FoodUnit(id: 0, foodId: 0, name: '100g', grams: 100.0));
    }

    // If no 100g anchor, try serving size with explicit grams or volume
    if (anchorGrams == null && product.servingSize != null && product.servingQuantity != null) {
      final servingSizeText = product.servingSize!;
      final servingQuantity = product.servingQuantity!;

      // Check for explicit grams in servingSize (e.g., "30g")
      final RegExp gramRegex = RegExp(r'(\d+(\.\d+)?)\s*g');
      final gramMatch = gramRegex.firstMatch(servingSizeText);

      // Check for volume in servingSize (e.g., "15ml")
      final RegExp mlRegex = RegExp(r'(\d+(\.\d+)?)\s*ml');
      final mlMatch = mlRegex.firstMatch(servingSizeText);

      if (gramMatch != null) {
        anchorGrams = double.tryParse(gramMatch.group(1)!);
      } else if (mlMatch != null) {
        // Heuristic: 1ml = 1g
        anchorGrams = double.tryParse(mlMatch.group(1)!);
      } else {
        // Fallback to servingQuantity if it seems like a gram value
        // This is a bit of a guess, but often servingQuantity is in grams if no unit is specified
        if (servingQuantity > 0 && servingQuantity < 1000) { // Heuristic to avoid very large or zero quantities
          anchorGrams = servingQuantity;
        }
      }

      if (anchorGrams != null && anchorGrams > 0) {
        final servingEnergy = nutriments.getValue(Nutrient.energyKCal, PerSize.serving);
        final servingProtein = nutriments.getValue(Nutrient.proteins, PerSize.serving);
        final servingFat = nutriments.getValue(Nutrient.fat, PerSize.serving);
        final servingCarbs = nutriments.getValue(Nutrient.carbohydrates, PerSize.serving);

        if (servingEnergy != null && servingProtein != null && servingFat != null && servingCarbs != null) {
          anchorEnergy = servingEnergy;
          // Calculate per 100g values from this anchor
          final double ratio = 100.0 / anchorGrams;
          energyPer100g = servingEnergy * ratio;
          proteinPer100g = servingProtein * ratio;
          fatPer100g = servingFat * ratio;
          carbsPer100g = servingCarbs * ratio;

          units.add(model_unit.FoodUnit(id: 0, foodId: 0, name: servingSizeText, grams: anchorGrams));
          // Add 100g unit if not already added
          if (!units.any((u) => u.name == '100g')) {
            units.add(model_unit.FoodUnit(id: 0, foodId: 0, name: '100g', grams: 100.0));
          }
        }
      }
    }

    // If we still don't have complete per 100g data, or no anchor was found, return null
    if (energyPer100g == null || proteinPer100g == null || fatPer100g == null || carbsPer100g == null || units.isEmpty) {
      return null;
    }

    return model.Food(
      id: 0, // Not from our DB
      source: 'off',
      name: product.productName ?? product.genericName ?? 'Unknown Food',
      emoji: null, // Not available from OFF
      thumbnail: product.imageFrontUrl,
      calories: energyPer100g,
      protein: proteinPer100g,
      fat: fatPer100g,
      carbs: carbsPer100g,
      units: units,
    );
  }
}
