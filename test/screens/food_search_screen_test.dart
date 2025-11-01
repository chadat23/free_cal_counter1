
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/screens/food_search_screen.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';

void main() {
  testWidgets('FoodSearchScreen has a title and a close button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: FoodSearchScreen()));

    expect(find.text('Food Search'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('FoodSearchScreen has a FoodSearchRibbon', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: FoodSearchScreen()));

    expect(find.byType(FoodSearchRibbon), findsOneWidget);
  });
}
