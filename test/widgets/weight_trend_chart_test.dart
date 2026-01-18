import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/weight.dart';
import 'package:free_cal_counter1/widgets/weight_trend_chart.dart';

void main() {
  testWidgets('WeightTrendChart displays empty state message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WeightTrendChart(weightHistory: [], timeframeLabel: '30d'),
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
          ),
        ),
      ),
    );

    expect(find.text('Weight Trend (1 mo)'), findsOneWidget);
    expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    expect(find.text('Jan 1'), findsOneWidget);
    expect(find.text('Jan 2'), findsOneWidget);
  });
}
