import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:free_cal_counter1/widgets/horizontal_mini_bar_chart.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';

class LogQueueTopRibbon extends StatelessWidget {
  final IconData arrowDirection;
  final VoidCallback onArrowPressed;
  final LogProvider logProvider;

  const LogQueueTopRibbon({
    super.key,
    required this.arrowDirection,
    required this.onArrowPressed,
    required this.logProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Helper to create targets for the charts
    NutritionTarget createTarget(
      String label,
      double value,
      double target,
      Color color,
    ) {
      return NutritionTarget(
        color: color,
        thisAmount: value,
        targetAmount: target,
        macroLabel: label,
        unitLabel: label == '🔥' ? '' : 'g',
        dailyAmounts: [],
      );
    }

    final targets = [
      createTarget(
        '🔥',
        logProvider.totalCalories,
        logProvider.dailyTargetCalories,
        Colors.blue,
      ),
      createTarget(
        'P',
        logProvider.totalProtein,
        logProvider.dailyTargetProtein,
        Colors.red,
      ),
      createTarget(
        'F',
        logProvider.totalFat,
        logProvider.dailyTargetFat,
        Colors.orange,
      ),
      createTarget(
        'C',
        logProvider.totalCarbs,
        logProvider.dailyTargetCarbs,
        Colors.green,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min, // Important for AppBar usage
      children: [
        // Row 1: Icons
        Row(
          children: [
            Expanded(
              child: Container(
                height: 30.0,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: logProvider.logQueue.map((serving) {
                      if (serving.food.thumbnail != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: CachedNetworkImage(
                            imageUrl: serving.food.thumbnail!,
                            width: 26,
                            height: 26,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Text(serving.food.emoji ?? '🍴'),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Text(
                            serving.food.emoji ?? '🍴',
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(icon: Icon(arrowDirection), onPressed: onArrowPressed),
          ],
        ),
        const SizedBox(height: 8.0),
        // Row 2: Charts
        Row(
          children: targets
              .map(
                (target) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: HorizontalMiniBarChart(nutritionTarget: target),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
