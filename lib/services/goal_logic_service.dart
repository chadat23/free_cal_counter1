import 'dart:math';
import 'package:free_cal_counter1/models/weight.dart';

class GoalLogicService {
  /// Calculates the smoothed "Trend Weight" from history.
  /// Uses a simple Exponential Moving Average (EMA).
  static double calculateTrendWeight(List<Weight> history) {
    if (history.isEmpty) return 0.0;
    if (history.length == 1) return history.first.weight;

    // Sort history by date just in case
    final sorted = List<Weight>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Alpha for EMA. 0.1 to 0.2 is typically good for weight.
    // We'll use 0.15 to be responsive but stable.
    const double alpha = 0.15;
    double ema = sorted.first.weight;

    for (var i = 1; i < sorted.length; i++) {
      ema = alpha * sorted[i].weight + (1 - alpha) * ema;
    }

    return ema;
  }

  /// Calculates a list of trend weights corresponding to each entry in history.
  static List<double> calculateTrendHistory(List<Weight> history) {
    if (history.isEmpty) return [];

    final sorted = List<Weight>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));

    const double alpha = 0.15;
    double ema = sorted.first.weight;
    final trends = <double>[ema];

    for (var i = 1; i < sorted.length; i++) {
      ema = alpha * sorted[i].weight + (1 - alpha) * ema;
      trends.add(ema);
    }

    return trends;
  }

  /// Calculates the calorie delta for Maintenance mode based on drift.
  /// Formula: (Anchor Weight - Current Trend Weight) / 30 * 3500
  /// This assumes a 30-day correction window and ~3500 calories per pound of mass.
  static double calculateMaintenanceDelta({
    required double anchorWeight,
    required double currentTrendWeight,
    bool isMetric = false, // If true, assume kg and use 7716 cal/kg
  }) {
    final weightGap = anchorWeight - currentTrendWeight;
    final dailyMassChangeRequired = weightGap / 30.0;

    final multiplier = isMetric ? 7716.0 : 3500.0;
    return dailyMassChangeRequired * multiplier;
  }

  /// Calculates the macro targets based on a calorie budget and fixed P/F targets.
  /// Carbs are the remainder.
  static Map<String, double> calculateMacros({
    required double targetCalories,
    required double proteinGrams,
    required double fatGrams,
  }) {
    final proteinCalories = proteinGrams * 4.0;
    final fatCalories = fatGrams * 9.0;

    final remainingCalories = targetCalories - proteinCalories - fatCalories;
    final carbGrams = max(0.0, remainingCalories / 4.0);

    return {
      'calories': targetCalories,
      'protein': proteinGrams,
      'fat': fatGrams,
      'carbs': carbGrams,
    };
  }
}
