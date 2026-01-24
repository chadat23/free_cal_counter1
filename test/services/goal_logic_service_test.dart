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
      expect(macros['fat'], 60.0);
    });

    test('calculateKalmanTDEE should handle stable weight and intake', () {
      final weights = List.generate(30, (_) => 100.0);
      final intakes = List.generate(30, (_) => 2000.0);
      final results = GoalLogicService.calculateKalmanTDEE(
        weights: weights,
        intakes: intakes,
        initialTDEE: 2000.0,
        initialWeight: 100.0,
      );

      expect(results.length, 30);
      // Should stay around 2000
      expect(results.last, closeTo(2000.0, 10.0));
    });

    test(
      'calculateKalmanTDEE should handle increasing weight with high intake',
      () {
        final weights = List.generate(
          30,
          (i) => 100.0 + i * 0.1,
        ); // gaining 0.1lb/day
        final intakes = List.generate(30, (_) => 2500.0);
        // Gain of 0.1lb/day means surplus of 350cal.
        // If intake is 2500, TDEE should be ~2150.
        final results = GoalLogicService.calculateKalmanTDEE(
          weights: weights,
          intakes: intakes,
          initialTDEE: 2500.0,
          initialWeight: 100.0,
        );

        expect(results.last, closeTo(2150.0, 100.0));
      },
    );

    test('calculateKalmanTDEE should handle missing weight data', () {
      final weights = List.generate(30, (i) => i % 7 == 0 ? 100.0 : 0.0);
      final intakes = List.generate(30, (_) => 2000.0);
      final results = GoalLogicService.calculateKalmanTDEE(
        weights: weights,
        intakes: intakes,
        initialTDEE: 2000.0,
        initialWeight: 100.0,
      );

      expect(results.length, 30);
      expect(results.last, closeTo(2000.0, 50.0));
    });
  });
}
