
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:free_cal_counter1/models/food.dart' as model;

import 'food_search_provider_test.mocks.dart';

@GenerateMocks([DatabaseService, OffApiService]) // Removed FoodSearchProvider from mocks
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
    test('should set errorMessage on error and clear search results', () async {
      // Arrange
      when(mockDatabaseService.searchFoodsByName(any)).thenThrow(Exception('Database error'));
      foodSearchProvider.toggleOffSearch(false); // Ensure OFF search is inactive

      // Act
      await foodSearchProvider.textSearch('error_query');

      // Assert
      expect(foodSearchProvider.errorMessage, contains('Database error'));
      expect(foodSearchProvider.searchResults, isEmpty);
      expect(foodSearchProvider.isLoading, isFalse);
    });

    test('should clear errorMessage before a new search', () async {
      // Arrange
      when(mockDatabaseService.searchFoodsByName(any)).thenThrow(Exception('Database error'));
      foodSearchProvider.toggleOffSearch(false); // Ensure OFF search is inactive
      await foodSearchProvider.textSearch('error_query'); // First search to set error

      when(mockDatabaseService.searchFoodsByName(any)).thenAnswer((_) async => []); // Stub for second search
      await foodSearchProvider.textSearch('valid_query'); // Second search

      // Assert
      expect(foodSearchProvider.errorMessage, isNull);
    });

    test('should set isLoading to true during search and false after completion', () async {
      // Arrange
      when(mockDatabaseService.searchFoodsByName(any)).thenAnswer((_) async {
        expect(foodSearchProvider.isLoading, isTrue); // Should be true during async call
        return [];
      });

      // Act
      final future = foodSearchProvider.textSearch('test');

      // Assert
      expect(foodSearchProvider.isLoading, isTrue); // Should be true immediately after call
      await future;
      expect(foodSearchProvider.isLoading, isFalse); // Should be false after completion
    });

    test('should return foods from database service when OFF search is inactive', () async {
      // Arrange
      final mockFoods = [
        model.Food(id: 1, name: 'Apple', emoji: '', calories: 52, protein: 0.3, fat: 0.2, carbs: 14, source: 'test'),
      ];
      when(mockDatabaseService.searchFoodsByName(any)).thenAnswer((_) async => mockFoods);
      // Use foodSearchProvider.isOffSearchActive directly
      foodSearchProvider.toggleOffSearch(false); // Ensure OFF search is inactive

      // Act
      await foodSearchProvider.textSearch('apple');

      // Assert
      expect(foodSearchProvider.searchResults, mockFoods);
      verify(mockDatabaseService.searchFoodsByName('apple')).called(1);
      verifyZeroInteractions(mockOffApiService);
    });

    test('should return foods from OffApiService when OFF search is active', () async {
      // Arrange
      final mockFoods = [
        model.Food(id: 0, name: 'OFF Apple', emoji: '', calories: 60, protein: 0.5, fat: 0.3, carbs: 15, source: 'off'),
      ];
      when(mockOffApiService.searchFoodsByName(any)).thenAnswer((_) async => mockFoods);
      // Use foodSearchProvider.isOffSearchActive directly
      foodSearchProvider.toggleOffSearch(true); // Activate OFF search

      // Act
      await foodSearchProvider.textSearch('apple');

      // Assert
      expect(foodSearchProvider.searchResults, mockFoods);
      verify(mockOffApiService.searchFoodsByName('apple')).called(1);
      verifyZeroInteractions(mockDatabaseService);
    });

    test('should handle no results from database service when OFF search is inactive', () async {
      // Arrange
      when(mockDatabaseService.searchFoodsByName(any)).thenAnswer((_) async => []);
      // Use foodSearchProvider.isOffSearchActive directly
      foodSearchProvider.toggleOffSearch(false); // Ensure OFF search is inactive

      // Act
      await foodSearchProvider.textSearch('nonexistent');

      // Assert
      expect(foodSearchProvider.searchResults, isEmpty);
      verify(mockDatabaseService.searchFoodsByName('nonexistent')).called(1);
      verifyZeroInteractions(mockOffApiService);
    });

    test('should handle no results from OffApiService when OFF search is active', () async {
      // Arrange
      when(mockOffApiService.searchFoodsByName(any)).thenAnswer((_) async => []);
      // Use foodSearchProvider.isOffSearchActive directly
      foodSearchProvider.toggleOffSearch(true); // Activate OFF search

      // Act
      await foodSearchProvider.textSearch('nonexistent');

      // Assert
      expect(foodSearchProvider.searchResults, isEmpty);
      verify(mockOffApiService.searchFoodsByName('nonexistent')).called(1);
      verifyZeroInteractions(mockDatabaseService);
    });
  });

  group('barcodeSearch', () {
    test('should set errorMessage on error and clear search results', () async {
      // Arrange
      when(mockDatabaseService.getFoodByBarcode(any)).thenThrow(Exception('Barcode error'));

      // Act
      await foodSearchProvider.barcodeSearch('error_barcode');

      // Assert
      expect(foodSearchProvider.errorMessage, contains('Barcode error'));
      expect(foodSearchProvider.searchResults, isEmpty);
      expect(foodSearchProvider.isLoading, isFalse);
    });

    test('should clear errorMessage before a new search', () async {
      // Arrange
      when(mockDatabaseService.getFoodByBarcode(any)).thenThrow(Exception('Barcode error'));
      await foodSearchProvider.barcodeSearch('error_barcode'); // First search to set error

      when(mockDatabaseService.getFoodByBarcode(any)).thenAnswer((_) async => null); // Stub for second search
      when(mockOffApiService.fetchFoodByBarcode(any)).thenAnswer((_) async => null); // Stub for second search
      await foodSearchProvider.barcodeSearch('valid_barcode'); // Second search

      // Assert
      expect(foodSearchProvider.errorMessage, isNull);
    });

    test('should set isLoading to true during search and false after completion', () async {
      // Arrange
      when(mockDatabaseService.getFoodByBarcode(any)).thenAnswer((_) async {
        expect(foodSearchProvider.isLoading, isTrue); // Should be true during async call
        return null;
      });
      when(mockOffApiService.fetchFoodByBarcode(any)).thenAnswer((_) async {
        expect(foodSearchProvider.isLoading, isTrue); // Should be true during async call
        return null;
      });

      // Act
      final future = foodSearchProvider.barcodeSearch('123');

      // Assert
      expect(foodSearchProvider.isLoading, isTrue); // Should be true immediately after call
      await future;
      expect(foodSearchProvider.isLoading, isFalse); // Should be false after completion
    });

    test('should return food from database service if found', () async {
      // Arrange
      final mockFood = model.Food(id: 1, name: 'Barcode Food', emoji: '', calories: 100, protein: 10, fat: 5, carbs: 15, source: 'test');
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
      final mockFood = model.Food(id: 0, name: 'OFF Food', emoji: '', calories: 200, protein: 20, fat: 10, carbs: 30, source: 'off');
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
    test('should set selected food and fetch units', () async {
      // Arrange
      final food = model.Food(id: 1, name: 'Apple', emoji: '', calories: 52, protein: 0.3, fat: 0.2, carbs: 14, source: 'test');
      when(mockDatabaseService.getUnitsForFood(food)).thenAnswer((_) async => []);

      // Act
      await foodSearchProvider.selectFood(food);

      // Assert
      expect(foodSearchProvider.selectedFood, food);
      expect(foodSearchProvider.units, []);
      verify(mockDatabaseService.getUnitsForFood(food)).called(1);
    });
  });

  group('toggleOffSearch', () {
    test('should update isOffSearchActive and notify listeners', () async {
      // Arrange
      var listenerCalled = false;
      foodSearchProvider.addListener(() {
        listenerCalled = true;
      });

      // Act
      foodSearchProvider.toggleOffSearch(true);

      // Assert
      expect(foodSearchProvider.isOffSearchActive, isTrue);
      expect(listenerCalled, isTrue);

      // Reset and test false
      listenerCalled = false;
      foodSearchProvider.toggleOffSearch(false);
      expect(foodSearchProvider.isOffSearchActive, isFalse);
      expect(listenerCalled, isTrue);
    });
  });
}
