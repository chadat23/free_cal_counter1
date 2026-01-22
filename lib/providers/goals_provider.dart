import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:free_cal_counter1/models/goal_settings.dart';
import 'package:free_cal_counter1/models/macro_goals.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/goal_logic_service.dart';

class GoalsProvider extends ChangeNotifier {
  static const String _settingsKey = 'goal_settings';
  static const String _targetsKey = 'macro_targets';

  GoalSettings _settings = GoalSettings.defaultSettings();
  MacroGoals? _currentGoals;
  bool _isLoading = true;
  bool _showUpdateNotification = false;

  final DatabaseService _databaseService;

  GoalsProvider({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService.instance {
    _loadFromPrefs();
  }

  // Getters
  // Getters
  GoalSettings get settings => _settings;
  MacroGoals get currentGoals => _currentGoals ?? MacroGoals.hardcoded();
  bool get isLoading => _isLoading;
  bool get showUpdateNotification => _showUpdateNotification;
  bool get isGoalsSet => _settings.isSet;

  void dismissNotification() {
    _showUpdateNotification = false;
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final settingsJson = prefs.getString(_settingsKey);
      if (settingsJson != null) {
        _settings = GoalSettings.fromJson(jsonDecode(settingsJson));
      }

      final targetsJson = prefs.getString(_targetsKey);
      if (targetsJson != null) {
        _currentGoals = MacroGoals.fromJson(jsonDecode(targetsJson));
      } else {
        _currentGoals = MacroGoals.hardcoded();
      }

      // After loading, check if a weekly update is due
      // Only check if goals are actually set
      if (_settings.isSet) {
        await checkWeeklyUpdate();
      }
    } catch (e) {
      debugPrint('Error loading goal settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSettings(GoalSettings newSettings) async {
    // Ensure we mark them as set when saving
    _settings = GoalSettings(
      anchorWeight: newSettings.anchorWeight,
      maintenanceCaloriesStart: newSettings.maintenanceCaloriesStart,
      proteinTarget: newSettings.proteinTarget,
      fatTarget: newSettings.fatTarget,
      mode: newSettings.mode,
      fixedDelta: newSettings.fixedDelta,
      lastTargetUpdate: newSettings.lastTargetUpdate,
      useMetric: newSettings.useMetric,
      isSet: true,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(_settings.toJson()));

    // Changing settings might require immediate recalculation of targets
    await recalculateTargets();
    notifyListeners();
  }

  /// Checks if today is Monday and if we need to update the weekly targets.
  Future<void> checkWeeklyUpdate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (now.weekday == DateTime.monday) {
      final lastUpdate = DateTime(
        _settings.lastTargetUpdate.year,
        _settings.lastTargetUpdate.month,
        _settings.lastTargetUpdate.day,
      );

      if (today.isAfter(lastUpdate)) {
        await recalculateTargets();
        _showUpdateNotification = true;
      }
    }
  }

  /// The core calculation engine for dynamic macro targets.
  Future<void> recalculateTargets() async {
    // 1. Fetch weight history for trend calculation
    final now = DateTime.now();
    // We need at least some history. 30 days is the correction window.
    final history = await _databaseService.getWeightsForRange(
      now.subtract(
        const Duration(days: 90),
      ), // Get up to 90 days for stable EMA
      now,
    );

    double targetCalories = _settings.maintenanceCaloriesStart;

    if (history.isNotEmpty) {
      final trendWeight = GoalLogicService.calculateTrendWeight(history);

      double delta = 0.0;
      if (_settings.mode == GoalMode.maintain) {
        // Dynamic drift correction
        delta = GoalLogicService.calculateMaintenanceDelta(
          anchorWeight: _settings.anchorWeight,
          currentTrendWeight: trendWeight,
          isMetric: _settings.useMetric,
        );
      } else {
        // Fixed delta for Gain/Lose
        delta = _settings.fixedDelta;
        if (_settings.mode == GoalMode.lose) {
          delta = -delta.abs();
        } else {
          delta = delta.abs();
        }
      }

      targetCalories += delta;
    }

    // 2. Derive macros
    final macros = GoalLogicService.calculateMacros(
      targetCalories: targetCalories,
      proteinGrams: _settings.proteinTarget,
      fatGrams: _settings.fatTarget,
    );

    _currentGoals = MacroGoals(
      calories: macros['calories']!,
      protein: macros['protein']!,
      fat: macros['fat']!,
      carbs: macros['carbs']!,
    );

    // 3. Persist results and update timestamp
    _settings = GoalSettings(
      anchorWeight: _settings.anchorWeight,
      maintenanceCaloriesStart: _settings.maintenanceCaloriesStart,
      proteinTarget: _settings.proteinTarget,
      fatTarget: _settings.fatTarget,
      mode: _settings.mode,
      fixedDelta: _settings.fixedDelta,
      lastTargetUpdate: DateTime.now(),
      useMetric: _settings.useMetric,
      isSet: true,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(_settings.toJson()));
    await prefs.setString(_targetsKey, jsonEncode(_currentGoals!.toJson()));

    notifyListeners();
  }
}
