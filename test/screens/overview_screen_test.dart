import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/screens/overview_screen.dart';
import 'package:free_cal_counter1/widgets/nutrition_targets_overview_chart.dart';

void main() {
  group('OverviewScreen', () {
    testWidgets('renders NutritionTargetsOverviewChart', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OverviewScreen(),
        ),
      );

      expect(find.byType(NutritionTargetsOverviewChart), findsOneWidget);
    });
  });
}
