import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:free_cal_counter1/widgets/horizontal_mini_bar_chart.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
import 'package:free_cal_counter1/providers/goals_provider.dart';
import 'package:provider/provider.dart';

class LogQueueTopRibbon extends StatelessWidget {
  final IconData arrowDirection;
  final VoidCallback onArrowPressed;
  final LogProvider logProvider;
  final Widget? leading;

  const LogQueueTopRibbon({
    super.key,
    required this.arrowDirection,
    required this.onArrowPressed,
    required this.logProvider,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<GoalsProvider>(context).currentGoals;
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

    final projectedTargets = [
      createTarget(
        '🔥',
        logProvider.totalCalories,
        goals.calories,
        Colors.blue,
      ),
      createTarget('P', logProvider.totalProtein, goals.protein, Colors.red),
      createTarget('F', logProvider.totalFat, goals.fat, Colors.orange),
      createTarget('C', logProvider.totalCarbs, goals.carbs, Colors.green),
      createTarget('Fb', logProvider.totalFiber, goals.fiber, Colors.brown),
    ];

    final queueOnlyTargets = [
      createTarget(
        '🔥',
        logProvider.queuedCalories,
        goals.calories,
        Colors.blue.withValues(alpha: 0.7),
      ),
      createTarget(
        'P',
        logProvider.queuedProtein,
        goals.protein,
        Colors.red.withValues(alpha: 0.7),
      ),
      createTarget(
        'F',
        logProvider.queuedFat,
        goals.fat,
        Colors.orange.withValues(alpha: 0.7),
      ),
      createTarget(
        'C',
        logProvider.queuedCarbs,
        goals.carbs,
        Colors.green.withValues(alpha: 0.7),
      ),
      createTarget(
        'Fb',
        logProvider.queuedFiber,
        goals.fiber,
        Colors.brown.withValues(alpha: 0.7),
      ),
    ];

    Widget buildChartRow(List<NutritionTarget> targets, String label) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 2.0),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Consumer<NavigationProvider>(
            builder: (context, navProvider, child) {
              final notInverted = navProvider.showConsumed;
              return Row(
                children: targets
                    .map(
                      (target) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: HorizontalMiniBarChart(
                            consumed: target.thisAmount,
                            target: target.targetAmount,
                            color: target.color,
                            macroLabel: target.macroLabel,
                            unitLabel: target.unitLabel,
                            notInverted: notInverted,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min, // Important for AppBar usage
      children: [
        // Row 1: Icons
        Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8.0)],
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
        // Row 2: Day's Charts
        buildChartRow(projectedTargets, "Day's Macros (Projected)"),
        const SizedBox(height: 4.0),
        // Row 3: Queue's Charts
        buildChartRow(queueOnlyTargets, "Queue's Macros"),
      ],
    );
  }
}
