import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/nutrition_targets_overview_chart.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
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
        label: '2134',
        subLabel: 'of 2143',
        dailyValues: [0.8, 0.9, 0.85, 0.95, 0.75, 0.8, 1.0],
      ),
      NutritionTarget(
        color: Colors.red,
        value: 159.0,
        maxValue: 141.0,
        label: '145 P',
        subLabel: 'of 141',
        dailyValues: [1.0, 0.9, 0.95, 1.05, 0.85, 0.9, 1.02],
      ),
      NutritionTarget(
        color: Colors.yellow,
        value: 70.0,
        maxValue: 71.0,
        label: '70 F',
        subLabel: 'of 71',
        dailyValues: [0.9, 1.0, 1.05, 0.95, 0.8, 0.85, 0.98],
      ),
      NutritionTarget(
        color: Colors.green,
        value: 241.0,
        maxValue: 233.0,
        label: '241 C',
        subLabel: 'of 233',
        dailyValues: [0.95, 0.85, 0.9, 1.0, 1.05, 0.8, 1.04],
      ),
    ];

    return ScreenBackground(
      appBar: AppBar(
        title: const Text('Overview'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NutritionTargetsOverviewChart(nutritionData: nutritionData),
          ),
        ],
      ),
    );
  }
}
