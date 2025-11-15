import 'package:free_cal_counter1/models/logged_food.dart';

class Meal {
  final DateTime timestamp;
  final List<LoggedFood> loggedFoods;

  Meal({required this.timestamp, required this.loggedFoods});

  double get totalCalories => loggedFoods.fold(
    0,
    (sum, item) =>
        sum + item.serving.food.calories * item.serving.servingSize / 100,
  );
  double get totalProtein => loggedFoods.fold(
    0,
    (sum, item) =>
        sum + item.serving.food.protein * item.serving.servingSize / 100,
  );
  double get totalFat => loggedFoods.fold(
    0,
    (sum, item) => sum + item.serving.food.fat * item.serving.servingSize / 100,
  );
  double get totalCarbs => loggedFoods.fold(
    0,
    (sum, item) =>
        sum + item.serving.food.carbs * item.serving.servingSize / 100,
  );
}
