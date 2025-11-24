import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart';
import 'package:free_cal_counter1/widgets/serving_widget.dart';

void main() {
  testWidgets('Serving widget displays correctly', (WidgetTester tester) async {
    // Given
    final food = Food(
      id: 1,
      name: 'Apple',
      emoji: '🍎',
      calories: 0.52, // 52 kcal per 100g
      protein: 0.003, // 0.3g per 100g
      fat: 0.002, // 0.2g per 100g
      carbs: 0.14, // 14g per 100g
      fiber: 0.024, // 2.4g per 100g
      source: 'test',
      servings: [FoodServing(foodId: 1, quantity: 1.0, unit: 'g', grams: 1.0)],
    );
    final serving = FoodPortion(food: food, grams: 100, unit: 'g');

    // When
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ServingWidget(serving: serving)),
      ),
    );

    // Then
    expect(find.text('🍎'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('52🔥 • 0.3P • 0.2F • 14.0C'), findsOneWidget);
    expect(find.text('100.0 g'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
  });
}
