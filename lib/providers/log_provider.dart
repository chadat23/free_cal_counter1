import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food.dart';

class LogProvider extends ChangeNotifier {
  // Placeholder values for now
  double _loggedCalories = 0.0;
  double _queuedCalories = 0.0;
  double _dailyTargetCalories = 2000.0; // Example target
  final List<Food> _logQueue = [];

  double get loggedCalories => _loggedCalories;
  double get queuedCalories => _queuedCalories;
  double get totalCalories => _loggedCalories + _queuedCalories;
  double get dailyTargetCalories => _dailyTargetCalories;
  List<Food> get logQueue => _logQueue;

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

  void addFoodToQueue(Food food) {
    _logQueue.add(food);
    _queuedCalories += food.calories;
    notifyListeners();
  }

  void removeFoodFromQueue(Food food) {
    _logQueue.remove(food);
    _queuedCalories -= food.calories;
    notifyListeners();
  }

  void clearQueue() {
    _logQueue.clear();
    _queuedCalories = 0.0;
    notifyListeners();
  }
}
