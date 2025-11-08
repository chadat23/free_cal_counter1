import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';

class PortionWidget extends StatelessWidget {
  final FoodPortion portion;

  const PortionWidget({super.key, required this.portion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Text(portion.food.emoji ?? '', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                portion.food.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('${portion.servingSize.toInt()} ${portion.servingUnit}'),
            ],
          ),
          const Spacer(),
          Flexible(
            child: Wrap(
              spacing: 8.0,
              alignment: WrapAlignment.end,
              children: [
                Text('🔥${portion.food.calories.toInt()}'),
                Text('P: ${portion.food.protein.toStringAsFixed(1)}'),
                Text('F: ${portion.food.fat.toStringAsFixed(1)}'),
                Text('C: ${portion.food.carbs.toStringAsFixed(0)}'),
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
