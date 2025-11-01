
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/screens/food_search_screen.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';

void main() {
  testWidgets('FoodSearchScreen has a close button and calorie display', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LogProvider()),
        ],
        child: const MaterialApp(home: FoodSearchScreen()),
      ),
    );

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.text('0 / 2000'), findsOneWidget);
  });

  testWidgets('FoodSearchScreen has a FoodSearchRibbon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LogProvider()),
        ],
        child: const MaterialApp(home: FoodSearchScreen()),
      ),
    );

    expect(find.byType(FoodSearchRibbon), findsOneWidget);
  });

  testWidgets('FoodSearchScreen displays food icons from the queue with correct styling', (WidgetTester tester) async {
    final logProvider = LogProvider();
    final food = Food(
      id: 1,
      name: 'Apple',
      emoji: '🍎',
      calories: 52,
      protein: 0.3,
      fat: 0.2,
      carbs: 14,
    );
    logProvider.addFoodToQueue(food);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: logProvider),
        ],
        child: const MaterialApp(home: FoodSearchScreen()),
      ),
    );

    expect(find.text('🍎'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);

    final containerFinder = find.byType(Container);
    final containerWidget = tester.widget<Container>(containerFinder.first); // Corrected to .first
    expect(containerWidget.constraints?.maxHeight, 30.0);
    expect(containerWidget.decoration, isA<BoxDecoration>());
    final decoration = containerWidget.decoration as BoxDecoration;
    expect(decoration.color, Colors.grey[700]);
  });
}
