import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/recipe.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/recipe_provider.dart';
import 'package:free_cal_counter1/screens/portion_edit_screen.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/widgets/food_search_result_tile.dart';
import 'package:free_cal_counter1/widgets/search/slidable_recipe_search_result.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/config/app_router.dart';

class RecipeSearchView extends StatefulWidget {
  const RecipeSearchView({super.key});

  @override
  State<RecipeSearchView> createState() => _RecipeSearchViewState();
}

class _RecipeSearchViewState extends State<RecipeSearchView> {
  @override
  void initState() {
    super.initState();
    // Trigger initial search to show all recipes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FoodSearchProvider>(context, listen: false).textSearch('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Create New Recipe'),
            onPressed: () async {
              Provider.of<RecipeProvider>(context, listen: false).reset();
              final saved = await Navigator.pushNamed(
                context,
                AppRouter.recipeEditRoute,
              );
              if (saved == true && context.mounted) {
                // Refresh the search list by searching for current query again
                Provider.of<FoodSearchProvider>(
                  context,
                  listen: false,
                ).textSearch('');
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
        Expanded(
          child: Consumer<FoodSearchProvider>(
            builder: (context, provider, child) {
              final recipes = provider.searchResults
                  .where((food) => food.source == 'recipe')
                  .toList();

              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (recipes.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      const Text(
                        'No recipes found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final food = recipes[index];
                  final db = DatabaseService.instance;
                  final recipeProvider = Provider.of<RecipeProvider>(
                    context,
                    listen: false,
                  );
                  final foodSearchProvider = Provider.of<FoodSearchProvider>(
                    context,
                    listen: false,
                  );

                  return SlidableRecipeSearchResult(
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
                    onEdit: () async {
                      final recipe = await db.getRecipeById(food.id);
                      final isLogged = await db.isRecipeLogged(food.id);
                      if (isLogged) {
                        recipeProvider.prepareVersion(recipe);
                      } else {
                        recipeProvider.loadFromRecipe(recipe);
                      }
                      if (context.mounted) {
                        final saved = await Navigator.pushNamed(
                          context,
                          AppRouter.recipeEditRoute,
                        );
                        if (saved == true) {
                          foodSearchProvider.textSearch('');
                        }
                      }
                    },
                    onCopy: () async {
                      final recipe = await db.getRecipeById(food.id);
                      recipeProvider.prepareCopy(recipe);
                      if (context.mounted) {
                        final saved = await Navigator.pushNamed(
                          context,
                          AppRouter.recipeEditRoute,
                        );
                        if (saved == true) {
                          foodSearchProvider.textSearch('');
                        }
                      }
                    },
                    onDelete: () async {
                      await db.deleteRecipe(food.id);
                      foodSearchProvider.textSearch('');
                    },
                    onDecompose: () async {
                      final recipe = await db.getRecipeById(food.id);
                      // Force decomposition by creating a template copy
                      final templateRecipe = Recipe(
                        id: recipe.id,
                        name: recipe.name,
                        servingsCreated: recipe.servingsCreated,
                        finalWeightGrams: recipe.finalWeightGrams,
                        portionName: recipe.portionName,
                        notes: recipe.notes,
                        isTemplate: true, // Force true
                        hidden: recipe.hidden,
                        parentId: recipe.parentId,
                        createdTimestamp: recipe.createdTimestamp,
                        items: recipe.items,
                        categories: recipe.categories,
                      );
                      if (context.mounted) {
                        Provider.of<LogProvider>(
                          context,
                          listen: false,
                        ).addRecipeToQueue(templateRecipe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Decomposed ${recipe.name} into Log Queue',
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
