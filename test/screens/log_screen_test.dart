import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/screens/log_screen.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/widgets/log_header.dart';
import 'package:free_cal_counter1/widgets/meal_widget.dart';

void main() {
  group('LogScreen', () {
    testWidgets('renders LogHeader and FoodSearchRibbon', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LogScreen()));

      expect(find.byType(LogHeader), findsOneWidget);
      expect(find.byType(FoodSearchRibbon), findsOneWidget);
    });

    testWidgets('renders a list of meals', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LogScreen()));

      expect(find.byType(MealWidget), findsNWidgets(2));
    });

    testWidgets('date navigation works correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LogScreen()));

      expect(find.text('Today'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      expect(find.text('Yesterday'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      expect(find.text('Tomorrow'), findsOneWidget);
    });
  });
}
