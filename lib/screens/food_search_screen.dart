
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food.dart';
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
            title: Row(
              children: [
                Text(
                  '${logProvider.totalCalories.toInt()} / ${logProvider.dailyTargetCalories.toInt()}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    height: 30.0, // Fixed height
                    decoration: BoxDecoration(
                      color: Colors.grey[700], // Different background color
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: logProvider.logQueue
                            .map((food) => Text(food.emoji, style: const TextStyle(fontSize: 20)))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down), // Down arrow
              ],
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
