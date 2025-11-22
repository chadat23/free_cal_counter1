import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart' hide isNotNull;
import 'package:matcher/matcher.dart' as matcher;
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
                caloriesPerGram: 0.52,
                proteinPerGram: 0.003,
                fatPerGram: 0.002,
                carbsPerGram: 0.14,
                fiberPerGram: 0.024,
              ),
            );
        await referenceDatabase
            .into(referenceDatabase.foods)
            .insert(
              ref.FoodsCompanion.insert(
                name: 'Reference Apple',
                source: 'foundation',
                caloriesPerGram: 0.52,
                proteinPerGram: 0.003,
                fatPerGram: 0.002,
                carbsPerGram: 0.14,
                fiberPerGram: 0.024,
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

    test('should return Food objects with populated units list', () async {
      // Arrange
      // Insert a food with associated units into the reference database
      // For now, we'll simulate this by directly inserting into the reference database
      // and assume a food with ID 1 will be returned.
      // This part will need to be refined once the actual unit table is identified.
      await referenceDatabase
          .into(referenceDatabase.foods)
          .insert(
            ref.FoodsCompanion.insert(
              id: Value(1), // Assign an ID for linking units
              name: 'Reference Apple',
              source: 'foundation',
              caloriesPerGram: 0.52,
              proteinPerGram: 0.003,
              fatPerGram: 0.002,
              carbsPerGram: 0.14,
              fiberPerGram: 0.024,
            ),
          );
      // Assuming a units table exists and we can insert into it
      // This will cause a compile error until FoodUnit and the units table are properly integrated
      // and the Food model is updated.
      await referenceDatabase
          .into(referenceDatabase.foodPortions)
          .insert(
            ref.FoodPortionsCompanion.insert(
              foodId: 1,
              unit: '1 medium',
              grams: 182.0,
              quantity: 1.0,
            ),
          );
      await referenceDatabase
          .into(referenceDatabase.foodPortions)
          .insert(
            ref.FoodPortionsCompanion.insert(
              foodId: 1,
              unit: '1 cup sliced',
              grams: 109.0,
              quantity: 1.0,
            ),
          );

      // Act
      final results = await databaseService.searchFoodsByName('Apple');

      // Assert
      expect(results, isA<List<model.Food>>());
      expect(results.length, greaterThan(0));
      final appleFood = results.firstWhere((f) => f.name == 'Reference Apple');
      expect(appleFood.servings, matcher.isNotNull);
      expect(appleFood.servings.isNotEmpty, matcher.isTrue);
      expect(appleFood.servings.length, 3);
      expect(
        appleFood.servings.any(
          (unit) => unit.unit == '1 medium' && unit.grams == 182.0,
        ),
        matcher.isTrue,
      );
      // Verify 'g' unit is automatically added
      expect(
        appleFood.servings.any((unit) => unit.unit == 'g' && unit.grams == 1.0),
        matcher.isTrue,
      );
    });
  });
}
