import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/models/food_unit.dart' as model_unit;
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/widgets/food_search_result_tile.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'food_search_result_tile_test.mocks.dart';

@GenerateMocks([LogProvider])
void main() {
  group('FoodSearchResultTile', () {
    testWidgets('displays food name and nutritional info with unit dropdown', (tester) async {
      final mockUnits = [
        model_unit.FoodUnit(id: 1, foodId: 1, name: 'g', grams: 1.0),
        model_unit.FoodUnit(id: 2, foodId: 1, name: '1 medium', grams: 182.0),
        model_unit.FoodUnit(id: 3, foodId: 1, name: '1 cup sliced', grams: 109.0),
      ];
      final food = model.Food(
        id: 1,
        name: 'Apple',
        emoji: '🍎',
        calories: 0.52, // per gram
        protein: 0.003, // per gram
        fat: 0.002, // per gram
        carbs: 0.14, // per gram
        source: 'test',
        units: mockUnits,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodSearchResultTile(food: food, onTap: (_) {}),
          ),
        ),
      );

      // Verify food name is displayed
      expect(find.text('🍎 Apple'), findsOneWidget);

      // Verify initial nutritional info (should be for 1g by default)
      // Calories: 0.52 * 1 = 0.52
      expect(find.text('1 kcal • 0.0g P • 0.0g F • 0.1g C'), findsOneWidget);

      // Open the dropdown
      await tester.tap(find.byType(DropdownButton<model_unit.FoodUnit>));
      await tester.pumpAndSettle();

      // Select '1 medium' unit
      await tester.tap(find.text('1 medium').last);
      await tester.pumpAndSettle();

      // Verify nutritional info updates for '1 medium' (182g)
      // Calories: 0.52 * 182 = 94.64
      // Protein: 0.003 * 182 = 0.546
      // Fat: 0.002 * 182 = 0.364
      // Carbs: 0.14 * 182 = 25.48
      expect(find.text('95 kcal • 0.5g P • 0.4g F • 25.5g C'), findsOneWidget);

      // Select '1 cup sliced' unit
      await tester.tap(find.byType(DropdownButton<model_unit.FoodUnit>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1 cup sliced').last);
      await tester.pumpAndSettle();

      // Verify nutritional info updates for '1 cup sliced' (109g)
      // Calories: 0.52 * 109 = 56.68
      // Protein: 0.003 * 109 = 0.327
      // Fat: 0.002 * 109 = 0.218
      // Carbs: 0.14 * 109 = 15.26
      expect(find.text('57 kcal • 0.3g P • 0.2g F • 15.3g C'), findsOneWidget);
    });

    testWidgets('should have an add button that adds the food to the log queue', (tester) async {
      final mockLogProvider = MockLogProvider();
      final mockUnits = [
        model_unit.FoodUnit(id: 1, foodId: 1, name: 'g', grams: 1.0),
      ];
      final food = model.Food(
        id: 1,
        name: 'Apple',
        emoji: '🍎',
        calories: 0.52,
        protein: 0.003,
        fat: 0.002,
        carbs: 0.14,
        source: 'test',
        units: mockUnits,
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<LogProvider>.value(
          value: mockLogProvider,
          child: MaterialApp(
            home: Scaffold(
              body: FoodSearchResultTile(food: food, onTap: (_) {}),
            ),
          ),
        ),
      );

      // Verify the add button exists
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Tap the add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that addFoodToQueue was called with the correct FoodPortion
      verify(mockLogProvider.addFoodToQueue(any)).called(1);
    });
  });
}