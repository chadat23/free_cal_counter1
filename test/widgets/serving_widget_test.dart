import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_serving.dart';
import 'package:free_cal_counter1/widgets/serving_widget.dart';

void main() {
  testWidgets('Serving widget displays correctly', (WidgetTester tester) async {
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
    );
    final serving = FoodServing(food: food, servingSize: 100, servingUnit: 'g');

    // When
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ServingWidget(serving: serving)),
      ),
    );

    // Then
    expect(find.text('🍎'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('🔥52'), findsOneWidget);
    expect(find.text('P: 0.3'), findsOneWidget);
    expect(find.text('F: 0.2'), findsOneWidget);
    expect(find.text('C: 14'), findsOneWidget);
    expect(find.text('100 g'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
  });
}
