import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/nutrition_targets_overview_chart.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: NutritionTargetsOverviewChart(),
          ),
        ],
      ),
    );
  }
}
