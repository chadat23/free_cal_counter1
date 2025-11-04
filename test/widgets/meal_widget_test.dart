import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/logged_food.dart';
import 'package:free_cal_counter1/models/meal.dart';
import 'package:free_cal_counter1/widgets/meal_widget.dart';
import 'package:free_cal_counter1/widgets/portion_widget.dart';

void main() {
  testWidgets('Meal widget displays correctly', (WidgetTester tester) async {
    // Given
    final food1 = Food(
      id: 1,
      name: 'Apple',
      emoji: '🍎',
      calories: 52,
      protein: 0.25,
      fat: 0.2,
      carbs: 14,
      source: 'test',
    );
    final portion1 = FoodPortion(
      food: food1,
      servingSize: 100,
      servingUnit: 'g',
    );
    final loggedFood1 = LoggedFood(
      portion: portion1,
      timestamp: DateTime.now(),
    );

    final food2 = Food(
      id: 2,
      name: 'Banana',
      emoji: '🍌',
      calories: 89,
      protein: 1.0,
      fat: 0.3,
      carbs: 23,
      source: 'test',
    );
    final portion2 = FoodPortion(
      food: food2,
      servingSize: 150,
      servingUnit: 'g',
    );
    final loggedFood2 = LoggedFood(
      portion: portion2,
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
    expect(find.byType(PortionWidget), findsNWidgets(2));
  });
}
