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
        thisAmount: 2134.0,
        targetAmount: 2143.0,
        macroLabel: '🔥',
        unitLabel: '',
        dailyAmounts: [
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
        thisAmount: 159.0,
        targetAmount: 141.0,
        macroLabel: 'P',
        unitLabel: 'g',
        dailyAmounts: [141.0, 126.9, 133.95, 148.05, 119.85, 126.9, 143.82],
      ),
      NutritionTarget(
        color: Colors.yellow,
        thisAmount: 70.0,
        targetAmount: 71.0,
        macroLabel: 'F',
        unitLabel: 'g',
        dailyAmounts: [63.9, 71.0, 74.55, 67.45, 56.8, 60.35, 69.58],
      ),
      NutritionTarget(
        color: Colors.green,
        thisAmount: 241.0,
        targetAmount: 233.0,
        macroLabel: 'C',
        unitLabel: 'g',
        dailyAmounts: [221.35, 198.05, 209.7, 233.0, 244.65, 186.4, 242.32],
      ),
      NutritionTarget(
        color: Colors.brown,
        thisAmount: 25.0,
        targetAmount: 30.0,
        macroLabel: 'Fb',
        unitLabel: 'g',
        dailyAmounts: [22.5, 28.0, 31.5, 25.0, 18.0, 29.0, 26.5],
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
