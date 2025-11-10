import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/live_database.dart';
import 'package:free_cal_counter1/services/reference_database.dart' as ref;
import 'package:drift/native.dart';
import 'package:free_cal_counter1/models/food.dart' as model;

void main() {
  late DatabaseService databaseService;
  late LiveDatabase liveDatabase;
  late ref.ReferenceDatabase referenceDatabase;

  setUp(() {
    liveDatabase = LiveDatabase(connection: NativeDatabase.memory());
    referenceDatabase = ref.ReferenceDatabase(
      connection: NativeDatabase.memory(),
    );
    databaseService = DatabaseService.forTesting(
      liveDatabase,
      referenceDatabase,
    );
  });

  tearDown(() async {
    await liveDatabase.close();
    await referenceDatabase.close();
  });

  group('searchFoodsByName', () {
    test(
      'should return combined results from both live and reference databases',
      () async {
        // Arrange
        await liveDatabase
            .into(liveDatabase.foods)
            .insert(
              FoodsCompanion.insert(
                name: 'Live Apple',
                source: 'user_created',
                caloriesPer100g: 52,
                proteinPer100g: 0.3,
                fatPer100g: 0.2,
                carbsPer100g: 14,
                fiberPer100g: 2.4,
              ),
            );
        await referenceDatabase
            .into(referenceDatabase.foods)
            .insert(
              ref.FoodsCompanion.insert(
                name: 'Reference Apple',
                source: 'foundation',
                caloriesPer100g: 52,
                proteinPer100g: 0.3,
                fatPer100g: 0.2,
                carbsPer100g: 14,
                fiberPer100g: 2.4,
              ),
            );

        // Act
        final results = await databaseService.searchFoodsByName('Apple');

        // Assert
        expect(results, isA<List<model.Food>>());
        expect(results.length, 2);
        expect(results.any((f) => f.name == 'Live Apple'), isTrue);
        expect(results.any((f) => f.name == 'Reference Apple'), isTrue);
      },
    );

    test('should return empty list if no food is found', () async {
      // Act
      final results = await databaseService.searchFoodsByName(
        'NonExistentFood',
      );

      // Assert
      expect(results.isEmpty, isTrue);
    });

    test('should handle empty databases gracefully', () async {
      // Act
      final results = await databaseService.searchFoodsByName('Apple');

      // Assert
      expect(results.isEmpty, isTrue);
    });
  });
}
