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

class MockSearchResult extends Mock implements SearchResult {}

@GenerateMocks([OffApiClientWrapper])
void main() {
  late OffApiService offApiService;
  late MockOffApiClientWrapper mockApiWrapper;

  setUp(() {
    mockApiWrapper = MockOffApiClientWrapper();
    offApiService = OffApiService(apiWrapper: mockApiWrapper);
  });

  group('fetchFoodByBarcode', () {
    // ... existing tests ...
  });

  group('searchFoodsByName', () {
    test(
      'should return a list of Food objects for a valid search query',
      () async {
        // Arrange
        final product = MockProduct();
        final nutriments = MockNutriments();
        final searchResult = MockSearchResult();

        when(
          product.productName,
        ).thenReturn('Skippy Extra Crunchy Peanut Butter');
        when(
          nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams),
        ).thenReturn(1910); // Updated from new JSON
        when(
          nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams),
        ).thenReturn(68.4); // Updated from new JSON
        when(
          nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams),
        ).thenReturn(156); // Updated from new JSON
        when(
          nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams),
        ).thenReturn(58.6); // Updated from new JSON
        when(product.nutriments).thenReturn(nutriments);
        when(searchResult.products).thenReturn([product]);

        when(
          mockApiWrapper.searchProducts(
            any, // for User? user
            any, // for ProductSearchQueryConfiguration configuration
          ),
        ).thenAnswer((_) async => searchResult);

        // Act
        final result = await offApiService.searchFoodsByName('peanut butter');

        // Assert
        expect(result, isA<List<model.Food>>());
        expect(result, hasLength(1));
        expect(result.first.name, 'Skippy Extra Crunchy Peanut Butter');
        expect(result.first.calories, 1910);
        expect(result.first.protein, 68.4);
        expect(result.first.carbs, 58.6);
      },
    );

    test('should return an empty list when no products are found', () async {
      // Arrange
      final searchResult = MockSearchResult();
      when(searchResult.products).thenReturn([]);

      // Use concrete mock objects in when clause
      when(
        mockApiWrapper.searchProducts(
          any, // for User? user
          any, // for ProductSearchQueryConfiguration configuration
        ),
      ).thenAnswer((_) async => searchResult);

      // Act
      final result = await offApiService.searchFoodsByName('nonexistent food');

      // Assert
      expect(result, isEmpty);
    });
  });
}
