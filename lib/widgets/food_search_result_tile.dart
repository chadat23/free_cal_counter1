import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
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

  Color _getBackgroundColor(BuildContext context) {
    switch (food.source) {
      case 'FOUNDATION':
        return AppColors.searchResultBetter;
      case 'SR_LEGACY':
        return AppColors.searchResultGood;
      case 'off':
        return AppColors.searchResultBest;
      default:
        return Theme.of(context).canvasColor; // Use default theme color
    }
  }

  @override
  Widget build(BuildContext context) {
    final emoji = emojiForFoodName(food.name);

    return ListTile(
      tileColor: _getBackgroundColor(context),
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
              : const Icon(Icons.fastfood), // Default icon if no thumbnail
        ),
      ),
      title: Text('${emoji ?? ''} ${food.name}'),
      subtitle: Text(
        '${food.calories.round()} kcal • ${food.protein.toStringAsFixed(1)}g P • ${food.fat.toStringAsFixed(1)}g F • ${food.carbs.toStringAsFixed(1)}g C',
      ),
      onTap: onTap,
    );
  }
}