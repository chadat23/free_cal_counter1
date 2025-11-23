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
      child: SizedBox(height: 50, child: Text('Placeholder')),
    );
  }
}
