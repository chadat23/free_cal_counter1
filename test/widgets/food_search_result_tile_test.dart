import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/widgets/food_search_result_tile.dart';

void main() {
  group('FoodSearchResultTile', () {
    testWidgets('displays food name and per 100g nutritional info', (tester) async {
      final food = model.Food(
        id: 1,
        name: 'Apple',
        emoji: '🍎',
        calories: 52, // per 100g
        protein: 0.3, // per 100g
        fat: 0.2, // per 100g
        carbs: 14, // per 100g
        source: 'test',
        units: [], // Units are not displayed in this minimal version
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodSearchResultTile(food: food, onTap: () {}),
          ),
        ),
      );

      // Verify food name is displayed
      expect(find.text('🍎 Apple'), findsOneWidget);

      // Verify per 100g nutritional info is displayed
      expect(find.text('52 kcal • 0.3g P • 0.2g F • 14.0g C'), findsOneWidget);
    });
  });
}
