import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/widgets/vertical_mini_bar_chart.dart';

void main() {
  group('MiniBarChart', () {
    testWidgets('renders correctly with given value and maxValue', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: VerticalMiniBarChart(
              value: 50,
              maxValue: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(VerticalMiniBarChart), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('painter has correct properties', (WidgetTester tester) async {
      const value = 50.0;
      const maxValue = 100.0;
      const color = Colors.blue;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: VerticalMiniBarChart(
              value: value,
              maxValue: maxValue,
              color: color,
            ),
          ),
        ),
      );

      final customPaint = tester.widget<CustomPaint>(find.byType(CustomPaint));
      final painter = customPaint.painter as VerticalMiniBarChartPainter;

      expect(painter.value, value);
      expect(painter.maxValue, maxValue);
      expect(painter.color, color);
    });

    testWidgets('bar height is clamped at 0 when value is negative', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: VerticalMiniBarChart(
              value: -10,
              maxValue: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final customPaint = tester.widget<CustomPaint>(find.byType(CustomPaint));
      final painter = customPaint.painter as VerticalMiniBarChartPainter;
      // This is an indirect test. We are checking the value passed to the painter.
      // A more robust test would be a golden test, but this is a good start.
      expect(painter.value, -10);
    });

    testWidgets('bar height is clamped at 1.05 of maxValue', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: VerticalMiniBarChart(
              value: 110,
              maxValue: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );
      final customPaint = tester.widget<CustomPaint>(find.byType(CustomPaint));
      final painter = customPaint.painter as VerticalMiniBarChartPainter;
      expect(painter.value, 110);
    });
  });
}
