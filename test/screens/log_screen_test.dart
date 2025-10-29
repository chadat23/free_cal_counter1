import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/screens/log_screen.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';

void main() {
  group('LogScreen', () {
    testWidgets('renders Log Screen text and FoodSearchRibbon', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LogScreen()));

      expect(find.text('Log Screen'), findsOneWidget);
      expect(find.byType(FoodSearchRibbon), findsOneWidget);
    });
  });
}
