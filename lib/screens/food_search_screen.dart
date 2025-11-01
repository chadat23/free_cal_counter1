
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LogProvider>(
      builder: (context, logProvider, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              '${logProvider.totalCalories.toInt()} / ${logProvider.dailyTargetCalories.toInt()}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          body: const Center(
            child: Text('Food Search Screen'),
          ),
          bottomNavigationBar: const FoodSearchRibbon(),
        );
      },
    );
  }
}
