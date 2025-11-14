import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_unit.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';

void main() {
  late LogProvider logProvider;

  setUp(() {
    logProvider = LogProvider();
  });

  group('LogProvider', () {
    test('should add a food portion to the queue and update calories', () {
      // Arrange
      final food = Food(
        id: 1,
        name: 'Apple',
        calories: 52,
        protein: 0.3,
        fat: 0.2,
        carbs: 14,
        source: 'test',
        units: [FoodUnit(id: 1, foodId: 1, name: 'g', grams: 1.0)],
      );
      final portion = FoodPortion(food: food, servingSize: 100, servingUnit: 'g');

      // Act
      logProvider.addFoodToQueue(portion);

      // Assert
      expect(logProvider.logQueue.length, 1);
      expect(logProvider.logQueue.first, portion);
      expect(logProvider.queuedCalories, 52);
    });

    test('should remove a food portion from the queue and update calories', () {
      // Arrange
      final food = Food(
        id: 1,
        name: 'Apple',
        calories: 52,
        protein: 0.3,
        fat: 0.2,
        carbs: 14,
        source: 'test',
        units: [FoodUnit(id: 1, foodId: 1, name: 'g', grams: 1.0)],
      );
      final portion = FoodPortion(food: food, servingSize: 100, servingUnit: 'g');
      logProvider.addFoodToQueue(portion);

      // Act
      logProvider.removeFoodFromQueue(portion);

      // Assert
      expect(logProvider.logQueue.length, 0);
      expect(logProvider.queuedCalories, 0);
    });

    test('should clear the queue and reset calories', () {
      // Arrange
      final food = Food(
        id: 1,
        name: 'Apple',
        calories: 52,
        protein: 0.3,
        fat: 0.2,
        carbs: 14,
        source: 'test',
        units: [FoodUnit(id: 1, foodId: 1, name: 'g', grams: 1.0)],
      );
      final portion = FoodPortion(food: food, servingSize: 100, servingUnit: 'g');
      logProvider.addFoodToQueue(portion);

      // Act
      logProvider.clearQueue();

      // Assert
      expect(logProvider.logQueue.length, 0);
      expect(logProvider.queuedCalories, 0);
    });

    test('should correctly calculate calories for a portion with a different unit', () {
      // Arrange
      final food = Food(
        id: 1,
        name: 'Apple',
        calories: 52, // per 100g
        protein: 0.3,
        fat: 0.2,
        carbs: 14,
        source: 'test',
        units: [
          FoodUnit(id: 1, foodId: 1, name: 'g', grams: 1.0),
          FoodUnit(id: 2, foodId: 1, name: 'slice', grams: 10.0),
        ],
      );
      final portion = FoodPortion(food: food, servingSize: 2, servingUnit: 'slice');

      // Act
      logProvider.addFoodToQueue(portion);

      // Assert
      // 2 slices * 10g/slice = 20g
      // (52 calories / 100g) * 20g = 10.4 calories
      expect(logProvider.queuedCalories, 10.4);
    });
  });
}
