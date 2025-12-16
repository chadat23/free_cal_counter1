import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/logged_food.dart';
import 'package:free_cal_counter1/models/daily_macro_stats.dart';
import 'package:free_cal_counter1/services/database_service.dart';

class LogProvider extends ChangeNotifier {
  // Placeholder values for now
  double _loggedCalories = 0.0;
  double _queuedCalories = 0.0;
  double _dailyTargetCalories = 2000.0; // Example target
  final List<FoodPortion> _logQueue = [];
  List<LoggedFood> _loggedFoods = [];

  double get loggedCalories => _loggedCalories;
  double get queuedCalories => _queuedCalories;
  double get totalCalories => _loggedCalories + _queuedCalories;
  double get dailyTargetCalories => _dailyTargetCalories;
  List<FoodPortion> get logQueue => _logQueue;
  List<LoggedFood> get loggedFoods => _loggedFoods;

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

  Future<void> logQueueToDatabase() async {
    if (_logQueue.isEmpty) return;

    await DatabaseService.instance.logPortions(_logQueue, DateTime.now());
    clearQueue();
    await loadLoggedFoodsForDate(DateTime.now());
  }

  Future<void> loadLoggedFoodsForDate(DateTime date) async {
    _loggedFoods = await DatabaseService.instance.getLoggedPortionsForDate(
      date,
    );
    _recalculateLoggedCalories();
    notifyListeners();
  }

  Future<void> deleteLoggedFood(LoggedFood food) async {
    if (food.id == null) return;

    await DatabaseService.instance.deleteLoggedPortion(food.id!);

    _loggedFoods.removeWhere((item) => item.id == food.id);
    _recalculateLoggedCalories();
    notifyListeners();
  }

  void _recalculateQueuedCalories() {
    _queuedCalories = _logQueue.fold(0.0, (sum, serving) {
      final food = serving.food;
      final caloriesForServing = food.calories * serving.grams;
      return sum + caloriesForServing;
    });
  }

  void _recalculateLoggedCalories() {
    _loggedCalories = _loggedFoods.fold(0.0, (sum, item) {
      final food = item.portion.food;
      final caloriesForServing = food.calories * item.portion.grams;
      return sum + caloriesForServing;
    });
  }

  Future<List<DailyMacroStats>> getDailyMacroStats(
    DateTime start,
    DateTime end,
  ) async {
    final dtos = await DatabaseService.instance.getLoggedMacrosForDateRange(
      start,
      end,
    );
    return DailyMacroStats.fromDTOS(dtos, start, end);
  }

  Future<DailyMacroStats> getTodayStats() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final stats = await getDailyMacroStats(today, today);
    return stats.first;
  }
}
