import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/widgets/mini_bar_chart.dart';
import 'package:free_cal_counter1/widgets/nutrition_targets_overview_chart.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';

void main() {
  group('NutritionTargetsOverviewChart', () {
    final List<NutritionTarget> mockNutritionData = [
      NutritionTarget(
        color: Colors.blue,
        value: 2134.0,
        maxValue: 2143.0,
        macroLabel: '🔥',
        unitLabel: '',
        dailyValues: [1714.4, 1928.7, 1821.55, 2035.85, 1607.25, 1714.4, 2143.0],
      ),
      NutritionTarget(
        color: Colors.red,
        value: 159.0,
        maxValue: 141.0,
        macroLabel: 'P',
        unitLabel: 'g',
        dailyValues: [141.0, 126.9, 133.95, 148.05, 119.85, 126.9, 143.82],
      ),
      NutritionTarget(
        color: Colors.yellow,
        value: 70.0,
        maxValue: 71.0,
        macroLabel: 'F',
        unitLabel: 'g',
        dailyValues: [63.9, 71.0, 74.55, 67.45, 56.8, 60.35, 69.58],
      ),
      NutritionTarget(
        color: Colors.green,
        value: 241.0,
        maxValue: 233.0,
        macroLabel: 'C',
        unitLabel: 'g',
        dailyValues: [221.35, 198.05, 209.7, 233.0, 244.65, 186.4, 242.32],
      ),
    ];

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionTargetsOverviewChart(
              nutritionData: mockNutritionData,
            ),
          ),
        ),
      );

      expect(find.byType(NutritionTargetsOverviewChart), findsOneWidget);
    });

    testWidgets('renders 28 mini-bar widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionTargetsOverviewChart(
              nutritionData: mockNutritionData,
            ),
          ),
        ),
      );

      expect(find.byType(MiniBarChart), findsNWidgets(28));
    });

    testWidgets('renders weekday labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionTargetsOverviewChart(
              nutritionData: mockNutritionData,
            ),
          ),
        ),
      );

      expect(find.text('M'), findsOneWidget);
      expect(find.text('T'), findsNWidgets(2)); // Tuesday and Thursday
      expect(find.text('W'), findsOneWidget);
      expect(find.text('F'), findsOneWidget);
      expect(find.text('S'), findsNWidgets(2)); // Saturday and Sunday
    });

    testWidgets('renders formatted nutrient values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionTargetsOverviewChart(
              nutritionData: mockNutritionData,
            ),
          ),
        ),
      );

      expect(find.text('2134 🔥\n of 2143'), findsOneWidget);
      expect(find.text('159 P\n of 141g'), findsOneWidget);
      expect(find.text('70 F\n of 71g'), findsOneWidget);
      expect(find.text('241 C\n of 233g'), findsOneWidget);
    });

    testWidgets('renders "Consumed" and "Remaining" buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionTargetsOverviewChart(
              nutritionData: mockNutritionData,
            ),
          ),
        ),
      );

      expect(find.widgetWithText(TextButton, 'Consumed'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Remaining'), findsOneWidget);
    });
  });
}
