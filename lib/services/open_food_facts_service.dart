
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/services/off_api_client_wrapper.dart';

class OffApiService {
  final OffApiClientWrapper _apiWrapper;

  OffApiService({OffApiClientWrapper? apiWrapper}) : _apiWrapper = apiWrapper ?? OffApiClientWrapper();

  Future<model.Food?> fetchFoodByBarcode(String barcode) async {
    final productResult = await _apiWrapper.getProductV3(
      ProductQueryConfiguration(
        barcode, 
        version: ProductQueryVersion.v3
      )
    );

    if (productResult.status != ProductResultV3.statusSuccess || productResult.product == null) {
      return null;
    }

    final product = productResult.product!;
    final nutriments = product.nutriments;

    if (nutriments == null) {
      return null;
    }

    final energy = nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams);
    final proteins = nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams);
    final fat = nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams);
    final carbs = nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams);

    if (energy == null || proteins == null || fat == null || carbs == null) {
      return null;
    }

    return model.Food(
      id: 0, // Not from our DB
      source: 'off',
      name: product.productName ?? 'Unknown Food',
      emoji: null, // Not available from OFF
      thumbnail: product.imageFrontUrl,
      calories: energy,
      protein: proteins,
      fat: fat,
      carbs: carbs,
    );
  }

  Future<List<model.Food>> searchFoodsByName(String query) async {
    final ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
      parametersList: <Parameter>[ // Reverted to parametersList
        SearchTerms(terms: [query]),
        PageSize(size: 20),
      ],
      language: OpenFoodFactsLanguage.ENGLISH,
      // country: OpenFoodFactsCountry.UNITED_STATES, // Temporarily removed due to compilation issues
      fields: [
        ProductField.NAME,
        ProductField.BARCODE,
        ProductField.IMAGE_FRONT_URL,
        ProductField.NUTRIMENTS,
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
                  final nutriments = product.nutriments;
          
                  if (nutriments == null) {
                    continue; // Skip products without nutrition data
                  }
          
                  final energy = nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams);
                  final proteins = nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams);
                  final fat = nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams);
                  final carbs = nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams);
          
                  if (energy == null || proteins == null || fat == null || carbs == null) {
                    continue; // Skip products with incomplete nutrition data
                  }      foods.add(
        model.Food(
          id: 0, // Not from our DB
          source: 'off',
          name: product.productName ?? product.genericName ?? 'Unknown Food',
          emoji: null, // Not available from OFF
          thumbnail: product.imageFrontUrl,
          calories: energy,
          protein: proteins,
          fat: fat,
          carbs: carbs,
        ),
      );
    }

    return foods;
  }
}
