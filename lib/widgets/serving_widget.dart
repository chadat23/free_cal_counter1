import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';

class ServingWidget extends StatelessWidget {
  final FoodPortion serving;

  const ServingWidget({super.key, required this.serving});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Text(serving.food.emoji ?? '', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serving.food.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('${serving.grams.toInt()} ${serving.unit}'),
            ],
          ),
          const Spacer(),
          Flexible(
            child: Wrap(
              spacing: 8.0,
              alignment: WrapAlignment.end,
              children: [
                Text('🔥${serving.food.calories.toInt()}'),
                Text('P: ${serving.food.protein.toStringAsFixed(1)}'),
                Text('F: ${serving.food.fat.toStringAsFixed(1)}'),
                Text('C: ${serving.food.carbs.toStringAsFixed(0)}'),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
        ],
      ),
    );
  }
}
