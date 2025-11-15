import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_serving.dart';

class LogProvider extends ChangeNotifier {
  // Placeholder values for now
  double _loggedCalories = 0.0;
  double _queuedCalories = 0.0;
  double _dailyTargetCalories = 2000.0; // Example target
  final List<FoodServing> _logQueue = [];

  double get loggedCalories => _loggedCalories;
  double get queuedCalories => _queuedCalories;
  double get totalCalories => _loggedCalories + _queuedCalories;
  double get dailyTargetCalories => _dailyTargetCalories;
  List<FoodServing> get logQueue => _logQueue;

  // Methods to update these values will be added later
  void updateLoggedCalories(double calories) {
    _loggedCalories = calories;
    notifyListeners();
  }

  void updateQueuedCalories(double calories) {
    _queuedCalories = calories;
    notifyListeners();
  }

  void updateDailyTargetCalories(double target) {
    _dailyTargetCalories = target;
    notifyListeners();
  }

  void addFoodToQueue(FoodServing serving) {
    _logQueue.add(serving);
    _recalculateQueuedCalories();
    notifyListeners();
  }

  void removeFoodFromQueue(FoodServing serving) {
    _logQueue.remove(serving);
    _recalculateQueuedCalories();
    notifyListeners();
  }

  void clearQueue() {
    _logQueue.clear();
    _recalculateQueuedCalories();
    notifyListeners();
  }

  void _recalculateQueuedCalories() {
    _queuedCalories = _logQueue.fold(0.0, (sum, serving) {
      final food = serving.food;
      final unit = food.units.firstWhere(
        (u) => u.name == serving.servingUnit,
        orElse: () => food.units.first, // Fallback, though should not happen
      );
      final caloriesForServing =
          food.calories * unit.grams * serving.servingSize;
      return sum + caloriesForServing;
    });
  }
}
