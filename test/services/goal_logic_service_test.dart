import 'package:flutter_test/flutter_test.dart';
import 'package:free_cal_counter1/models/weight.dart';
import 'package:free_cal_counter1/services/goal_logic_service.dart';

void main() {
  group('GoalLogicService', () {
    test('calculateTrendWeight should return 0 for empty history', () {
      expect(GoalLogicService.calculateTrendWeight([]), 0.0);
    });

    test('calculateTrendWeight should return single weight for one entry', () {
      final history = [Weight(weight: 70.0, date: DateTime(2023, 1, 1))];
      expect(GoalLogicService.calculateTrendWeight(history), 70.0);
    });

    test('calculateTrendWeight should calculate correct EMA', () {
      final history = [
        Weight(weight: 100.0, date: DateTime(2023, 1, 1)),
        Weight(weight: 110.0, date: DateTime(2023, 1, 2)),
      ];
      // alpha = 0.15
      // ema = 0.15 * 110 + (1 - 0.15) * 100
      // ema = 16.5 + 85 = 101.5
      expect(GoalLogicService.calculateTrendWeight(history), 101.5);
    });

    test('calculateTrendHistory should return history of EMAs', () {
      final history = [
        Weight(weight: 100.0, date: DateTime(2023, 1, 1)),
        Weight(weight: 110.0, date: DateTime(2023, 1, 2)),
      ];
      final trends = GoalLogicService.calculateTrendHistory(history);
      expect(trends.length, 2);
      expect(trends[0], 100.0);
      expect(trends[1], 101.5);
    });

    test(
      'calculateMaintenanceDelta should calculate correct calorie shift (lb)',
      () {
        // Gap = 5 lbs. Window = 30 days.
        // 5 / 30 = 0.166... lbs/day
        // 0.166 * 3500 = 583.33...
        final delta = GoalLogicService.calculateMaintenanceDelta(
          anchorWeight: 105.0,
          currentTrendWeight: 100.0,
          isMetric: false,
        );
        expect(delta, closeTo(583.33, 0.01));
      },
    );

    test(
      'calculateMaintenanceDelta should calculate correct calorie shift (kg)',
      () {
        // Gap = 1 kg. Window = 30 days.
        // 1 / 30 = 0.033... kg/day
        // 0.033 * 7716 = 257.2
        final delta = GoalLogicService.calculateMaintenanceDelta(
          anchorWeight: 101.0,
          currentTrendWeight: 100.0,
          isMetric: true,
        );
        expect(delta, closeTo(257.2, 0.01));
      },
    );

    test('calculateMacros should derive carbs correctly', () {
      // Budget = 2000. P = 150 (600 cal). F = 60 (540 cal).
      // Remainder = 2000 - 600 - 540 = 860 cal.
      // Carbs = 860 / 4 = 215g.
      final macros = GoalLogicService.calculateMacros(
        targetCalories: 2000,
        proteinGrams: 150,
        fatGrams: 60,
      );
      expect(macros['carbs'], 215.0);
      expect(macros['protein'], 150.0);
      expect(macros['fat'], 60.0);
    });
  });
}
