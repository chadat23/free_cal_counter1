import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/goal_settings.dart';
import 'package:free_cal_counter1/models/macro_goals.dart';

void main() {
  group('GoalSettings', () {
    test('toJson and fromJson should be symmetric', () {
      final settings = GoalSettings(
        anchorWeight: 80.0,
        maintenanceCaloriesStart: 2500,
        proteinTarget: 160,
        fatTarget: 70,
        mode: GoalMode.lose,
        fixedDelta: 500,
        lastTargetUpdate: DateTime(2023, 10, 1),
        useMetric: true,
      );

      final json = settings.toJson();
      final decoded = GoalSettings.fromJson(json);

      expect(decoded.anchorWeight, settings.anchorWeight);
      expect(
        decoded.maintenanceCaloriesStart,
        settings.maintenanceCaloriesStart,
      );
      expect(decoded.proteinTarget, settings.proteinTarget);
      expect(decoded.fatTarget, settings.fatTarget);
      expect(decoded.mode, settings.mode);
      expect(decoded.fixedDelta, settings.fixedDelta);
      expect(
        decoded.lastTargetUpdate.millisecondsSinceEpoch,
        settings.lastTargetUpdate.millisecondsSinceEpoch,
      );
    });

    test('default settings should be correct', () {
      final settings = GoalSettings.defaultSettings();
      expect(settings.mode, GoalMode.maintain);
      expect(settings.anchorWeight, 0.0);
    });
  });

  group('MacroGoals', () {
    test('toJson and fromJson should be symmetric', () {
      final goals = MacroGoals(
        calories: 2000,
        protein: 150,
        fat: 60,
        carbs: 215,
        fiber: 30,
      );

      final json = goals.toJson();
      final decoded = MacroGoals.fromJson(json);

      expect(decoded.calories, goals.calories);
      expect(decoded.protein, goals.protein);
      expect(decoded.fat, goals.fat);
      expect(decoded.carbs, goals.carbs);
      expect(decoded.fiber, goals.fiber);
    });
  });
}
