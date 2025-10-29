import 'package:free_cal_counter1/config/app_colors.dart';
import 'dart:math';
import 'package:flutter/material.dart';

// Export for testing
export 'package:free_cal_counter1/widgets/mini_bar_chart.dart'
    show MiniBarChartPainter;

class MiniBarChart extends StatelessWidget {
  final double value;
  final double maxValue;
  final Color color;

  const MiniBarChart({
    super.key,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 48,
      child: CustomPaint(
        painter: MiniBarChartPainter(
          value: value,
          maxValue: maxValue,
          color: color,
        ),
      ),
    );
  }
}

class MiniBarChartPainter extends CustomPainter {
  final double value;
  final double maxValue;
  final Color color;

  MiniBarChartPainter({
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = AppColors.smallWidgetBackground;
    final barPaint = Paint()..color = color;
    final linePaint = Paint()
      ..color = Colors.white.withAlpha(128)
      ..strokeWidth = 1;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(3),
      ),
      backgroundPaint,
    );

    if (maxValue > 0) {
      final totalHeightForMaxValue =
          size.height / 1.2; // 100% mark is 20% less than total height
      final barRatio = (value / maxValue).clamp(0.0, 1.10); // Clip at 110%
      final barHeight = barRatio * totalHeightForMaxValue;

      final finalBarHeight = min(barHeight, size.height);

      if (finalBarHeight > 0) {
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
              size.width * 0.35,
              size.height - finalBarHeight + 2,
              size.width * 0.3,
              finalBarHeight - 2,
            ), // 10% padding on each side
            bottomLeft: const Radius.circular(2),
            bottomRight: const Radius.circular(2),
            topLeft: finalBarHeight / size.height > 0.99
                ? const Radius.circular(2)
                : Radius.zero,
            topRight: finalBarHeight / size.height > 0.99
                ? const Radius.circular(2)
                : Radius.zero,
          ),
          barPaint,
        );
      }

      final y = size.height - totalHeightForMaxValue;
      if (y > 0) {
        canvas.drawLine(
          Offset(size.width * 0.1, y),
          Offset(size.width * 0.9, y),
          linePaint,
        ); // 10% padding on each side
      }
    }
  }

  @override
  bool shouldRepaint(covariant MiniBarChartPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.color != color;
  }
}
