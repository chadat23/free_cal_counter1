import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart' hide isNotNull;
import 'package:matcher/matcher.dart' as matcher;
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/live_database.dart';
import 'package:free_cal_counter1/services/reference_database.dart' as ref;
import 'package:drift/native.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/models/food_serving.dart' as model_serving;
import 'package:free_cal_counter1/models/food_portion.dart' as model_portion;
import 'package:free_cal_counter1/models/logged_portion.dart' as model_logged;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
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
      // 'g' is auto-added, plus 2 inserted = 3
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

  group('getLastLoggedUnit', () {
    test('should return null if no logs exist for the food', () async {
      final unit = await databaseService.getLastLoggedUnit(1);
      expect(unit, matcher.isNull);
    });

    test('should return the unit from the most recent log', () async {
      // Arrange
      // Insert a food first to satisfy foreign key constraint
      const foodId = 1;
      await liveDatabase
          .into(liveDatabase.foods)
          .insert(
            FoodsCompanion.insert(
              id: const Value(foodId),
              name: 'Test Food',
              source: 'user_created',
              caloriesPerGram: 1.0,
              proteinPerGram: 0.0,
              fatPerGram: 0.0,
              carbsPerGram: 0.0,
              fiberPerGram: 0.0,
            ),
          );

      // Insert logs with different timestamps linking to this food
      await liveDatabase
          .into(liveDatabase.loggedPortions)
          .insert(
            LoggedPortionsCompanion.insert(
              foodId: const Value(foodId),
              logTimestamp: 1000,
              grams: 100,
              unit: 'old_unit',
              quantity: 100,
            ),
          );
      await liveDatabase
          .into(liveDatabase.loggedPortions)
          .insert(
            LoggedPortionsCompanion.insert(
              foodId: const Value(foodId),
              logTimestamp: 2000,
              grams: 100,
              unit: 'new_unit',
              quantity: 100,
            ),
          );

      // Act
      final unit = await databaseService.getLastLoggedUnit(foodId);

      // Assert
      expect(unit, 'new_unit');
    });
  });

  group('getLoggedMacrosForDateRange', () {
    test('should return macro DTOs for logs within range', () async {
      // Arrange
      const foodId = 1;
      await liveDatabase
          .into(liveDatabase.foods)
          .insert(
            FoodsCompanion.insert(
              id: const Value(foodId),
              name: 'Test Food',
              source: 'user_created',
              caloriesPerGram: 1.0,
              proteinPerGram: 0.5,
              fatPerGram: 0.2,
              carbsPerGram: 0.3,
              fiberPerGram: 0.1,
            ),
          );

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);

      // Log for today
      await liveDatabase
          .into(liveDatabase.loggedPortions)
          .insert(
            LoggedPortionsCompanion.insert(
              foodId: const Value(foodId),
              logTimestamp: todayStart
                  .add(const Duration(hours: 12))
                  .millisecondsSinceEpoch,
              grams: 100,
              unit: 'g',
              quantity: 100,
            ),
          );

      // Log for yesterday
      await liveDatabase
          .into(liveDatabase.loggedPortions)
          .insert(
            LoggedPortionsCompanion.insert(
              foodId: const Value(foodId),
              logTimestamp: todayStart
                  .subtract(const Duration(hours: 12))
                  .millisecondsSinceEpoch,
              grams: 50,
              unit: 'g',
              quantity: 50,
            ),
          );

      // Log for tomorrow (out of range if we query today only)
      await liveDatabase
          .into(liveDatabase.loggedPortions)
          .insert(
            LoggedPortionsCompanion.insert(
              foodId: const Value(foodId),
              logTimestamp: todayStart
                  .add(const Duration(days: 1, hours: 12))
                  .millisecondsSinceEpoch,
              grams: 200,
              unit: 'g',
              quantity: 200,
            ),
          );

      // Act
      // Query for Today and Yesterday
      final results = await databaseService.getLoggedMacrosForDateRange(
        todayStart.subtract(const Duration(days: 1)),
        todayStart,
      );

      // Assert
      expect(results.length, 2);

      // Verify data integrity
      final todayLog = results.firstWhere((r) => r.grams == 100);
      expect(todayLog.caloriesPerGram, 1.0);

      final yesterdayLog = results.firstWhere((r) => r.grams == 50);
      expect(yesterdayLog.caloriesPerGram, 1.0);
    });
  });

  group('Smart Versioning', () {
    test('macro-neutral changes should update in-place', () async {
      // Arrange
      const foodId = 1;
      final food = model.Food(
        id: foodId,
        source: 'live',
        name: 'Apple',
        calories: 0.52,
        protein: 0.003,
        fat: 0.002,
        carbs: 0.14,
        fiber: 0.024,
      );
      final savedId = await databaseService.saveFood(food);
      final savedFood = food.copyWith(id: savedId);

      // Act: Update name and emoji (macro-neutral)
      final updatedFood = savedFood.copyWith(name: 'Red Apple', emoji: '🍎');
      final resultId = await databaseService.saveFood(updatedFood);

      // Assert
      expect(resultId, savedId); // Should be same ID
      final saved = await databaseService.getFoodById(savedId, 'live');
      expect(saved?.name, 'Red Apple');
      expect(saved?.emoji, '🍎');
    });

    test(
      'nutritional changes should update in-place if NOT referenced',
      () async {
        // Arrange
        const foodId = 1;
        final food = model.Food(
          id: foodId,
          source: 'live',
          name: 'Apple',
          calories: 0.52,
          protein: 0.003,
          fat: 0.002,
          carbs: 0.14,
          fiber: 0.024,
        );
        final savedId = await databaseService.saveFood(food);
        final savedFood = food.copyWith(id: savedId);

        // Act: Update calories (nutritional)
        final updatedFood = savedFood.copyWith(calories: 0.60);
        final resultId = await databaseService.saveFood(updatedFood);

        // Assert
        expect(resultId, savedId); // Still same ID because not referenced
        final saved = await databaseService.getFoodById(savedId, 'live');
        expect(saved?.calories, 0.60);
      },
    );

    test(
      'nutritional changes should create new version if referenced',
      () async {
        // Arrange
        const foodId = 1;
        final food = model.Food(
          id: foodId,
          source: 'live',
          name: 'Apple',
          calories: 0.52,
          protein: 0.003,
          fat: 0.002,
          carbs: 0.14,
          fiber: 0.024,
        );
        final savedId = await databaseService.saveFood(food);
        final savedFood = food.copyWith(id: savedId);

        // Reference it in a log
        await databaseService.logPortions([
          model_portion.FoodPortion(food: savedFood, grams: 100, unit: 'g'),
        ], DateTime.now());

        // Act: Update calories (nutritional)
        final updatedFood = savedFood.copyWith(calories: 0.60);
        final resultId = await databaseService.saveFood(updatedFood);

        // Assert
        expect(resultId, matcher.isNot(savedId)); // Should be a new ID
        final oldVersion = await databaseService.getFoodById(savedId, 'live');
        final newVersion = await databaseService.getFoodById(resultId, 'live');

        expect(oldVersion?.calories, 0.52); // Old version preserved
        expect(newVersion?.calories, 0.60); // New version created
        expect(newVersion?.parentId, savedId); // Lineage maintained
      },
    );
  });

  group('Unit-Based Quantity Persistence', () {
    test('should persist original unit and calculated quantity', () async {
      // Arrange
      const foodId = 1;
      final food = model.Food(
        id: foodId,
        source: 'live',
        name: 'Apple',
        calories: 0.52,
        protein: 0.003,
        fat: 0.002,
        carbs: 0.14,
        fiber: 0.024,
        servings: [
          const model_serving.FoodServing(
            foodId: foodId,
            unit: '1 medium',
            grams: 182,
            quantity: 1.0,
          ),
        ],
      );
      final savedId = await databaseService.saveFood(food);
      final savedFood = food.copyWith(id: savedId);

      final portion = model_portion.FoodPortion(
        food: savedFood,
        grams: 91, // Half a medium apple
        unit: '1 medium',
      );

      // Act
      final now = DateTime.now();
      await databaseService.logPortions([portion], now);

      // Assert: Verify database row directly
      final row = await (liveDatabase.select(
        liveDatabase.loggedPortions,
      )).getSingle();
      expect(row.unit, '1 medium');
      expect(row.grams, 91.0);
      expect(row.quantity, 0.5); // 91 / 182

      // Assert: Verify retrieval via LoggedPortion model
      final logs = await databaseService.getLoggedPortionsForDate(now);
      expect(logs.first.portion.quantity, 0.5);
      expect(logs.first.portion.unit, '1 medium');
    });
  });
}
