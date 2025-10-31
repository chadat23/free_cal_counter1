import 'package:free_cal_counter1/models/food.dart';

class FoodPortion {
  final Food food;
  final double servingSize;
  final String servingUnit;

  FoodPortion({
    required this.food,
    required this.servingSize,
    required this.servingUnit,
  });
}
