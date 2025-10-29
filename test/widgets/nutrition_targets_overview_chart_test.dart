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
        label: '2134',
        subLabel: 'of 2143',
        dailyValues: [0.8, 0.9, 0.85, 0.95, 0.75, 0.8, 1.0],
      ),
      NutritionTarget(
        color: Colors.red,
        value: 159.0,
        maxValue: 141.0,
        label: '145 P',
        subLabel: 'of 141',
        dailyValues: [1.0, 0.9, 0.95, 1.05, 0.85, 0.9, 1.02],
      ),
      NutritionTarget(
        color: Colors.yellow,
        value: 70.0,
        maxValue: 71.0,
        label: '70 F',
        subLabel: 'of 71',
        dailyValues: [0.9, 1.0, 1.05, 0.95, 0.8, 0.85, 0.98],
      ),
      NutritionTarget(
        color: Colors.green,
        value: 241.0,
        maxValue: 233.0,
        label: '241 C',
        subLabel: 'of 233',
        dailyValues: [0.95, 0.85, 0.9, 1.0, 1.05, 0.8, 1.04],
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

    testWidgets('renders text placeholders for nutrient values', (
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

      expect(find.text('2134'), findsOneWidget);
      expect(find.text('of 2143'), findsOneWidget);
      expect(find.text('145 P'), findsOneWidget);
      expect(find.text('of 141'), findsOneWidget);
      expect(find.text('70 F'), findsOneWidget);
      expect(find.text('of 71'), findsOneWidget);
      expect(find.text('241 C'), findsOneWidget);
      expect(find.text('of 233'), findsOneWidget);
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
