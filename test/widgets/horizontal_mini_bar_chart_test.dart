import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:free_cal_counter1/widgets/horizontal_mini_bar_chart.dart';

void main() {
  testWidgets('HorizontalMiniBarChart renders correctly', (
    WidgetTester tester,
  ) async {
    final nutritionTarget = NutritionTarget(
      color: Colors.blue,
      thisAmount: 50,
      targetAmount: 100,
      macroLabel: 'P',
      unitLabel: 'g',
      dailyAmounts: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HorizontalMiniBarChart(nutritionTarget: nutritionTarget),
        ),
      ),
    );

    expect(find.text('P 50 / 100'), findsOneWidget);
    // More detailed checks can be added here, e.g., for the bar's width
  });
}
