import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/screens/portion_edit_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
    'PortionEditScreen shows "Update" button and calls onUpdate when provided',
    (WidgetTester tester) async {
      // Given
      FoodPortion? updatedPortion;
      final food = Food(
        id: 1,
        name: 'Apple',
        emoji: '🍎',
        calories: 52,
        protein: 0.3,
        fat: 0.2,
        carbs: 14,
        fiber: 2.4,
        source: 'test',
        servings: [
          FoodServing(foodId: 1, unit: 'g', grams: 1.0, quantity: 1.0),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => LogProvider(),
            child: PortionEditScreen(
              food: food,
              onUpdate: (portion) {
                updatedPortion = portion;
              },
            ),
          ),
        ),
      );

      // Then - Verify "Update" button is shown
      expect(find.text('Update'), findsOneWidget);
      expect(find.text('Add'), findsNothing);

      // When - Tap Update
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      // Then - Verify callback was called
      expect(updatedPortion, isNotNull);
      expect(updatedPortion!.food.name, 'Apple');
    },
  );

  testWidgets('PortionEditScreen shows "Add" button when onUpdate is null', (
    WidgetTester tester,
  ) async {
    // Given
    final food = Food(
      id: 1,
      name: 'Apple',
      emoji: '🍎',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbs: 14,
      fiber: 2.4,
      source: 'test',
      servings: [FoodServing(foodId: 1, unit: 'g', grams: 1.0, quantity: 1.0)],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => LogProvider(),
          child: PortionEditScreen(food: food),
        ),
      ),
    );

    // Then - Verify "Add" button is shown
    expect(find.text('Add'), findsOneWidget);
    expect(find.text('Update'), findsNothing);
  });

  testWidgets('PortionEditScreen initializes with provided initialQuantity', (
    WidgetTester tester,
  ) async {
    // Given
    final food = Food(
      id: 1,
      name: 'Apple',
      emoji: '🍎',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbs: 14,
      fiber: 2.4,
      source: 'test',
      servings: [FoodServing(foodId: 1, unit: 'g', grams: 1.0, quantity: 1.0)],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => LogProvider(),
          child: PortionEditScreen(food: food, initialQuantity: 2.5),
        ),
      ),
    );

    // Then - Verify text field contains initial quantity
    expect(find.text('2.5'), findsOneWidget);
  });
}
