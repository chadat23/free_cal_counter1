import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:free_cal_counter1/widgets/horizontal_mini_bar_chart.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';
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

    final queueOnlyTargets = [
      createTarget(
        '🔥',
        logProvider.queuedCalories,
        logProvider.dailyTargetCalories,
        Colors.blue.withOpacity(0.7),
      ),
      createTarget(
        'P',
        logProvider.queuedProtein,
        logProvider.dailyTargetProtein,
        Colors.red.withOpacity(0.7),
      ),
      createTarget(
        'F',
        logProvider.queuedFat,
        logProvider.dailyTargetFat,
        Colors.orange.withOpacity(0.7),
      ),
      createTarget(
        'C',
        logProvider.queuedCarbs,
        logProvider.dailyTargetCarbs,
        Colors.green.withOpacity(0.7),
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
