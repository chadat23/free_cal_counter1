import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/screen_background.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenBackground(
      child: Column(
        children: [
          Expanded(child: Center(child: Text('Log Screen'))),
          FoodSearchRibbon(),
        ],
      ),
    );
  }
}
