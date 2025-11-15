import 'package:free_cal_counter1/models/food.dart';

class FoodServing {
  final Food food;
  final double servingSize;
  final String servingUnit;

  FoodServing({
    required this.food,
    required this.servingSize,
    required this.servingUnit,
  });
}
