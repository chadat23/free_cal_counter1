import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/meal.dart';
import 'package:free_cal_counter1/widgets/portion_widget.dart';
import 'package:intl/intl.dart';

class MealWidget extends StatelessWidget {
  final Meal meal;

  const MealWidget({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.jm().format(meal.timestamp),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  alignment: WrapAlignment.end,
                  children: [
                    Text('🔥${meal.totalCalories.toInt()}'),
                    Text('P: ${meal.totalProtein.toStringAsFixed(1)}'),
                    Text('F: ${meal.totalFat.toStringAsFixed(1)}'),
                    Text('C: ${meal.totalCarbs.toStringAsFixed(1)}'),
                  ],
                ),
              ],
            ),
            const Divider(),
            ...meal.loggedFoods.asMap().entries.map((entry) {
              final index = entry.key;
              final loggedFood = entry.value;
              return Column(
                children: [
                  PortionWidget(portion: loggedFood.portion),
                  if (index < meal.loggedFoods.length - 1)
                    Divider(color: Theme.of(context).cardColor.withOpacity(0.7), height: 1, indent: 16, endIndent: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
