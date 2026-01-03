import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/search_provider.dart';
import 'package:free_cal_counter1/models/food_portion.dart' as model_portion;
import 'package:free_cal_counter1/models/quantity_edit_config.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/screens/quantity_edit_screen.dart';
import 'package:free_cal_counter1/models/search_config.dart';
import 'package:free_cal_counter1/widgets/search/slidable_search_result.dart';

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
            final logProvider = Provider.of<LogProvider>(context);
            final isUpdate = logProvider.logQueue.any(
              (p) =>
                  p.food.id == food.id &&
                  p.food.source == food.source &&
                  food.source != 'recipe',
            );

            return SlidableSearchResult(
              key: ValueKey('${food.id}_${food.source}'),
              food: food,
              isUpdate: isUpdate,
              note: food.usageNote,
              onAdd: (selectedUnit) {
                final portion = model_portion.FoodPortion(
                  food: food,
                  grams: selectedUnit.grams,
                  unit: selectedUnit.unit,
                );
                if (config.onSaveOverride != null) {
                  config.onSaveOverride!(portion);
                } else {
                  Provider.of<LogProvider>(
                    context,
                    listen: false,
                  ).addFoodToQueue(portion);
                }
              },
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
                            // First pop closes QuantityEditScreen
                            Navigator.pop(context);
                            // Second pop closes SearchScreen via onSaveOverride
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
              onEdit: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Food Edit Screen not yet implemented'),
                  ),
                );
              },
              onCopy: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Food Copy not yet implemented'),
                  ),
                );
              },
              onDelete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Food Delete not yet implemented'),
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
