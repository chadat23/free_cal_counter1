import 'package:flutter/material.dart';
import 'package:free_cal_counter1/providers/search_provider.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/recipe_provider.dart';
import 'package:free_cal_counter1/models/food_portion.dart' as model_portion;
import 'package:free_cal_counter1/models/recipe.dart' as model_recipe;
import 'package:free_cal_counter1/models/category.dart' as model_cat;
import 'package:free_cal_counter1/models/quantity_edit_config.dart';
import 'package:free_cal_counter1/screens/quantity_edit_screen.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/widgets/search/slidable_recipe_search_result.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/config/app_router.dart';
import 'package:free_cal_counter1/models/search_config.dart';

class RecipeSearchView extends StatefulWidget {
  final SearchConfig config;
  const RecipeSearchView({super.key, required this.config});

  @override
  State<RecipeSearchView> createState() => _RecipeSearchViewState();
}

class _RecipeSearchViewState extends State<RecipeSearchView> {
  List<model_cat.Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    // Trigger initial search to show all recipes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchProvider>(context, listen: false).textSearch('');
    });
  }

  Future<void> _loadCategories() async {
    final cats = await DatabaseService.instance.getCategories();
    if (mounted) {
      setState(() {
        _categories = cats;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('New'),
                  onPressed: () async {
                    Provider.of<RecipeProvider>(context, listen: false).reset();
                    final saved = await Navigator.pushNamed(
                      context,
                      AppRouter.recipeEditRoute,
                    );
                    if (saved == true && context.mounted) {
                      searchProvider.textSearch('');
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<int?>(
                  value: searchProvider.selectedCategoryId,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ..._categories.map(
                      (cat) => DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    searchProvider.setSelectedCategoryId(val);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<SearchProvider>(
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
                  final searchProvider = Provider.of<SearchProvider>(
                    context,
                    listen: false,
                  );

                  final bool isUpdate;
                  if (widget.config.onSaveOverride != null) {
                    // Recipe context: check if already in recipe items
                    isUpdate = recipeProvider.items.any(
                      (item) =>
                          item.recipe?.id == food.id ||
                          item.food?.id == food.id,
                    );
                  } else {
                    // Day context: check if already in log queue
                    final logProvider = Provider.of<LogProvider>(
                      context,
                      listen: false,
                    );
                    isUpdate = logProvider.logQueue.any(
                      (p) =>
                          p.food.id == food.id && p.food.source == food.source,
                    );
                  }

                  return FutureBuilder<model_recipe.Recipe>(
                    future: db.getRecipeById(food.id),
                    builder: (context, snapshot) {
                      final recipe = snapshot.data;
                      String? finalNote = food.usageNote;
                      if (recipe?.isTemplate ?? false) {
                        finalNote = finalNote != null
                            ? 'Only Dumpable • $finalNote'
                            : 'Only Dumpable';
                      }

                      return SlidableRecipeSearchResult(
                        food: food,
                        note: finalNote,
                        isUpdate: isUpdate,
                        onAdd: (selectedUnit) async {
                          if (recipe == null) return;
                          if (recipe.isTemplate && context.mounted) {
                            Provider.of<LogProvider>(
                              context,
                              listen: false,
                            ).dumpRecipeToQueue(recipe);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Dumped ${recipe.name} into Log Queue',
                                ),
                              ),
                            );
                            return;
                          }

                          final portion = model_portion.FoodPortion(
                            food: food,
                            grams: selectedUnit.grams,
                            unit: selectedUnit.unit,
                          );
                          if (widget.config.onSaveOverride != null) {
                            widget.config.onSaveOverride!(portion);
                          } else {
                            Provider.of<LogProvider>(
                              context,
                              listen: false,
                            ).addFoodToQueue(portion);
                          }
                        },
                        onTap: (selectedUnit) async {
                          if (recipe == null) return;
                          if (recipe.isTemplate && context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Only Dumpable'),
                                content: Text(
                                  '${recipe.name} is marked as "Only Dumpable". '
                                  'It can only be added as individual ingredients. '
                                  'Use the Dump action or click the + button to dump ingredients.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuantityEditScreen(
                                  config: QuantityEditConfig(
                                    context: widget.config.context,
                                    food: food,
                                    initialUnit: selectedUnit.unit,
                                    initialQuantity: selectedUnit.quantity,
                                    onSave: (grams, unit) {
                                      final portion = model_portion.FoodPortion(
                                        food: food,
                                        grams: grams,
                                        unit: unit,
                                      );
                                      if (widget.config.onSaveOverride !=
                                          null) {
                                        // First pop closes QuantityEditScreen
                                        Navigator.pop(context);
                                        // Second pop closes SearchScreen via onSaveOverride
                                        widget.config.onSaveOverride!(portion);
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
                          }
                        },
                        onEdit: () async {
                          if (recipe == null) return;
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
                              searchProvider.textSearch('');
                            }
                          }
                        },
                        onCopy: () async {
                          if (recipe == null) return;
                          recipeProvider.prepareCopy(recipe);
                          if (context.mounted) {
                            final saved = await Navigator.pushNamed(
                              context,
                              AppRouter.recipeEditRoute,
                            );
                            if (saved == true) {
                              searchProvider.textSearch('');
                            }
                          }
                        },
                        onDelete: () async {
                          await db.deleteRecipe(food.id);
                          searchProvider.textSearch('');
                        },
                        onDecompose: () async {
                          if (recipe == null) return;
                          if (context.mounted) {
                            Provider.of<LogProvider>(
                              context,
                              listen: false,
                            ).dumpRecipeToQueue(recipe);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Dumped ${recipe.name} into Log Queue',
                                ),
                              ),
                            );
                          }
                        },
                      );
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
