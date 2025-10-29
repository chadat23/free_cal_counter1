import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/widgets/mini_bar_chart.dart';

class NutritionTargetsOverviewChart extends StatelessWidget {
  const NutritionTargetsOverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> nutritionData = [
      {
        'color': Colors.blue,
        'value': 2134.0,
        'maxValue': 2143.0,
        'label': '2134',
        'subLabel': 'of 2143',
        'dailyValues': [0.8, 0.9, 0.85, 0.95, 0.75, 0.8, 1.0],
      },
      {
        'color': Colors.red,
        'value': 145.0,
        'maxValue': 141.0,
        'label': '145 P',
        'subLabel': 'of 141',
        'dailyValues': [1.0, 0.9, 0.95, 1.05, 0.85, 0.9, 1.02],
      },
      {
        'color': Colors.yellow,
        'value': 70.0,
        'maxValue': 71.0,
        'label': '70 F',
        'subLabel': 'of 71',
        'dailyValues': [0.9, 1.0, 1.05, 0.95, 0.8, 0.85, 0.98],
      },
      {
        'color': Colors.green,
        'value': 241.0,
        'maxValue': 233.0,
        'label': '241 C',
        'subLabel': 'of 233',
        'dailyValues': [0.95, 0.85, 0.9, 1.0, 1.05, 0.8, 1.04],
      },
    ];

    final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.largeWidgetBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Nutrition & Targets',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Add icon here if needed
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: List.generate(nutritionData.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(height: 40), // Placeholder for alignment
                  );
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(7, (dayIndex) {
                        return Column(
                          children: List.generate(nutritionData.length, (
                            nutrientIndex,
                          ) {
                            final data = nutritionData[nutrientIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: MiniBarChart(
                                value:
                                    data['dailyValues'][dayIndex] *
                                    data['maxValue'],
                                maxValue: data['maxValue'],
                                color: data['color'],
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: weekdays
                          .map(
                            (day) => Text(
                              day,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: nutritionData.map((data) {
                  return SizedBox(
                    height: 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data['label'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          data['subLabel'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Consumed'),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Remaining',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
