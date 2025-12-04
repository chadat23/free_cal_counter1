import 'package:free_cal_counter1/models/food.dart';

class FoodPortion {
  final Food food;
  final double grams; // weight of the portion in grams
  final String unit; // unit of measurement of the portion

  FoodPortion({required this.food, required this.grams, required this.unit});
}
