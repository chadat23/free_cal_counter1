import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/providers/recipe_provider.dart';
import 'package:free_cal_counter1/models/recipe_item.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/widgets/horizontal_mini_bar_chart.dart';
import 'package:free_cal_counter1/screens/recipe_ingredient_search_screen.dart';
import 'package:free_cal_counter1/providers/food_search_provider.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/services/open_food_facts_service.dart';
import 'package:free_cal_counter1/services/food_search_service.dart';
import 'package:free_cal_counter1/widgets/slidable_recipe_item_widget.dart';
import 'package:free_cal_counter1/screens/portion_edit_screen.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_serving.dart' as model_unit;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/services/emoji_service.dart';

class RecipeEditScreen extends StatefulWidget {
  const RecipeEditScreen({super.key});

  @override
  State<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _portionsController;
  late TextEditingController _weightController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RecipeProvider>(context, listen: false);
    _nameController = TextEditingController(text: provider.name);
    _portionsController = TextEditingController(
      text: provider.servingsCreated.toString(),
    );
    _weightController = TextEditingController(
      text: provider.finalWeightGrams?.toString() ?? '',
    );
    _notesController = TextEditingController(text: provider.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _portionsController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(provider.name.isEmpty ? 'New Recipe' : provider.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);
                  final success = await provider.saveRecipe();

                  if (!mounted) return;

                  if (success) {
                    navigator.pop(true);
                  } else {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          provider.errorMessage ?? 'Failed to save recipe.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          body: SlidableAutoCloseBehavior(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetadataFields(provider),
                  const SizedBox(height: 24),
                  _buildMacroSummary(provider),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ingredients',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () async {
                          final databaseService = DatabaseService.instance;
                          final offApiService = OffApiService();
                          final emojiService = emojiForFoodName;
                          final foodSearchService = FoodSearchService(
                            databaseService: databaseService,
                            offApiService: offApiService,
                            emojiForFoodName: emojiService,
                          );

                          final item = await Navigator.push<RecipeItem>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (_) => FoodSearchProvider(
                                  databaseService: databaseService,
                                  offApiService: offApiService,
                                  foodSearchService: foodSearchService,
                                ),
                                child: const RecipeIngredientSearchScreen(),
                              ),
                            ),
                          );

                          if (item != null && mounted) {
                            provider.addItem(item);
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildIngredientList(provider),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Preparation steps, cooking time...',
                    ),
                    onChanged: provider.setNotes,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetadataFields(RecipeProvider provider) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Recipe Name',
            hintText: 'e.g. Grandma\'s Apple Pie',
          ),
          onChanged: provider.setName,
        ),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _portionsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Portions'),
              onChanged: (val) {
                final d = double.tryParse(val);
                if (d != null) provider.setServingsCreated(d);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Final Weight (g)',
                hintText: 'Optional',
              ),
              onChanged: (val) {
                final d = double.tryParse(val);
                provider.setFinalWeightGrams(d);
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      SwitchListTile(
        title: const Text('Is Template (Decompose into log)'),
        subtitle: const Text('When logged, add ingredients individually'),
        value: provider.isTemplate,
        onChanged: provider.setIsTemplate,
        contentPadding: EdgeInsets.zero,
      ),
    ],
  );
}

  Widget _buildMacroSummary(RecipeProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.largeWidgetBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Macros per Portion',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMacroItem(
                '🔥',
                provider.caloriesPerPortion,
                2000,
                Colors.blue,
              ),
              _buildMacroItem(
                'P',
                provider.totalProtein / provider.servingsCreated,
                150,
                Colors.red,
              ),
              _buildMacroItem(
                'F',
                provider.totalFat / provider.servingsCreated,
                70,
                Colors.yellow,
              ),
              _buildMacroItem(
                'C',
                provider.totalCarbs / provider.servingsCreated,
                250,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, double val, double target, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: HorizontalMiniBarChart(
          consumed: val,
          target: target,
          color: color,
          macroLabel: label,
          unitLabel: '',
        ),
      ),
    );
  }

  Widget _buildIngredientList(RecipeProvider provider) {
    if (provider.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Text(
            'No ingredients added yet',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.items.length,
      itemBuilder: (context, index) {
        final item = provider.items[index];
        return SlidableRecipeItemWidget(
          item: item,
          onDelete: () => provider.removeItem(index),
          onEdit: () async {
            // Determine food object (either food itself or converted recipe)
            final Food food = item.isFood ? item.food! : item.recipe!.toFood();

            // Find best matching serving
            final model_unit.FoodServing serving = food.servings.firstWhere(
              (s) => s.unit == item.unit,
              orElse: () => food.servings.first,
            );

            // Navigate to PortionEditScreen
            final updatedPortion = await Navigator.push<FoodPortion>(
              context,
              MaterialPageRoute(
                builder: (context) => PortionEditScreen(
                  food: food,
                  initialUnit: serving,
                  initialQuantity: serving.quantityFromGrams(item.grams),
                ),
              ),
            );

            if (updatedPortion != null && mounted) {
              // Convert FoodPortion back to RecipeItem
              final newItem = RecipeItem(
                id: item.id,
                food: item.isFood ? updatedPortion.food : null,
                recipe: item.isRecipe ? item.recipe : null,
                grams: updatedPortion.grams,
                unit: updatedPortion.unit,
              );
              provider.updateItem(index, newItem);
            }
          },
        );
      },
    );
  }
}
