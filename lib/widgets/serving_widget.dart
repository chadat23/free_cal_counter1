import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';

class ServingWidget extends StatelessWidget {
  final FoodPortion serving;

  const ServingWidget({super.key, required this.serving});

  @override
  Widget build(BuildContext context) {
    final unit = serving.food.servings.firstWhere(
      (u) => u.unit == serving.unit,
      orElse: () => serving.food.servings.first,
    );
    final totalGrams = unit.grams * serving.grams;

    final calories = serving.food.calories * totalGrams;
    final protein = serving.food.protein * totalGrams;
    final fat = serving.food.fat * totalGrams;
    final carbs = serving.food.carbs * totalGrams;

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
              Text('${serving.grams} ${serving.unit}'),
            ],
          ),
          const Spacer(),
          Flexible(
            child: Wrap(
              spacing: 8.0,
              alignment: WrapAlignment.end,
              children: [
                Text('🔥${calories.round()}'),
                Text('P: ${protein.toStringAsFixed(1)}'),
                Text('F: ${fat.toStringAsFixed(1)}'),
                Text('C: ${carbs.toStringAsFixed(0)}'),
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
