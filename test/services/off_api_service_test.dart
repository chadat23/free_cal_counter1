import 'package:flutter_test/flutter_test.dart' hide isNotNull;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/services/off_api_client_wrapper.dart';
import 'package:matcher/matcher.dart' as matcher;

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

    test(
      'should filter out food items with no reliable anchor units',
      () async {
        // Arrange
        final product = MockProduct();
        final nutriments = MockNutriments();
        final searchResult = MockSearchResult();

        // Mock a product with no per 100g data
        when(product.productName).thenReturn('Unanchored Food');
        when(nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams))
            .thenReturn(null);
        when(nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams))
            .thenReturn(null);
        when(nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams))
            .thenReturn(null);
        when(
                nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams))
            .thenReturn(null);
        when(product.nutriments).thenReturn(nutriments);

        // Mock serving sizes that don't provide a gram weight
        when(product.servingSize).thenReturn('1 piece'); // No explicit grams
        when(product.servingQuantity).thenReturn(null); // No quantity to infer grams

        when(searchResult.products).thenReturn([product]);

        when(
          mockApiWrapper.searchProducts(
            any, // for User? user
            any, // for ProductSearchQueryConfiguration configuration
          ),
        ).thenAnswer((_) async => searchResult);

        // Act
        final result = await offApiService.searchFoodsByName('unanchored food');

        // Assert
        expect(result, isEmpty); // Expect the food to be filtered out
      },
    );

    test(
      'should use serving size with volume as anchor and generate baseline',
      () async {
        // Arrange
        final product = MockProduct();
        final nutriments = MockNutriments();
        final searchResult = MockSearchResult();

        // Mock a product with NO per 100g data
        when(product.productName).thenReturn('Soy Sauce (Volume)');
        when(nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams))
            .thenReturn(null);
        when(nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams))
            .thenReturn(null);
        when(nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams))
            .thenReturn(null);
        when(
                nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams))
            .thenReturn(null);

        // Mock serving size with volume (1ml = 1g heuristic)
        when(product.servingSize).thenReturn('1 tbsp (15ml)');
        when(product.servingQuantity).thenReturn(15.0); // Volume in ml

        // Nutritional data PER SERVING (15ml ~ 15g)
        when(nutriments.getValue(Nutrient.energyKCal, PerSize.serving))
            .thenReturn(15.0); // 15 kcal per 15ml serving
        when(nutriments.getValue(Nutrient.proteins, PerSize.serving))
            .thenReturn(1.0); // 1g protein per 15ml serving
        when(nutriments.getValue(Nutrient.fat, PerSize.serving))
            .thenReturn(0.0); // 0g fat per 15ml serving
        when(nutriments.getValue(Nutrient.carbohydrates, PerSize.serving))
            .thenReturn(2.0); // 2g carbs per 15ml serving

        when(product.nutriments).thenReturn(nutriments);
        when(searchResult.products).thenReturn([product]);

        when(
          mockApiWrapper.searchProducts(
            any, // for User? user
            any, // for ProductSearchQueryConfiguration configuration
          ),
        ).thenAnswer((_) async => searchResult);

        // Act
        final result = await offApiService.searchFoodsByName('soy sauce');

        // Assert
        expect(result, isA<List<model.Food>>());
        expect(result, hasLength(1));
        final food = result.first;

        // Verify calculated per 100g values (based on 15ml ~ 15g)
        // 15 kcal / 15g = 1 kcal/g => 100 kcal/100g
        expect(food.calories, closeTo(100.0, 0.01));
        // 1g protein / 15g = 0.0666 g/g => 6.67 g/100g
        expect(food.protein, closeTo(6.67, 0.01));
        // 0g fat / 15g = 0 g/g => 0 g/100g
        expect(food.fat, closeTo(0.0, 0.01));
        // 2g carbs / 15g = 0.1333 g/g => 13.33 g/100g
        expect(food.carbs, closeTo(13.33, 0.01));

        // Verify units list
        expect(food.units, matcher.isNotNull);
        expect(food.units.isNotEmpty, matcher.isTrue);
        expect(food.units.length, greaterThanOrEqualTo(1)); // At least the serving unit
        expect(food.units.any((unit) => unit.name == '1 tbsp (15ml)' && unit.grams == 15.0), matcher.isTrue);
        // Also expect a 100g unit to be generated
        expect(food.units.any((unit) => unit.name == '100g' && unit.grams == 100.0), matcher.isTrue);
      },
    );
  });
}
