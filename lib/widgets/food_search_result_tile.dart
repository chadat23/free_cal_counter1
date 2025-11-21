import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_serving.dart';
import 'package:free_cal_counter1/models/food_portion.dart' as model_unit;
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/services/emoji_service.dart';
import 'package:provider/provider.dart';

class FoodSearchResultTile extends StatefulWidget {
  final Food food;
  final void Function(model_unit.FoodPortion) onTap;

  const FoodSearchResultTile({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  State<FoodSearchResultTile> createState() => _FoodSearchResultTileState();
}

class _FoodSearchResultTileState extends State<FoodSearchResultTile> {
  late model_unit.FoodPortion _selectedUnit;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.food.portions.firstWhere(
      (u) => u.name == 'g',
      orElse: () => widget.food.portions.first,
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
          if (widget.food.portions.length > 1)
            DropdownButton<model_unit.FoodPortion>(
              value: _selectedUnit,
              items: widget.food.portions.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit.name));
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
          final serving = FoodServing(
            food: widget.food,
            servingSize: 1,
            servingUnit: _selectedUnit.name,
          );
          logProvider.addFoodToQueue(serving);
        },
      ),
      onTap: () => widget.onTap(_selectedUnit),
    );
  }
}
