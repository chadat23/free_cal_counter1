import 'package:free_cal_counter1/models/food.dart';

class FoodPortion {
  final Food food;
  final double grams; // weight of the portion in grams
  final String unit; // unit of measurement of the portion

  FoodPortion({required this.food, required this.grams, required this.unit});

  double get quantity {
    if (unit == 'g') return grams;
    final serving = food.servings.firstWhere(
      (s) => s.unit == unit,
      orElse: () => food.servings.first,
    );
    if (serving.grams == 0) return 0;
    return grams / serving.grams;
  }
}
