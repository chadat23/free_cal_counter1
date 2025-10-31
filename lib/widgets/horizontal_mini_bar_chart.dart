import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';

class HorizontalMiniBarChart extends StatelessWidget {
  final NutritionTarget nutritionTarget;

  const HorizontalMiniBarChart({
    super.key,
    required this.nutritionTarget,
  });

  @override
  Widget build(BuildContext context) {
    final double value = nutritionTarget.thisAmount;
    final double target = nutritionTarget.targetAmount;
    final double percentage = target > 0 ? (value / target) : 0.0;
    final double clippedPercentage = percentage.clamp(0.0, 1.1);

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
            '${nutritionTarget.macroLabel} ${value.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}',
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
                    color: nutritionTarget.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * (1 / target) * target * 0.2, // This is a bit of a hack to get the line to show up in the right place
                top: -4,
                bottom: -4,
                child: Container(
                  width: 2,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}