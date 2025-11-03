
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/services/off_api_client_wrapper.dart';

import 'off_api_service_test.mocks.dart';

class MockProduct extends Mock implements Product {}
class MockNutriments extends Mock implements Nutriments {}
class MockProductResultV3 extends Mock implements ProductResultV3 {}

@GenerateMocks([OffApiClientWrapper])
void main() {
  late OffApiService offApiService;
  late MockOffApiClientWrapper mockApiWrapper;

  setUp(() {
    mockApiWrapper = MockOffApiClientWrapper();
    offApiService = OffApiService(apiWrapper: mockApiWrapper);
  });

  group('fetchFoodByBarcode', () {
    test('should return a Food object for a valid barcode with complete data', () async {
      // Arrange
      final product = MockProduct();
      final nutriments = MockNutriments();
      final productResult = MockProductResultV3();

      when(product.productName).thenReturn('Test Food');
      when(product.barcode).thenReturn('123456789');
      when(nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams)).thenReturn(200);
      when(nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams)).thenReturn(10);
      when(nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams)).thenReturn(5);
      when(nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams)).thenReturn(25);
      when(product.nutriments).thenReturn(nutriments);
      when(productResult.product).thenReturn(product);
      when(productResult.status).thenReturn(ProductResultV3.statusSuccess);

      when(mockApiWrapper.getProductV3(any)).thenAnswer((_) async => productResult);

      // Act
      final result = await offApiService.fetchFoodByBarcode('123456789');

      // Assert
      expect(result, isA<model.Food?>());
      expect(result!.name, 'Test Food');
      expect(result.calories, 200);
    });

    test('should return null for a product with incomplete data', () async {
      // Arrange
      final product = MockProduct();
      final nutriments = MockNutriments();
      final productResult = MockProductResultV3();

      when(product.productName).thenReturn('Incomplete Food');
      when(product.barcode).thenReturn('987654321');
      when(nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams)).thenReturn(null); // Missing calories
      when(nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams)).thenReturn(10);
      when(nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams)).thenReturn(5);
      when(product.nutriments).thenReturn(nutriments);
      when(productResult.product).thenReturn(product);
      when(productResult.status).thenReturn(ProductResultV3.statusSuccess);

      when(mockApiWrapper.getProductV3(any)).thenAnswer((_) async => productResult);

      // Act
      final result = await offApiService.fetchFoodByBarcode('987654321');

      // Assert
      expect(result, isNull);
    });

    test('should return null when product is not found', () async {
      // Arrange
      final productResult = MockProductResultV3();
      when(productResult.status).thenReturn('product not found'); // Status for not found
      when(productResult.product).thenReturn(null);

      when(mockApiWrapper.getProductV3(any)).thenAnswer((_) async => productResult);

      // Act
      final result = await offApiService.fetchFoodByBarcode('000000000');

      // Assert
      expect(result, isNull);
    });
  });
}
