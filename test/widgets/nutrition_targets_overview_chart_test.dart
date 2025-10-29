import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/widgets/mini_bar_chart.dart';
import 'package:free_cal_counter1/widgets/nutrition_targets_overview_chart.dart';

void main() {
  group('NutritionTargetsOverviewChart', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NutritionTargetsOverviewChart()),
        ),
      );

      expect(find.byType(NutritionTargetsOverviewChart), findsOneWidget);
    });

    testWidgets('renders 28 mini-bar widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NutritionTargetsOverviewChart()),
        ),
      );

      expect(find.byType(MiniBarChart), findsNWidgets(28));
    });

    testWidgets('renders weekday labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NutritionTargetsOverviewChart()),
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
        const MaterialApp(
          home: Scaffold(body: NutritionTargetsOverviewChart()),
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
        const MaterialApp(
          home: Scaffold(body: NutritionTargetsOverviewChart()),
        ),
      );

      expect(find.widgetWithText(TextButton, 'Consumed'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Remaining'), findsOneWidget);
    });
  });
}
