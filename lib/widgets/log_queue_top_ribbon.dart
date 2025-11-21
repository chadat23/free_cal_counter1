import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food_portion.dart';

class LogQueueTopRibbon extends StatelessWidget {
  final IconData arrowDirection;
  final VoidCallback onArrowPressed;
  final double totalCalories;
  final double dailyTargetCalories;
  final List<FoodPortion> logQueue;

  const LogQueueTopRibbon({
    super.key,
    required this.arrowDirection,
    required this.onArrowPressed,
    required this.totalCalories,
    required this.dailyTargetCalories,
    required this.logQueue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${totalCalories.toInt()} / ${dailyTargetCalories.toInt()}',
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
                children: logQueue.map((serving) {
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
                    return Text(
                      serving.food.emoji ?? '🍴',
                      style: const TextStyle(fontSize: 20),
                    );
                  }
                }).toList(),
              ),
            ),
          ),
        ),
        IconButton(icon: Icon(arrowDirection), onPressed: onArrowPressed),
      ],
    );
  }
}
