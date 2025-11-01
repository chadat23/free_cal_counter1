import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_router.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/navigation_provider.dart';

class FoodSearchRibbon extends StatelessWidget {
  const FoodSearchRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              key: const Key('food_search_text_field'),
              onTap: () {
                Navigator.pushNamed(context, AppRouter.foodSearchRoute);
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search food...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement Globe button functionality (OFF search)
            },
            child: const Icon(Icons.language), // Globe icon
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement Add button functionality
            },
            child: const Text('Log'),
          ),
        ],
      ),
    );
  }
}
