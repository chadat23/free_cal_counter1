import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/logged_food.dart';
import 'package:free_cal_counter1/models/meal.dart';
import 'package:free_cal_counter1/models/food_serving.dart';
import 'package:free_cal_counter1/widgets/meal_widget.dart';
import 'package:free_cal_counter1/widgets/portion_widget.dart';
import 'package:free_cal_counter1/widgets/slidable_portion_widget.dart';

void main() {
  testWidgets('Meal widget displays correctly', (WidgetTester tester) async {
    // Given
    final food1 = Food(
      id: 1,
      name: 'Apple',
      emoji: '🍎',
      calories: 0.52,
      protein: 0.0025,
      fat: 0.002,
      carbs: 0.14,
      fiber: 0.024,
      source: 'test',
      servings: [FoodServing(foodId: 1, unit: 'g', grams: 1.0, quantity: 1.0)],
    );
    final serving1 = FoodPortion(food: food1, grams: 100, unit: 'g');
    final loggedFood1 = LoggedFood(
      portion: serving1,
      timestamp: DateTime.now(),
    );

    final food2 = Food(
      id: 2,
      name: 'Banana',
      emoji: '🍌',
      calories: 0.89,
      protein: 0.01,
      fat: 0.003,
      carbs: 0.23,
      fiber: 0.026,
      source: 'test',
      servings: [FoodServing(foodId: 2, unit: 'g', grams: 1.0, quantity: 1.0)],
    );
    final serving2 = FoodPortion(food: food2, grams: 150, unit: 'g');
    final loggedFood2 = LoggedFood(
      portion: serving2,
      timestamp: DateTime.now(),
    );

    final meal = Meal(
      timestamp: DateTime.now(),
      loggedFoods: [loggedFood1, loggedFood2],
    );

    // When
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MealWidget(meal: meal)),
      ),
    );

    // Then
    expect(find.text(DateFormat.jm().format(meal.timestamp)), findsOneWidget);
    expect(find.text('🔥185'), findsOneWidget);
    expect(find.text('P: 1.8'), findsOneWidget);
    expect(find.text('F: 0.7'), findsOneWidget);
    expect(find.text('C: 48.5'), findsOneWidget);
    expect(find.text('Fb: 6.3'), findsOneWidget);
    expect(find.byType(SlidablePortionWidget), findsNWidgets(2));
  });
}
