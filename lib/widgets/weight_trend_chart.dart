import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/models/weight.dart';
import 'package:free_cal_counter1/services/goal_logic_service.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class WeightTrendChart extends StatelessWidget {
  final List<Weight> weightHistory;
  final String timeframeLabel;
  final DateTime startDate;
  final DateTime endDate;

  const WeightTrendChart({
    super.key,
    required this.weightHistory,
    required this.timeframeLabel,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    if (weightHistory.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.largeWidgetBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No weight data for the last 30 days',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    // 1. Calculate min weight for placeholders
    final realWeights = weightHistory.map((e) => e.weight).toList();
    final minRealWeight = realWeights.reduce((a, b) => a < b ? a : b);

    // 2. Map existing weights by date (date only)
    final weightMap = <DateTime, double>{};
    for (final w in weightHistory) {
      final dateOnly = DateTime(w.date.year, w.date.month, w.date.day);
      weightMap[dateOnly] = w.weight;
    }

    // 3. Generate points for every day in the range
    final points = <_ChartPoint>[];
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    var current = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!current.isAfter(end)) {
      final realWeight = weightMap[current];
      final isPlaceholder = realWeight == null;

      points.add(
        _ChartPoint(
          date: current,
          weight: realWeight ?? minRealWeight,
          isPlaceholder: isPlaceholder,
          isToday: current.isAtSameMomentAs(todayDate),
        ),
      );
      current = current.add(const Duration(days: 1));
    }

    // Sort sorted strictly for trend calculation (using only real data)
    final sortedReal = List<Weight>.from(weightHistory)
      ..sort((a, b) => a.date.compareTo(b.date));
    final trends = GoalLogicService.calculateTrendHistory(sortedReal);

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.largeWidgetBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Trend ($timeframeLabel)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _WeightLinePainter(
                points: points,
                realData: sortedReal,
                trends: trends,
                startDate: startDate,
                endDate: endDate,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM d').format(startDate),
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
              Text(
                DateFormat('MMM d').format(endDate),
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartPoint {
  final DateTime date;
  final double weight;
  final bool isPlaceholder;
  final bool isToday;

  _ChartPoint({
    required this.date,
    required this.weight,
    required this.isPlaceholder,
    this.isToday = false,
  });
}

class _WeightLinePainter extends CustomPainter {
  final List<_ChartPoint> points;
  final List<Weight> realData;
  final List<double> trends;
  final DateTime startDate;
  final DateTime endDate;

  _WeightLinePainter({
    required this.points,
    required this.realData,
    required this.trends,
    required this.startDate,
    required this.endDate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || realData.isEmpty) return;

    final weights = realData.map((e) => e.weight).toList();
    final allValues = [...weights, ...trends];
    final minWeight = allValues.reduce((a, b) => a < b ? a : b) - 0.5;
    final maxWeight = allValues.reduce((a, b) => a > b ? a : b) + 0.5;
    final weightRange = maxWeight - minWeight;

    // Drawing area padding for labels
    const double rightPadding = 40.0;
    final drawAreaWidth = size.width - rightPadding;

    final totalDuration = endDate.difference(startDate).inSeconds;

    double getX(DateTime date) {
      if (totalDuration == 0) return 0;
      final elapsed = date.difference(startDate).inSeconds;
      return (elapsed / totalDuration) * drawAreaWidth;
    }

    double getY(double weight) {
      final normalized = (weight - minWeight) / weightRange;
      return size.height - (normalized * size.height);
    }

    // 1. Paint Y-Axis Labels & Grid Lines
    final labelPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1.0;

    void drawYLabel(double weight) {
      final y = getY(weight);
      canvas.drawLine(Offset(0, y), Offset(drawAreaWidth, y), gridPaint);

      labelPainter.text = TextSpan(
        text: weight.toStringAsFixed(1),
        style: const TextStyle(color: Colors.white38, fontSize: 9),
      );
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(drawAreaWidth + 5, y - 6));
    }

    drawYLabel(minWeight + 0.5);
    drawYLabel(maxWeight - 0.5);
    drawYLabel((minWeight + maxWeight) / 2);

    // 2. Paint Trend Line (EMA) - Background Layer
    final trendPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final trendPath = Path();
    trendPath.moveTo(getX(realData[0].date), getY(trends[0]));

    for (var i = 1; i < trends.length; i++) {
      trendPath.lineTo(getX(realData[i].date), getY(trends[i]));
    }
    canvas.drawPath(trendPath, trendPaint);

    // 3. Paint Connected Weight Line Segments (Real Data Only)
    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final weightPath = Path();
    bool firstPoint = true;

    for (var i = 0; i < points.length; i++) {
      if (!points[i].isPlaceholder) {
        if (firstPoint) {
          weightPath.moveTo(getX(points[i].date), getY(points[i].weight));
          firstPoint = false;
        } else {
          weightPath.lineTo(getX(points[i].date), getY(points[i].weight));
        }
      }
    }
    canvas.drawPath(weightPath, linePaint);

    // 4. Paint Raw Weight Points (Dots)
    final dotPaint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      if (point.isPlaceholder) {
        // Muted color for old placeholders, red for today
        dotPaint.color = point.isToday
            ? Colors.red.withOpacity(0.8)
            : Colors.white.withOpacity(0.2);
        canvas.drawCircle(
          Offset(getX(point.date), getY(point.weight)),
          point.isToday ? 4 : 2,
          dotPaint,
        );
      } else {
        // Real data point
        dotPaint.color = Colors.white;
        canvas.drawCircle(
          Offset(getX(point.date), getY(point.weight)),
          3,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
