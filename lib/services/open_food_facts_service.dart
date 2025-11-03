
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
      name: product.productName ?? 'Unknown Food',
      emoji: '', // Not available from OFF
      calories: energy,
      protein: proteins,
      fat: fat,
      carbs: carbs,
    );
  }
}
