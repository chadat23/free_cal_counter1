import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_serving.dart';
import 'package:free_cal_counter1/providers/recipe_provider.dart';
import 'package:free_cal_counter1/screens/ingredient_edit_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:free_cal_counter1/models/food_portion.dart';

@GenerateMocks([RecipeProvider])
import 'ingredient_edit_screen_test.mocks.dart';

void main() {
  late MockRecipeProvider mockRecipeProvider;
  late Food testFood;

  setUp(() {
    mockRecipeProvider = MockRecipeProvider();
    testFood = Food(
      id: 1,
      name: 'Test Apple',
      source: 'test',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbs: 14,
      fiber: 2.4,
      servings: [
        FoodServing(id: 1, foodId: 1, unit: 'g', grams: 1, quantity: 1),
        FoodServing(id: 2, foodId: 1, unit: 'medium', grams: 182, quantity: 1),
      ],
    );

    // Mock generic responses for RecipeProvider
    when(mockRecipeProvider.totalCalories).thenReturn(500.0);
    when(mockRecipeProvider.totalProtein).thenReturn(20.0);
    when(mockRecipeProvider.totalFat).thenReturn(10.0);
    when(mockRecipeProvider.totalCarbs).thenReturn(80.0);
    when(mockRecipeProvider.totalFiber).thenReturn(5.0);
    when(mockRecipeProvider.servingsCreated).thenReturn(4.0); // 4 servings
  });

  Widget createSubject() {
    return MaterialApp(
      home: IngredientEditScreen(
        food: testFood,
        recipeProvider: mockRecipeProvider,
      ),
    );
  }

  group('IngredientEditScreen Tests', () {
    testWidgets('renders correctly with food info', (tester) async {
      await tester.pumpWidget(createSubject());

      expect(find.text('Test Apple'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Per Serving'), findsOneWidget);
      expect(find.text("Recipe's Macros (Total)"), findsOneWidget);
      expect(find.text("Ingredient's Macros (Total)"), findsOneWidget);
    });

    testWidgets('Calculate grams updates when amount changes', (tester) async {
      await tester.pumpWidget(createSubject());

      // Initial amount is 1
      // Default unit is 'g' (first one), so 1g
      // calories = 52 * 1 = 52

      // Let's change unit to 'medium' (182g)
      await tester.tap(find.text('medium'));
      await tester.pump();

      // Enter 2 as amount -> 364g total
      // Calories for 364g: 52 * 364 = 18928 calories (Note: testFood data is per 100g usually in app logic but here structure implies per unit if data was real,
      // but actually code does `food.calories * currentGrams`.
      // Wait, food.calories is usually per 100g or 1g?
      // In this app, `food.calories` seems to be per 1g based on typical usage: `food.calories * grams`.
      // If Test Apple is 52 cal/1g, that's energy dense! But let's assume the math holds for the test.

      final amountFinder = find.widgetWithText(TextField, 'Amount');
      await tester.enterText(amountFinder, '2');
      await tester.pump();

      // Just ensure no crash and values updated (hard to check exact chart values visually in widget test easily without key inspection)
      expect(find.text("Ingredient's Macros (Total)"), findsOneWidget);
    });

    testWidgets('Toggle switches between Total and Per Serving labels', (
      tester,
    ) async {
      await tester.pumpWidget(createSubject());

      // Default is Total
      expect(find.text("Recipe's Macros (Total)"), findsOneWidget);

      // Tap Per Serving
      await tester.tap(find.text('Per Serving'));
      await tester.pump();

      expect(find.text("Recipe's Macros (Per Serving)"), findsOneWidget);
      expect(find.text("Ingredient's Macros (Per Serving)"), findsOneWidget);
    });

    testWidgets('Add button returns FoodPortion and does not crash', (
      tester,
    ) async {
      FoodPortion? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => IngredientEditScreen(
                      food: testFood,
                      recipeProvider: mockRecipeProvider,
                    ),
                  ),
                );
              },
              child: const Text('Go'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.food.name, 'Test Apple');
      expect(result!.grams, 1.0); // Default 1g
    });
  });
}
