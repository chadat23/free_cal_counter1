import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/models/weight.dart';
import 'package:free_cal_counter1/services/goal_logic_service.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class WeightTrendChart extends StatelessWidget {
  final List<Weight> weightHistory;

  const WeightTrendChart({super.key, required this.weightHistory});

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

    // Sort and get trend
    final sorted = List<Weight>.from(weightHistory)
      ..sort((a, b) => a.date.compareTo(b.date));
    final trends = GoalLogicService.calculateTrendHistory(sorted);

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
          const Text(
            'Weight Trend (30d)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _WeightLinePainter(data: sorted, trends: trends),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM d').format(sorted.first.date),
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
              Text(
                DateFormat('MMM d').format(sorted.last.date),
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeightLinePainter extends CustomPainter {
  final List<Weight> data;
  final List<double> trends;

  _WeightLinePainter({required this.data, required this.trends});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final weights = data.map((e) => e.weight).toList();
    final allValues = [...weights, ...trends];
    final minWeight = allValues.reduce((a, b) => a < b ? a : b) - 0.5;
    final maxWeight = allValues.reduce((a, b) => a > b ? a : b) + 0.5;
    final weightRange = maxWeight - minWeight;

    // Drawing area padding for labels
    const double rightPadding = 40.0;
    final drawAreaWidth = size.width - rightPadding;

    final xStep = drawAreaWidth / (data.length > 1 ? data.length - 1 : 1);

    double getX(int index) => index * xStep;
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
    trendPath.moveTo(getX(0), getY(trends[0]));

    for (var i = 1; i < trends.length; i++) {
      trendPath.lineTo(getX(i), getY(trends[i]));
    }
    canvas.drawPath(trendPath, trendPaint);

    // 3. Paint Connected Weight Line Segments
    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final weightPath = Path();
    bool firstPoint = true;

    for (var i = 0; i < data.length; i++) {
      if (data[i].weight > 0) {
        if (firstPoint) {
          weightPath.moveTo(getX(i), getY(data[i].weight));
          firstPoint = false;
        } else {
          weightPath.lineTo(getX(i), getY(data[i].weight));
        }
      }
    }
    canvas.drawPath(weightPath, linePaint);

    // 4. Paint Raw Weight Points (Dots)
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (var i = 0; i < data.length; i++) {
      if (data[i].weight > 0) {
        canvas.drawCircle(Offset(getX(i), getY(data[i].weight)), 3, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
