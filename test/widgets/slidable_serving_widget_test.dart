import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart';

import 'package:free_cal_counter1/widgets/slidable_serving_widget.dart';

void main() {
  testWidgets(
    'SlidableServingWidget slides to reveal delete button and deletes on tap',
    (WidgetTester tester) async {
      // Given
      bool onDeleteCalled = false;
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
      final serving = FoodPortion(food: food, grams: 100, unit: 'g');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SlidableServingWidget(
              serving: serving,
              onDelete: () {
                onDeleteCalled = true;
              },
            ),
          ),
        ),
      );

      // When - Slide to reveal
      await tester.fling(
        find.byType(SlidableServingWidget),
        const Offset(-200, 0),
        1000,
      );
      await tester.pumpAndSettle();

      // Then
      expect(find.byIcon(Icons.delete), findsOneWidget);

      // When - Tap delete
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Then
      expect(onDeleteCalled, isTrue);
    },
  );
}
