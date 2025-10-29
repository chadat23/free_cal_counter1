import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';

void main() {
  group('FoodSearchRibbon', () {
    testWidgets('renders search bar, add button, and globe button', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FoodSearchRibbon())),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Search'), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
    });
  });
}
