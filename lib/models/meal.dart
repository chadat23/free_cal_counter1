import 'package:free_cal_counter1/models/logged_food.dart';

class Meal {
  final DateTime timestamp;
  final List<LoggedFood> loggedFoods;

  Meal({required this.timestamp, required this.loggedFoods});

  double get totalCalories => loggedFoods.fold(
    0,
    (sum, item) =>
        sum + item.portion.food.calories * item.portion.servingSize / 100,
  );
  double get totalProtein => loggedFoods.fold(
    0,
    (sum, item) =>
        sum + item.portion.food.protein * item.portion.servingSize / 100,
  );
  double get totalFat => loggedFoods.fold(
    0,
    (sum, item) => sum + item.portion.food.fat * item.portion.servingSize / 100,
  );
  double get totalCarbs => loggedFoods.fold(
    0,
    (sum, item) =>
        sum + item.portion.food.carbs * item.portion.servingSize / 100,
  );
}
