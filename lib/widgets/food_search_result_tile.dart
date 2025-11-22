import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart' as model_unit;
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/services/emoji_service.dart';
import 'package:provider/provider.dart';

class FoodSearchResultTile extends StatefulWidget {
  final Food food;
  final void Function(model_unit.FoodServing) onTap;

  const FoodSearchResultTile({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  State<FoodSearchResultTile> createState() => _FoodSearchResultTileState();
}

class _FoodSearchResultTileState extends State<FoodSearchResultTile> {
  late model_unit.FoodServing _selectedUnit;
  late List<model_unit.FoodServing> _availableServings;

  @override
  void initState() {
    super.initState();
    _availableServings = List.of(widget.food.servings);

    // Ensure 'g' is always an option
    final hasGrams = _availableServings.any((s) => s.unit == 'g');
    if (!hasGrams) {
      _availableServings.add(
        model_unit.FoodServing(
          foodId: widget.food.id,
          unit: 'g',
          grams: 1.0,
          quantity: 1.0,
        ),
      );
    }

    // Default to 'g' if available, otherwise the first option
    _selectedUnit = _availableServings.firstWhere(
      (u) => u.unit == 'g',
      orElse: () => _availableServings.first,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (widget.food.source) {
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
    final emoji = emojiForFoodName(widget.food.name);

    final calories = widget.food.calories * _selectedUnit.grams;
    final protein = widget.food.protein * _selectedUnit.grams;
    final fat = widget.food.fat * _selectedUnit.grams;
    final carbs = widget.food.carbs * _selectedUnit.grams;

    return ListTile(
      tileColor: _getBackgroundColor(context),
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: widget.food.thumbnail != null
              ? CachedNetworkImage(
                  imageUrl: widget.food.thumbnail!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.fastfood),
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.fastfood), // Default icon if no thumbnail
        ),
      ),
      title: Text('${emoji ?? ''} ${widget.food.name}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${calories.round()} kcal • ${protein.toStringAsFixed(1)}g P • ${fat.toStringAsFixed(1)}g F • ${carbs.toStringAsFixed(1)}g C',
          ),
          DropdownButton<model_unit.FoodServing>(
            value: _selectedUnit,
            items: _availableServings.map((unit) {
              return DropdownMenuItem(value: unit, child: Text(unit.unit));
            }).toList(),
            onChanged: (unit) {
              if (unit != null) {
                setState(() {
                  _selectedUnit = unit;
                });
              }
            },
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          final logProvider = Provider.of<LogProvider>(context, listen: false);
          final serving = FoodPortion(
            food: widget.food,
            grams: 1,
            unit: _selectedUnit.unit,
          );
          logProvider.addFoodToQueue(serving);
        },
      ),
      onTap: () => widget.onTap(_selectedUnit),
    );
  }
}
