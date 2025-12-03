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

  void addFoodToQueue(FoodPortion serving) {
    _logQueue.add(serving);
    _recalculateQueuedCalories();
    notifyListeners();
  }

  void updateFoodInQueue(int index, FoodPortion newPortion) {
    if (index >= 0 && index < _logQueue.length) {
      _logQueue[index] = newPortion;
      _recalculateQueuedCalories();
      notifyListeners();
    }
  }

  void removeFoodFromQueue(FoodPortion serving) {
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
      final unit = food.servings.firstWhere(
        (u) => u.unit == serving.unit,
        orElse: () => throw StateError(
          'Data integrity error: Unit ${serving.unit} missing from ${food.name}',
        ),
      );
      final caloriesForServing = food.calories * unit.grams * serving.grams;
      return sum + caloriesForServing;
    });
  }
}
