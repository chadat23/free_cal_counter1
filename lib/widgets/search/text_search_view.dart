import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/search_provider.dart';
import 'package:free_cal_counter1/widgets/search_result_tile.dart';
import 'package:free_cal_counter1/models/food_portion.dart' as model_portion;
import 'package:free_cal_counter1/models/quantity_edit_config.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/screens/quantity_edit_screen.dart';

import 'package:free_cal_counter1/models/search_config.dart';

class TextSearchView extends StatelessWidget {
  final SearchConfig config;
  const TextSearchView({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        if (searchProvider.errorMessage != null) {
          return Center(
            child: Text(
              searchProvider.errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (searchProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (searchProvider.searchResults.isEmpty) {
          return const Center(child: Text('Search for a food to begin'));
        }

        return ListView.builder(
          itemCount: searchProvider.searchResults.length,
          itemBuilder: (context, index) {
            final food = searchProvider.searchResults[index];
            return SearchResultTile(
              key: ValueKey(food.id),
              food: food,
              onTap: (selectedUnit) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuantityEditScreen(
                      config: QuantityEditConfig(
                        context: config.context,
                        food: food,
                        initialUnit: selectedUnit.unit,
                        initialQuantity: selectedUnit.quantity,
                        onSave: (grams, unit) {
                          final portion = model_portion.FoodPortion(
                            food: food,
                            grams: grams,
                            unit: unit,
                          );
                          if (config.onSaveOverride != null) {
                            config.onSaveOverride!(portion);
                          } else {
                            Provider.of<LogProvider>(
                              context,
                              listen: false,
                            ).addFoodToQueue(portion);
                            Navigator.pop(context);
                          }
                        },
                      ),
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
