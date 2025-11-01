
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
