
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:free_cal_counter1/models/food.dart' as model;

import 'food_search_provider_test.mocks.dart';

@GenerateMocks([DatabaseService, OffApiService])
void main() {
  late FoodSearchProvider foodSearchProvider;
  late MockDatabaseService mockDatabaseService;
  late MockOffApiService mockOffApiService;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockOffApiService = MockOffApiService();
    foodSearchProvider = FoodSearchProvider(
      databaseService: mockDatabaseService,
      offApiService: mockOffApiService,
    );
  });

  group('textSearch', () {
    test('should return foods from database service', () async {
      // Arrange
      final mockFoods = [
        model.Food(id: 1, name: 'Apple', emoji: '', calories: 52, protein: 0.3, fat: 0.2, carbs: 14),
      ];
      when(mockDatabaseService.searchFoodsByName(any)).thenAnswer((_) async => mockFoods);

      // Act
      await foodSearchProvider.textSearch('apple');

      // Assert
      expect(foodSearchProvider.searchResults, mockFoods);
      verify(mockDatabaseService.searchFoodsByName('apple')).called(1);
      verifyZeroInteractions(mockOffApiService);
    });

    test('should handle no results from database service', () async {
      // Arrange
      when(mockDatabaseService.searchFoodsByName(any)).thenAnswer((_) async => []);

      // Act
      await foodSearchProvider.textSearch('nonexistent');

      // Assert
      expect(foodSearchProvider.searchResults, isEmpty);
      verify(mockDatabaseService.searchFoodsByName('nonexistent')).called(1);
      verifyZeroInteractions(mockOffApiService);
    });
  });

  group('barcodeSearch', () {
    test('should return food from database service if found', () async {
      // Arrange
      final mockFood = model.Food(id: 1, name: 'Barcode Food', emoji: '', calories: 100, protein: 10, fat: 5, carbs: 15);
      when(mockDatabaseService.getFoodByBarcode(any)).thenAnswer((_) async => mockFood);

      // Act
      await foodSearchProvider.barcodeSearch('12345');

      // Assert
      expect(foodSearchProvider.searchResults, [mockFood]);
      verify(mockDatabaseService.getFoodByBarcode('12345')).called(1);
      verifyZeroInteractions(mockOffApiService);
    });

    test('should query OffApiService if not found in database', () async {
      // Arrange
      final mockFood = model.Food(id: 0, name: 'OFF Food', emoji: '', calories: 200, protein: 20, fat: 10, carbs: 30);
      when(mockDatabaseService.getFoodByBarcode(any)).thenAnswer((_) async => null);
      when(mockOffApiService.fetchFoodByBarcode(any)).thenAnswer((_) async => mockFood);

      // Act
      await foodSearchProvider.barcodeSearch('12345');

      // Assert
      expect(foodSearchProvider.searchResults, [mockFood]);
      verify(mockDatabaseService.getFoodByBarcode('12345')).called(1);
      verify(mockOffApiService.fetchFoodByBarcode('12345')).called(1);
    });

    test('should return empty if not found in OffApiService either', () async {
      // Arrange
      when(mockDatabaseService.getFoodByBarcode(any)).thenAnswer((_) async => null);
      when(mockOffApiService.fetchFoodByBarcode(any)).thenAnswer((_) async => null);

      // Act
      await foodSearchProvider.barcodeSearch('12345');

      // Assert
      expect(foodSearchProvider.searchResults, isEmpty);
      verify(mockDatabaseService.getFoodByBarcode('12345')).called(1);
      verify(mockOffApiService.fetchFoodByBarcode('12345')).called(1);
    });
  });

  group('selectFood', () {
    test('should save food to live DB if from OFF and not already present', () async {
      // Arrange
      final offFood = model.Food(id: 0, name: 'OFF Food', emoji: '', calories: 200, protein: 20, fat: 10, carbs: 30);
      final savedFood = model.Food(id: 1, name: 'OFF Food', emoji: '', calories: 200, protein: 20, fat: 10, carbs: 30);

      when(mockDatabaseService.saveFood(any)).thenAnswer((_) async => savedFood);

      // Act
      final result = await foodSearchProvider.selectFood(offFood);

      // Assert
      expect(result, savedFood);
      verify(mockDatabaseService.saveFood(offFood)).called(1);
      verifyNever(mockDatabaseService.getFoodBySourceFdcId(any));
    });

    test('should return existing food if from reference DB and already copied', () async {
      // Arrange
      final refFood = model.Food(id: 100, name: 'Ref Food', emoji: '', calories: 150, protein: 15, fat: 8, carbs: 20);
      final existingLiveFood = model.Food(id: 1, name: 'Ref Food', emoji: '', calories: 150, protein: 15, fat: 8, carbs: 20);

      when(mockDatabaseService.getFoodBySourceFdcId(any)).thenAnswer((_) async => existingLiveFood);

      // Act
      final result = await foodSearchProvider.selectFood(refFood);

      // Assert
      expect(result, existingLiveFood);
      verify(mockDatabaseService.getFoodBySourceFdcId(refFood.id)).called(1);
      verifyNever(mockDatabaseService.saveFood(any));
    });

    test('should copy food from reference DB to live DB if not already copied', () async {
      // Arrange
      final refFood = model.Food(id: 100, name: 'Ref Food', emoji: '', calories: 150, protein: 15, fat: 8, carbs: 20);
      final copiedFood = model.Food(id: 1, name: 'Ref Food', emoji: '', calories: 150, protein: 15, fat: 8, carbs: 20);

      when(mockDatabaseService.getFoodBySourceFdcId(any)).thenAnswer((_) async => null);
      when(mockDatabaseService.saveFood(any)).thenAnswer((_) async => copiedFood);

      // Act
      final result = await foodSearchProvider.selectFood(refFood);

      // Assert
      expect(result, copiedFood);
      verify(mockDatabaseService.getFoodBySourceFdcId(refFood.id)).called(1);
      verify(mockDatabaseService.saveFood(argThat(
        isA<model.Food>()
            .having((f) => f.name, 'name', refFood.name)
            .having((f) => f.id, 'id', 0), // Should be saved as a new food
      ))).called(1);
    });
  });
}
