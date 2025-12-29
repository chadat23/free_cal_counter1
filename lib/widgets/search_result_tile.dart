import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart' as model_unit;
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/emoji_service.dart';
import 'package:provider/provider.dart';

class SearchResultTile extends StatefulWidget {
  final Food food;
  final void Function(model_unit.FoodServing) onTap;
  final void Function(model_unit.FoodServing)? onAdd;

  const SearchResultTile({
    super.key,
    required this.food,
    required this.onTap,
    this.onAdd,
  });

  @override
  State<SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<SearchResultTile> {
  late model_unit.FoodServing _selectedUnit;
  late List<model_unit.FoodServing> _availableServings;

  @override
  void initState() {
    super.initState();
    _availableServings = List.of(widget.food.servings);

    // 'g' is guaranteed to be present by the service layer
    _selectedUnit = _availableServings.firstWhere(
      (u) => u.unit == 'g',
      orElse: () => _availableServings.first,
    );

    if (widget.food.id != 0) {
      _loadLastLoggedUnit();
    }
  }

  Future<void> _loadLastLoggedUnit() async {
    try {
      final lastUnit = await DatabaseService.instance.getLastLoggedUnit(
        widget.food.id,
      );
      if (lastUnit != null && mounted) {
        final servingIndex = _availableServings.indexWhere(
          (s) => s.unit == lastUnit,
        );
        if (servingIndex != -1) {
          setState(() {
            final serving = _availableServings.removeAt(servingIndex);
            _availableServings.insert(0, serving);
            _selectedUnit = serving;
          });
        }
      }
    } catch (e) {
      // Ignore DB errors in UI
      debugPrint('Error loading last logged unit: $e');
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (widget.food.source) {
      case 'FOUNDATION':
        return AppColors.searchResultBetter;
      case 'SR_LEGACY':
        return AppColors.searchResultGood;
      case 'off':
        return AppColors.searchResultBest;
      case 'recipe':
        return AppColors.searchResultRecipe;
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
    final fiber = widget.food.fiber * _selectedUnit.grams;

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
            '${calories.round()}🔥 • ${protein.toStringAsFixed(1)}P • ${fat.toStringAsFixed(1)}F • ${carbs.toStringAsFixed(1)}C • ${fiber.toStringAsFixed(1)}Fb',
          ),
          DropdownButton<model_unit.FoodServing>(
            value: _selectedUnit,
            items: _availableServings.map((unit) {
              return DropdownMenuItem(
                value: unit,
                child: Text('${unit.quantity} ${unit.unit}'),
              );
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
          if (widget.onAdd != null) {
            widget.onAdd!(_selectedUnit);
          } else {
            final logProvider = Provider.of<LogProvider>(
              context,
              listen: false,
            );
            final serving = FoodPortion(
              food: widget.food,
              grams: _selectedUnit.grams,
              unit: _selectedUnit.unit,
            );
            logProvider.addFoodToQueue(serving);
          }
        },
      ),
      onTap: () => widget.onTap(_selectedUnit),
    );
  }
}
