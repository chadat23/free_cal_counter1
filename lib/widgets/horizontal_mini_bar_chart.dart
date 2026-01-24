import 'package:flutter/material.dart';

class HorizontalMiniBarChart extends StatelessWidget {
  final double consumed;
  final double target;
  final Color color;
  final String macroLabel;
  final String unitLabel;
  final bool notInverted;

  const HorizontalMiniBarChart({
    super.key,
    required this.consumed,
    required this.target,
    required this.color,
    required this.macroLabel,
    this.unitLabel = '',
    this.notInverted = true,
  });

  @override
  Widget build(BuildContext context) {
    final double displayValue = notInverted ? consumed : (target - consumed);
    final double percentage = target > 0 ? (displayValue / target) : 0.0;
    final double clippedPercentage = percentage.clamp(0.0, 1.1);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$macroLabel ${displayValue.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}$unitLabel',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              const SizedBox(height: 4),
              Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: clippedPercentage,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  if (target > 0)
                    Positioned(
                      left: constraints.maxWidth * 0.2, // Use local width
                      top: -4,
                      bottom: -4,
                      child: Container(width: 2, color: Colors.white),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
