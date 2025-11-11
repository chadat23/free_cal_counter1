import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/services/emoji_service.dart';

class FoodSearchResultTile extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;

  const FoodSearchResultTile({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = emojiForFoodName(food.name);

    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: food.thumbnail != null
              ? CachedNetworkImage(
                  imageUrl: food.thumbnail!,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.fastfood),
                  fit: BoxFit.cover,
                )
              : Text(
                  emoji ?? '🍽️', // Default emoji if no specific one is found
                  style: const TextStyle(fontSize: 24),
                ),
        ),
      ),
      title: Text(food.name),
      subtitle: Text(
        '${food.calories.round()} kcal, P: ${food.protein.round()}g, F: ${food.fat.round()}g, C: ${food.carbs.round()}g',
      ),
      onTap: onTap,
    );
  }
}