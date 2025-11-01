
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_router.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/widgets/discard_dialog.dart';
import 'package:free_cal_counter1/widgets/log_queue_top_ribbon.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';

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
              onPressed: () async {
                final logProvider = Provider.of<LogProvider>(context, listen: false);
                final navProvider = Provider.of<NavigationProvider>(context, listen: false);
                if (logProvider.logQueue.isNotEmpty) {
                  final discard = await showDiscardDialog(context);
                  if (discard == true) {
                    logProvider.clearQueue();
                    navProvider.changeTab(0);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                } else {
                  navProvider.changeTab(0);
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
            ),
            title: LogQueueTopRibbon(
              arrowDirection: Icons.arrow_drop_down,
              onArrowPressed: () {
                Navigator.pushNamed(context, AppRouter.logQueueRoute);
              },
              totalCalories: logProvider.totalCalories,
              dailyTargetCalories: logProvider.dailyTargetCalories,
              logQueue: logProvider.logQueue,
            ),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                // Placeholder to add a food to the queue
                final food = Food(
                  id: 1,
                  name: 'Apple',
                  emoji: '🍎',
                  calories: 52,
                  protein: 0.3,
                  fat: 0.2,
                  carbs: 14,
                );
                logProvider.addFoodToQueue(food);
              },
              child: const Text('Add Apple to Queue'),
            ),
          ),
          bottomNavigationBar: const FoodSearchRibbon(),
        );
      },
    );
  }
}
