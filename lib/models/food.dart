import 'package:free_cal_counter1/models/food_unit.dart';

class Food {
  final int id;
  final String source;
  final String name;
  final String? emoji;
  final String? thumbnail;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final List<FoodUnit> units;

  Food({
    required this.id,
    required this.source,
    required this.name,
    this.emoji,
    this.thumbnail,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.units = const [], // Initialize with an empty list
  });
}
