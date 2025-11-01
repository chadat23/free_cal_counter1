import 'package:flutter/material.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/widgets/log_queue_top_ribbon.dart';
import 'package:provider/provider.dart';

class LogQueueScreen extends StatelessWidget {
  const LogQueueScreen({super.key});

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
            title: LogQueueTopRibbon(
              arrowDirection: Icons.arrow_drop_up,
              onArrowPressed: () {
                Navigator.pop(context);
              },
              totalCalories: logProvider.totalCalories,
              dailyTargetCalories: logProvider.dailyTargetCalories,
              logQueue: logProvider.logQueue,
            ),
          ),
          body: ListView.builder(
            itemCount: logProvider.logQueue.length,
            itemBuilder: (context, index) {
              final food = logProvider.logQueue[index];
              return ListTile(
                leading: Text(food.emoji, style: const TextStyle(fontSize: 24)),
                title: Text(food.name),
                subtitle: Text('${food.calories} kcal'),
              );
            },
          ),
          bottomNavigationBar: const FoodSearchRibbon(),
        );
      },
    );
  }
}
