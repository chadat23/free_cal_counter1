import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food.dart';

class LogQueueTopRibbon extends StatelessWidget {
  final IconData arrowDirection;
  final VoidCallback onArrowPressed;
  final double totalCalories;
  final double dailyTargetCalories;
  final List<Food> logQueue;

  const LogQueueTopRibbon({
    super.key,
    required this.arrowDirection,
    required this.onArrowPressed,
    required this.totalCalories,
    required this.dailyTargetCalories,
    required this.logQueue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${totalCalories.toInt()} / ${dailyTargetCalories.toInt()}',
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Container(
            height: 30.0, // Fixed height
            decoration: BoxDecoration(
              color: Colors.grey[700], // Different background color
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: logQueue
                    .map(
                      (food) => Text(
                        food.emoji ?? '',
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        IconButton(icon: Icon(arrowDirection), onPressed: onArrowPressed),
      ],
    );
  }
}
