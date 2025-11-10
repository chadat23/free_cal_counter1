import 'package:openfoodfacts/openfoodfacts.dart';

class OffApiClientWrapper {
  Future<ProductResultV3> getProductV3(
    ProductQueryConfiguration configuration,
  ) {
    return OpenFoodAPIClient.getProductV3(configuration);
  }

  Future<SearchResult> searchProducts(
    User? user,
    ProductSearchQueryConfiguration configuration,
  ) {
    return OpenFoodAPIClient.searchProducts(user, configuration);
  }
}
