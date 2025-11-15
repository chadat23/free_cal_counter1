import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';

class LogProvider extends ChangeNotifier {
  // Placeholder values for now
  double _loggedCalories = 0.0;
  double _queuedCalories = 0.0;
  double _dailyTargetCalories = 2000.0; // Example target
  final List<FoodPortion> _logQueue = [];

  double get loggedCalories => _loggedCalories;
  double get queuedCalories => _queuedCalories;
  double get totalCalories => _loggedCalories + _queuedCalories;
  double get dailyTargetCalories => _dailyTargetCalories;
  List<FoodPortion> get logQueue => _logQueue;

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

  void addFoodToQueue(FoodPortion portion) {
    _logQueue.add(portion);
    _recalculateQueuedCalories();
    notifyListeners();
  }

  void removeFoodFromQueue(FoodPortion portion) {
    _logQueue.remove(portion);
    _recalculateQueuedCalories();
    notifyListeners();
  }

  void clearQueue() {
    _logQueue.clear();
    _recalculateQueuedCalories();
    notifyListeners();
  }

  void _recalculateQueuedCalories() {
    _queuedCalories = _logQueue.fold(0.0, (sum, portion) {
      final food = portion.food;
      final unit = food.units.firstWhere(
        (u) => u.name == portion.servingUnit,
        orElse: () => food.units.first, // Fallback, though should not happen
      );
      final caloriesForPortion = food.calories * unit.grams * portion.servingSize;
      return sum + caloriesForPortion;
    });
  }
}
