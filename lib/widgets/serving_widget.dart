import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';

class ServingWidget extends StatelessWidget {
  final FoodPortion serving;

  const ServingWidget({super.key, required this.serving});

  @override
  Widget build(BuildContext context) {
    // Calculate totals based on the serving size
    // Note: serving.grams is actually the quantity/multiplier for the unit
    // We need to find the unit definition to get the grams per unit
    final unitDef = serving.food.servings.firstWhere(
      (u) => u.unit == serving.unit,
      orElse: () => serving.food.servings.first,
    );

    // Total grams = quantity * grams_per_unit
    final totalGrams = serving.grams * unitDef.grams;

    final calories = serving.food.calories * totalGrams;
    final protein = serving.food.protein * totalGrams;
    final fat = serving.food.fat * totalGrams;
    final carbs = serving.food.carbs * totalGrams;

    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: serving.food.thumbnail != null
              ? CachedNetworkImage(
                  imageUrl: serving.food.thumbnail!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Text(
                    serving.food.emoji ?? '🍴',
                    style: const TextStyle(fontSize: 24),
                  ),
                  fit: BoxFit.cover,
                )
              : Text(
                  serving.food.emoji ?? '🍴',
                  style: const TextStyle(fontSize: 24),
                ),
        ),
      ),
      title: Text(serving.food.name),
      subtitle: Text(
        '${calories.round()} kcal • ${protein.toStringAsFixed(1)}g P • ${fat.toStringAsFixed(1)}g F • ${carbs.toStringAsFixed(1)}g C',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${serving.grams} ${serving.unit}'),
          const SizedBox(width: 8),
          const Icon(Icons.edit_outlined),
        ],
      ),
    );
  }
}
