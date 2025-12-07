import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';

class PortionWidget extends StatelessWidget {
  final FoodPortion portion;
  final VoidCallback? onEdit;

  const PortionWidget({super.key, required this.portion, this.onEdit});

  @override
  Widget build(BuildContext context) {
    // Calculate totals based on the serving size
    // Note: serving.grams is actually the quantity/multiplier for the unit
    // We need to find the unit definition to get the grams per unit
    final unitDef = portion.food.servings.firstWhere(
      (u) => u.unit == portion.unit,
      orElse: () => portion.food.servings.first,
    );

    // serving.grams is now the actual weight in grams
    final totalGrams = portion.grams;

    final calories = portion.food.calories * totalGrams;
    final protein = portion.food.protein * totalGrams;
    final fat = portion.food.fat * totalGrams;
    final carbs = portion.food.carbs * totalGrams;
    final fiber = portion.food.fiber * totalGrams;

    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: portion.food.thumbnail != null
              ? CachedNetworkImage(
                  imageUrl: portion.food.thumbnail!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Text(
                    portion.food.emoji ?? '🍴',
                    style: const TextStyle(fontSize: 24),
                  ),
                  fit: BoxFit.cover,
                )
              : Text(
                  portion.food.emoji ?? '🍴',
                  style: const TextStyle(fontSize: 24),
                ),
        ),
      ),
      title: Text(portion.food.name),
      subtitle: Text(
        '${calories.round()}🔥 • ${protein.toStringAsFixed(1)}P • ${fat.toStringAsFixed(1)}F • ${carbs.toStringAsFixed(1)}C • ${fiber.toStringAsFixed(1)}Fb',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${unitDef.quantityFromGrams(totalGrams).toStringAsFixed(1)} ${unitDef.unit}',
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: onEdit),
        ],
      ),
    );
  }
}
