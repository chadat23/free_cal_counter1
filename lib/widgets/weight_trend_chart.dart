import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/models/weight.dart';
import 'package:free_cal_counter1/services/goal_logic_service.dart';
import 'package:intl/intl.dart';

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
    final minWeight = allValues.reduce((a, b) => a < b ? a : b) - 1.0;
    final maxWeight = allValues.reduce((a, b) => a > b ? a : b) + 1.0;
    final weightRange = maxWeight - minWeight;

    final xStep = size.width / (data.length - 1);

    double getX(int index) => index * xStep;
    double getY(double weight) {
      final normalized = (weight - minWeight) / weightRange;
      return size.height - (normalized * size.height);
    }

    // Paint Raw Weight Points (Subtle dots)
    final dotPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < data.length; i++) {
      if (data[i].weight > 0) {
        canvas.drawCircle(Offset(getX(i), getY(data[i].weight)), 3, dotPaint);
      }
    }

    // Paint Trend Line (EMA)
    final trendPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final trendPath = Path();
    trendPath.moveTo(getX(0), getY(trends[0]));

    for (var i = 1; i < trends.length; i++) {
      trendPath.lineTo(getX(i), getY(trends[i]));
    }

    canvas.drawPath(trendPath, trendPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
