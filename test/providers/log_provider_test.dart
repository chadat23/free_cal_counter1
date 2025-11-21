import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_serving.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';

void main() {
  late LogProvider logProvider;

  setUp(() {
    logProvider = LogProvider();
  });

  group('LogProvider', () {
    test('should add a food serving to the queue and update calories', () {
      // Arrange
      final food = Food(
        id: 1,
        name: 'Apple',
        calories: 0.52, // per gram
        protein: 0.003,
        fat: 0.002,
        carbs: 0.14,
        source: 'test',
        portions: [
          FoodPortion.FoodPortion(id: 1, foodId: 1, name: 'g', grams: 1.0),
        ],
      );
      final serving = FoodServing(
        food: food,
        servingSize: 100,
        servingUnit: 'g',
      );

      // Act
      logProvider.addFoodToQueue(serving);

      // Assert
      // 0.52 calories/g * 1.0 g/unit * 100 units = 52 calories
      expect(logProvider.logQueue.length, 1);
      expect(logProvider.logQueue.first, serving);
      expect(logProvider.queuedCalories, 52);
    });

    test('should remove a food serving from the queue and update calories', () {
      // Arrange
      final food = Food(
        id: 1,
        name: 'Apple',
        calories: 0.52, // per gram
        protein: 0.003,
        fat: 0.002,
        carbs: 0.14,
        source: 'test',
        portions: [
          FoodPortion.FoodPortion(id: 1, foodId: 1, name: 'g', grams: 1.0),
        ],
      );
      final serving = FoodServing(
        food: food,
        servingSize: 100,
        servingUnit: 'g',
      );
      logProvider.addFoodToQueue(serving);

      // Act
      logProvider.removeFoodFromQueue(serving);

      // Assert
      expect(logProvider.logQueue.length, 0);
      expect(logProvider.queuedCalories, 0);
    });

    test('should clear the queue and reset calories', () {
      // Arrange
      final food = Food(
        id: 1,
        name: 'Apple',
        calories: 0.52, // per gram
        protein: 0.003,
        fat: 0.002,
        carbs: 0.14,
        source: 'test',
        portions: [
          FoodPortion.FoodPortion(id: 1, foodId: 1, name: 'g', grams: 1.0),
        ],
      );
      final serving = FoodServing(
        food: food,
        servingSize: 100,
        servingUnit: 'g',
      );
      logProvider.addFoodToQueue(serving);

      // Act
      logProvider.clearQueue();

      // Assert
      expect(logProvider.logQueue.length, 0);
      expect(logProvider.queuedCalories, 0);
    });

    test(
      'should correctly calculate calories for a serving with a different unit',
      () {
        // Arrange
        final food = Food(
          id: 1,
          name: 'Apple',
          calories: 0.52, // per gram
          protein: 0.003,
          fat: 0.002,
          carbs: 0.14,
          source: 'test',
          portions: [
            FoodPortion.FoodPortion(id: 1, foodId: 1, name: 'g', grams: 1.0),
            FoodPortion.FoodPortion(
              id: 2,
              foodId: 1,
              name: 'slice',
              grams: 10.0,
            ),
          ],
        );
        final serving = FoodServing(
          food: food,
          servingSize: 2,
          servingUnit: 'slice',
        );

        // Act
        logProvider.addFoodToQueue(serving);

        // Assert
        // 2 slices * 10g/slice = 20g
        // 0.52 calories/g * 20g = 10.4 calories
        expect(logProvider.queuedCalories, 10.4);
      },
    );
  });
}
