import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart' as model;
import 'package:free_cal_counter1/models/logged_food.dart' as model;
import 'package:free_cal_counter1/models/recipe.dart' as model;
import 'package:free_cal_counter1/models/daily_macro_stats.dart';
import 'package:free_cal_counter1/services/database_service.dart';

class LogProvider extends ChangeNotifier {
  // State for macros
  double _loggedCalories = 0.0;
  double _loggedProtein = 0.0;
  double _loggedFat = 0.0;
  double _loggedCarbs = 0.0;
  double _loggedFiber = 0.0;

  double _queuedCalories = 0.0;
  double _queuedProtein = 0.0;
  double _queuedFat = 0.0;
  double _queuedCarbs = 0.0;
  double _queuedFiber = 0.0;

  double _dailyTargetCalories = 2000.0;
  double _dailyTargetProtein = 150.0;
  double _dailyTargetFat = 70.0;
  double _dailyTargetCarbs = 250.0;
  double _dailyTargetFiber = 30.0;

  final List<model.FoodPortion> _logQueue = [];
  List<model.LoggedFood> _loggedFoods = [];

  // Getters
  double get loggedCalories => _loggedCalories;
  double get queuedCalories => _queuedCalories;
  double get queuedProtein => _queuedProtein;
  double get queuedFat => _queuedFat;
  double get queuedCarbs => _queuedCarbs;
  double get queuedFiber => _queuedFiber;

  double get totalCalories => _loggedCalories + _queuedCalories;
  double get totalProtein => _loggedProtein + _queuedProtein;
  double get totalFat => _loggedFat + _queuedFat;
  double get totalCarbs => _loggedCarbs + _queuedCarbs;
  double get totalFiber => _loggedFiber + _queuedFiber;

  double get dailyTargetCalories => _dailyTargetCalories;
  double get dailyTargetProtein => _dailyTargetProtein;
  double get dailyTargetFat => _dailyTargetFat;
  double get dailyTargetCarbs => _dailyTargetCarbs;
  double get dailyTargetFiber => _dailyTargetFiber;

  List<model.FoodPortion> get logQueue => _logQueue;
  List<model.LoggedFood> get loggedFoods => _loggedFoods;

  // Queue Operations
  void addFoodToQueue(model.FoodPortion serving) {
    _logQueue.add(serving);
    _recalculateQueuedMacros();
    notifyListeners();
  }

  void addRecipeToQueue(model.Recipe recipe, {double quantity = 1.0}) {
    if (recipe.isTemplate) {
      // Decompose: Add all items recursively
      for (final item in recipe.items) {
        if (item.isFood) {
          addFoodToQueue(
            model.FoodPortion(
              food: item.food!,
              grams: item.grams * quantity,
              unit: item.unit,
            ),
          );
        } else if (item.isRecipe) {
          // Recursive decomposition
          addRecipeToQueue(
            item.recipe!,
            quantity: (item.grams / item.recipe!.gramsPerPortion) * quantity,
          );
        }
      }
    } else {
      // Not a template: Add as a single item (frozen)
      final food = recipe.toFood();
      addFoodToQueue(
        model.FoodPortion(
          food: food,
          grams: recipe.gramsPerPortion * quantity,
          unit: recipe.portionName,
        ),
      );
    }
  }

  void updateFoodInQueue(int index, model.FoodPortion newPortion) {
    if (index >= 0 && index < _logQueue.length) {
      _logQueue[index] = newPortion;
      _recalculateQueuedMacros();
      notifyListeners();
    }
  }

  void removeFoodFromQueue(model.FoodPortion serving) {
    _logQueue.remove(serving);
    _recalculateQueuedMacros();
    notifyListeners();
  }

  void clearQueue() {
    _logQueue.clear();
    _recalculateQueuedMacros();
    notifyListeners();
  }

  Future<void> logQueueToDatabase() async {
    if (_logQueue.isEmpty) return;

    await DatabaseService.instance.logPortions(_logQueue, DateTime.now());
    clearQueue();
    await loadLoggedFoodsForDate(DateTime.now());
  }

  // Database Operations
  Future<void> loadLoggedFoodsForDate(DateTime date) async {
    _loggedFoods = await DatabaseService.instance.getLoggedPortionsForDate(
      date,
    );
    _recalculateLoggedMacros();
    notifyListeners();
  }

  Future<void> deleteLoggedFood(model.LoggedFood food) async {
    if (food.id == null) return;

    await DatabaseService.instance.deleteLoggedPortion(food.id!);

    _loggedFoods.removeWhere((item) => item.id == food.id);
    _recalculateLoggedMacros();
    notifyListeners();
  }

  // Internal Calculation Logic
  void _recalculateQueuedMacros() {
    _queuedCalories = 0.0;
    _queuedProtein = 0.0;
    _queuedFat = 0.0;
    _queuedCarbs = 0.0;
    _queuedFiber = 0.0;

    for (var serving in _logQueue) {
      final food = serving.food;
      _queuedCalories += food.calories * serving.grams;
      _queuedProtein += food.protein * serving.grams;
      _queuedFat += food.fat * serving.grams;
      _queuedCarbs += food.carbs * serving.grams;
      _queuedFiber += food.fiber * serving.grams;
    }
  }

  void _recalculateLoggedMacros() {
    _loggedCalories = 0.0;
    _loggedProtein = 0.0;
    _loggedFat = 0.0;
    _loggedCarbs = 0.0;
    _loggedFiber = 0.0;

    for (var item in _loggedFoods) {
      final food = item.portion.food;
      _loggedCalories += food.calories * item.portion.grams;
      _loggedProtein += food.protein * item.portion.grams;
      _loggedFat += food.fat * item.portion.grams;
      _loggedCarbs += food.carbs * item.portion.grams;
      _loggedFiber += food.fiber * item.portion.grams;
    }
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
