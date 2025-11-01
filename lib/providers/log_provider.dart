import 'package:flutter/material.dart';

class LogProvider extends ChangeNotifier {
  // Placeholder values for now
  double _loggedCalories = 0.0;
  double _queuedCalories = 0.0;
  double _dailyTargetCalories = 2000.0; // Example target

  double get loggedCalories => _loggedCalories;
  double get queuedCalories => _queuedCalories;
  double get totalCalories => _loggedCalories + _queuedCalories;
  double get dailyTargetCalories => _dailyTargetCalories;

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
}
