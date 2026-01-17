import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/weight.dart';
import 'package:free_cal_counter1/services/database_service.dart';

class WeightProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<Weight> _weights = [];
  bool _isLoading = false;

  WeightProvider({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService.instance;

  List<Weight> get weights => List.unmodifiable(_weights);
  bool get isLoading => _isLoading;

  /// Returns true if a weight has been recorded for today.
  bool get hasWeightToday {
    final now = DateTime.now();
    return _weights.any(
      (w) =>
          w.date.year == now.year &&
          w.date.month == now.month &&
          w.date.day == now.day,
    );
  }

  /// Gets the weight entry for a specific date, if it exists.
  Weight? getWeightForDate(DateTime date) {
    try {
      return _weights.firstWhere(
        (w) =>
            w.date.year == date.year &&
            w.date.month == date.month &&
            w.date.day == date.day,
      );
    } catch (_) {
      return null;
    }
  }

  /// Loads weights for a given date range.
  Future<void> loadWeights(DateTime start, DateTime end) async {
    _isLoading = true;
    notifyListeners();

    try {
      _weights = await _databaseService.getWeightsForRange(start, end);
    } catch (e) {
      debugPrint('Error loading weights: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Saves or updates a weight entry.
  Future<void> saveWeight(double value, DateTime date, {bool? isFasted}) async {
    final existing = getWeightForDate(date);
    final weight = Weight(
      id: existing?.id,
      weight: value,
      date: date,
      isFasted: isFasted ?? existing?.isFasted ?? false,
    );

    try {
      await _databaseService.saveWeight(weight);

      // Update local state: remove existing for same day if any, then add new
      _weights.removeWhere(
        (w) =>
            w.date.year == date.year &&
            w.date.month == date.month &&
            w.date.day == date.day,
      );

      // Find insertion index to maintain sort order by date
      final index = _weights.indexWhere((w) => w.date.isAfter(date));
      if (index == -1) {
        _weights.add(weight);
      } else {
        _weights.insert(index, weight);
      }
    } catch (e) {
      debugPrint('Error saving weight: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Toggles the fasted status for a specific date.
  Future<void> toggleFasted(DateTime date) async {
    final existing = getWeightForDate(date);
    final newValue = !(existing?.isFasted ?? false);

    // If no weight but toggling fasted, we save with current weight or 0.0
    final weightValue = existing?.weight ?? 0.0;

    await saveWeight(weightValue, date, isFasted: newValue);
  }

  /// Deletes a weight entry.
  Future<void> deleteWeight(int id) async {
    try {
      await _databaseService.deleteWeight(id);
      _weights.removeWhere((w) => w.id == id);
    } catch (e) {
      debugPrint('Error deleting weight: $e');
    } finally {
      notifyListeners();
    }
  }
}
