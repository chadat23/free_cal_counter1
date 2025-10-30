import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/nutrition_targets_overview_chart.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NutritionTarget> nutritionData = [
      NutritionTarget(
        color: Colors.blue,
        value: 2134.0,
        maxValue: 2143.0,
        macroLabel: '🔥',
        unitLabel: '',
        dailyValues: [
          2300.4,
          1928.7,
          1821.55,
          2035.85,
          1607.25,
          1714.4,
          2143.0,
        ],
      ),
      NutritionTarget(
        color: Colors.red,
        value: 159.0,
        maxValue: 141.0,
        macroLabel: 'P',
        unitLabel: 'g',
        dailyValues: [141.0, 126.9, 133.95, 148.05, 119.85, 126.9, 143.82],
      ),
      NutritionTarget(
        color: Colors.yellow,
        value: 70.0,
        maxValue: 71.0,
        macroLabel: 'F',
        unitLabel: 'g',
        dailyValues: [63.9, 71.0, 74.55, 67.45, 56.8, 60.35, 69.58],
      ),
      NutritionTarget(
        color: Colors.green,
        value: 241.0,
        maxValue: 233.0,
        macroLabel: 'C',
        unitLabel: 'g',
        dailyValues: [221.35, 198.05, 209.7, 233.0, 244.65, 186.4, 242.32],
      ),
    ];

    return ScreenBackground(
      appBar: AppBar(
        title: const Text('Overview'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NutritionTargetsOverviewChart(
                    nutritionData: nutritionData,
                  ),
                ),
              ],
            ),
          ),
          const FoodSearchRibbon(),
        ],
      ),
    );
  }
}
