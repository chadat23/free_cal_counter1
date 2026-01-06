import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/search_service.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/services/live_database.dart'
    hide FoodsCompanion;
import 'package:free_cal_counter1/services/reference_database.dart'
    hide FoodsCompanion;
import 'package:free_cal_counter1/services/live_database.dart' as live_db;
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:free_cal_counter1/services/food_sorting_service.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';

class FakeOffApiService extends OffApiService {
  @override
  Future<List<model.Food>> searchFoodsByName(String query) async => [];
  @override
  Future<model.Food?> fetchFoodByBarcode(String barcode) async => null;
}

void main() {
  late DatabaseService databaseService;
  late LiveDatabase liveDatabase;
  late ReferenceDatabase referenceDatabase;
  late FakeOffApiService mockOffApiService;
  late SearchService searchService;

  setUp(() {
    liveDatabase = LiveDatabase(connection: NativeDatabase.memory());
    referenceDatabase = ReferenceDatabase(connection: NativeDatabase.memory());
    databaseService = DatabaseService.forTesting(
      liveDatabase,
      referenceDatabase,
    );
    mockOffApiService = FakeOffApiService();
    searchService = SearchService(
      databaseService: databaseService,
      offApiService: mockOffApiService,
      emojiForFoodName: (name) => '🍎',
      sortingService: FoodSortingService(),
    );
  });

  tearDown(() async {
    await liveDatabase.close();
    await referenceDatabase.close();
  });

  test('searchLocal should not throw null check operator error', () async {
    // Arrange
    // Insert a food first
    await liveDatabase
        .into(liveDatabase.foods)
        .insert(
          live_db.FoodsCompanion.insert(
            id: const Value(1),
            name: 'Apple',
            source: 'user_created',
            caloriesPerGram: 0.52,
            proteinPerGram: 0.003,
            fatPerGram: 0.002,
            carbsPerGram: 0.14,
            fiberPerGram: 0.024,
          ),
        );

    // Insert a unit with NULL quantityPerPortion using raw SQL
    await liveDatabase.customStatement(
      'INSERT INTO food_portions (foodId, unitName, gramsPerPortion, quantityPerPortion) VALUES (?, ?, ?, ?)',
      [1, 'medium', 182.0, 1.0],
    );

    // Act
    final results = await searchService.searchLocal('Apple');

    // Assert
    expect(results.length, 1, reason: 'Should have found 1 result');
    expect(results.first.name, 'Apple');
    expect(results.first.servings, isNotEmpty);
    // The quantity should be defaulted to 1.0
    expect(results.first.servings.first.quantity, 1.0);
  });
}
