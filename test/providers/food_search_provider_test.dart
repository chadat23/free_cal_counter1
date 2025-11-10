import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:free_cal_counter1/services/food_search_service.dart';
import 'package:free_cal_counter1/models/food.dart' as model;

import 'food_search_provider_test.mocks.dart';

@GenerateMocks([DatabaseService, OffApiService, FoodSearchService])
void main() {
  late FoodSearchProvider foodSearchProvider;
  late MockDatabaseService mockDatabaseService;
  late MockOffApiService mockOffApiService;
  late MockFoodSearchService mockFoodSearchService;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockOffApiService = MockOffApiService();
    mockFoodSearchService = MockFoodSearchService();
    foodSearchProvider = FoodSearchProvider(
      databaseService: mockDatabaseService,
      offApiService: mockOffApiService,
      foodSearchService: mockFoodSearchService,
    );
  });

  group('textSearch', () {
    test('should always call local search and update current query', () async {
      // Arrange
      final mockFoods = [
        model.Food(
          id: 1,
          name: 'Apple',
          emoji: '',
          calories: 52,
          protein: 0.3,
          fat: 0.2,
          carbs: 14,
          source: 'test',
        ),
      ];
      when(
        mockFoodSearchService.searchLocal('apple'),
      ).thenAnswer((_) async => mockFoods);

      // Act
      await foodSearchProvider.textSearch('apple');

      // Assert
      expect(foodSearchProvider.searchResults, mockFoods);
      verify(mockFoodSearchService.searchLocal('apple')).called(1);
      verifyNever(mockFoodSearchService.searchOff(any));
    });

    test('should set errorMessage on local search error', () async {
      // Arrange
      when(
        mockFoodSearchService.searchLocal(any),
      ).thenThrow(Exception('Local DB error'));

      // Act
      await foodSearchProvider.textSearch('error_query');

      // Assert
      expect(foodSearchProvider.errorMessage, contains('Local DB error'));
      expect(foodSearchProvider.searchResults, isEmpty);
    });
  });

  group('performOffSearch', () {
    test('should do nothing if current query is empty', () async {
      // Act
      await foodSearchProvider.performOffSearch();

      // Assert
      verifyZeroInteractions(mockFoodSearchService);
    });

    test(
      'should call OFF search with the current query from the last textSearch',
      () async {
        // Arrange
        const query = 'skippy';
        final mockOffFoods = [
          model.Food(
            id: 2,
            name: 'Skippy Peanut Butter',
            emoji: '',
            calories: 588,
            protein: 25,
            fat: 50,
            carbs: 20,
            source: 'off',
          ),
        ];
        // First, perform a text search to set the current query
        when(
          mockFoodSearchService.searchLocal(query),
        ).thenAnswer((_) async => []);
        await foodSearchProvider.textSearch(query);

        // Now, stub the OFF search
        when(
          mockFoodSearchService.searchOff(query),
        ).thenAnswer((_) async => mockOffFoods);

        // Act
        await foodSearchProvider.performOffSearch();

        // Assert
        expect(foodSearchProvider.searchResults, mockOffFoods);
        verify(mockFoodSearchService.searchOff(query)).called(1);
      },
    );

    test('should set errorMessage on OFF search error', () async {
      // Arrange
      const query = 'error_query';
      // Set the current query
      when(
        mockFoodSearchService.searchLocal(query),
      ).thenAnswer((_) async => []);
      await foodSearchProvider.textSearch(query);

      // Stub the OFF search to throw an error
      when(
        mockFoodSearchService.searchOff(query),
      ).thenThrow(Exception('OFF API error'));

      // Act
      await foodSearchProvider.performOffSearch();

      // Assert
      expect(foodSearchProvider.errorMessage, contains('OFF API error'));
      expect(foodSearchProvider.searchResults, isEmpty);
    });
  });

  // Barcode search and other groups remain unchanged as their logic was not affected.
  group('barcodeSearch', () {
    test('should query OffApiService if not found in database', () async {
      // Arrange
      final mockFood = model.Food(
        id: 0,
        name: 'OFF Food',
        emoji: '',
        calories: 200,
        protein: 20,
        fat: 10,
        carbs: 30,
        source: 'off',
      );
      when(
        mockDatabaseService.getFoodByBarcode(any),
      ).thenAnswer((_) async => null);
      when(
        mockOffApiService.fetchFoodByBarcode(any),
      ).thenAnswer((_) async => mockFood);

      // Act
      await foodSearchProvider.barcodeSearch('12345');

      // Assert
      expect(foodSearchProvider.searchResults, [mockFood]);
      verify(mockDatabaseService.getFoodByBarcode('12345')).called(1);
      verify(mockOffApiService.fetchFoodByBarcode('12345')).called(1);
    });
  });

  group('selectFood', () {
    test('should set selected food and fetch units', () async {
      // Arrange
      final food = model.Food(
        id: 1,
        name: 'Apple',
        emoji: '',
        calories: 52,
        protein: 0.3,
        fat: 0.2,
        carbs: 14,
        source: 'test',
      );
      when(
        mockDatabaseService.getUnitsForFood(food),
      ).thenAnswer((_) async => []);

      // Act
      await foodSearchProvider.selectFood(food);

      // Assert
      expect(foodSearchProvider.selectedFood, food);
      expect(foodSearchProvider.units, []);
      verify(mockDatabaseService.getUnitsForFood(food)).called(1);
    });
  });
}
