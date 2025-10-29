import 'package:flutter/material.dart';

class FoodSearchRibbon extends StatelessWidget {
  const FoodSearchRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
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
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement Add button functionality
            },
            child: const Text('Search'),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement Globe button functionality (OFF search)
            },
            child: const Icon(Icons.language), // Globe icon
          ),
        ],
      ),
    );
  }
}
