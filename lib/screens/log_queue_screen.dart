import 'package:flutter/material.dart';

import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/widgets/discard_dialog.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/widgets/log_queue_top_ribbon.dart';
import 'package:free_cal_counter1/widgets/slidable_serving_widget.dart';
import 'package:free_cal_counter1/screens/serving_edit_screen.dart';
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
              onPressed: () async {
                if (logProvider.logQueue.isNotEmpty) {
                  final discard = await showDiscardDialog(context);
                  if (discard == true) {
                    logProvider.clearQueue();
                    Future.microtask(() {
                      if (context.mounted) {
                        final navProvider = Provider.of<NavigationProvider>(
                          context,
                          listen: false,
                        );
                        navProvider.changeTab(0);
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }
                    });
                  }
                } else {
                  Future.microtask(() {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  });
                }
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
              final foodServing = logProvider.logQueue[index];
              return SlidableServingWidget(
                serving: foodServing,
                onDelete: () {
                  logProvider.removeFoodFromQueue(foodServing);
                },
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServingEditScreen(
                        food: foodServing.food,
                        initialUnit: foodServing.food.servings.firstWhere(
                          (s) => s.unit == foodServing.unit,
                          orElse: () => foodServing.food.servings.first,
                        ),
                        initialAmount: foodServing.grams,
                        onUpdate: (newPortion) {
                          logProvider.updateFoodInQueue(index, newPortion);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
          bottomNavigationBar: const FoodSearchRibbon(),
        );
      },
    );
  }
}
