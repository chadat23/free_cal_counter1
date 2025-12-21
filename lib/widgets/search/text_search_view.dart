import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/widgets/food_search_result_tile.dart';
import 'package:free_cal_counter1/screens/portion_edit_screen.dart';

class TextSearchView extends StatelessWidget {
  const TextSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodSearchProvider>(
      builder: (context, foodSearchProvider, child) {
        if (foodSearchProvider.errorMessage != null) {
          return Center(
            child: Text(
              foodSearchProvider.errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (foodSearchProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (foodSearchProvider.searchResults.isEmpty) {
          return const Center(child: Text('Search for a food to begin'));
        }

        return ListView.builder(
          itemCount: foodSearchProvider.searchResults.length,
          itemBuilder: (context, index) {
            final food = foodSearchProvider.searchResults[index];
            return FoodSearchResultTile(
              key: ValueKey(food.id),
              food: food,
              onTap: (selectedUnit) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PortionEditScreen(
                      food: food,
                      initialUnit: selectedUnit,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
