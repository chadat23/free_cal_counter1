import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/weight.dart';
import 'package:free_cal_counter1/widgets/weight_trend_chart.dart';

void main() {
  testWidgets('WeightTrendChart displays empty state message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeightTrendChart(
            weightHistory: [],
            timeframeLabel: '30d',
            startDate: DateTime(2023, 1, 1),
            endDate: DateTime(2023, 1, 31),
          ),
        ),
      ),
    );

    expect(find.text('No weight data for the last 30 days'), findsOneWidget);
  });

  testWidgets('WeightTrendChart renders CustomPaint with data', (tester) async {
    final history = [
      Weight(weight: 70.0, date: DateTime(2023, 1, 1)),
      Weight(weight: 71.0, date: DateTime(2023, 1, 2)),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeightTrendChart(
            weightHistory: history,
            timeframeLabel: '1 mo',
            startDate: DateTime(2023, 1, 1),
            endDate: DateTime(2023, 1, 31),
          ),
        ),
      ),
    );

    expect(find.text('Weight Trend (1 mo)'), findsOneWidget);
    expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    expect(find.text('Jan 1'), findsOneWidget);
    expect(find.text('Jan 31'), findsOneWidget);
  });

  testWidgets('WeightTrendChart handles gaps in data with placeholder dots', (
    tester,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final twoDaysAgo = today.subtract(const Duration(days: 2));

    // Data only for 2 days ago and yesterday, MISSING today
    final history = [
      Weight(weight: 80.0, date: twoDaysAgo),
      Weight(weight: 81.0, date: yesterday),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeightTrendChart(
            weightHistory: history,
            timeframeLabel: '1 wk',
            startDate: twoDaysAgo,
            endDate: today,
          ),
        ),
      ),
    );

    expect(find.text('Weight Trend (1 wk)'), findsOneWidget);
    expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));

    // We can't easily check the painter's private dots, but we can verify it renders.
    // Future: Add more specific checks if WeightTrendChart is refactored to expose point counts.
  });
}
