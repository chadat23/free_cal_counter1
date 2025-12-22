import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/widgets/food_search_ribbon.dart';
import 'package:free_cal_counter1/widgets/search/search_mode_tabs.dart';
import 'package:free_cal_counter1/models/recipe_item.dart';
import 'package:free_cal_counter1/screens/portion_edit_screen.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/widgets/food_search_result_tile.dart';

class RecipeIngredientSearchScreen extends StatefulWidget {
  const RecipeIngredientSearchScreen({super.key});

  @override
  State<RecipeIngredientSearchScreen> createState() =>
      _RecipeIngredientSearchScreenState();
}

class _RecipeIngredientSearchScreenState
    extends State<RecipeIngredientSearchScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Ingredient')),
      body: Consumer<FoodSearchProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              const SearchModeTabs(),
              Expanded(child: _buildSearchResults(provider)),
            ],
          );
        },
      ),
      bottomNavigationBar: FoodSearchRibbon(
        isSearchActive: true,
        focusNode: _focusNode,
        onChanged: (query) {
          if (query.isNotEmpty) {
            Provider.of<FoodSearchProvider>(
              context,
              listen: false,
            ).textSearch(query);
          }
        },
        onOffSearch: () {
          Provider.of<FoodSearchProvider>(
            context,
            listen: false,
          ).performOffSearch();
        },
      ),
    );
  }

  Widget _buildSearchResults(FoodSearchProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.searchResults.isEmpty) {
      return const Center(child: Text('Search for an ingredient'));
    }

    return ListView.builder(
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final food = provider.searchResults[index];
        return FoodSearchResultTile(
          food: food,
          onAdd: (selectedUnit) {
            final item = RecipeItem(
              id: 0,
              food: food,
              grams: selectedUnit.grams,
              unit: selectedUnit.unit,
            );
            Navigator.pop(context, item);
          },
          onTap: (selectedUnit) async {
            final navigator = Navigator.of(context);
            final portion = await Navigator.push<FoodPortion>(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PortionEditScreen(food: food, initialUnit: selectedUnit),
              ),
            );

            if (portion != null && mounted) {
              final item = RecipeItem(
                id: 0,
                food: portion.food,
                grams: portion.grams,
                unit: portion.unit,
              );
              navigator.pop(item);
            }
          },
        );
      },
    );
  }
}
