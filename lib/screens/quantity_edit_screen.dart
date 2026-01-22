import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/models/quantity_edit_config.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/recipe_provider.dart';
import 'package:free_cal_counter1/providers/goals_provider.dart';
import 'package:free_cal_counter1/utils/math_evaluator.dart';
import 'package:free_cal_counter1/utils/quantity_edit_utils.dart';
import 'package:free_cal_counter1/widgets/horizontal_mini_bar_chart.dart';
import 'package:free_cal_counter1/screens/food_edit_screen.dart';
import 'package:free_cal_counter1/services/database_service.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/widgets/food_image_widget.dart';
import 'package:free_cal_counter1/models/food_container.dart';

class QuantityEditScreen extends StatefulWidget {
  final QuantityEditConfig config;

  const QuantityEditScreen({super.key, required this.config});

  @override
  State<QuantityEditScreen> createState() => _QuantityEditScreenState();
}

class _QuantityEditScreenState extends State<QuantityEditScreen> {
  final TextEditingController _quantityController = TextEditingController();
  late String _selectedUnit;
  int _selectedTargetIndex = 0; // 0: Unit, 1: Cal, 2: Protein, 3: Fat, 4: Carbs
  bool _isPerServing = false;
  late Food _food;

  @override
  void initState() {
    super.initState();
    _food = widget.config.food;
    _quantityController.text = widget.config.initialQuantity.toString();
    _selectedUnit = widget.config.initialUnit;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.config.isUpdate ? 'Update Quantity' : 'Add Quantity',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Definition',
            onPressed: _handleEditDefinition,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFoodHeader(),
            const SizedBox(height: 16),
            _buildMacroDisplay(),
            const SizedBox(height: 24),
            _buildInputSection(),
            const SizedBox(height: 16),
            if (widget.config.context == QuantityEditContext.recipe)
              _buildRecipeToggle(),
            const SizedBox(height: 24),
            _buildTargetSelection(),
            const SizedBox(height: 16),
            _buildResultDisplay(),
            const SizedBox(height: 32),
            _buildFooterActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroDisplay() {
    final currentGrams = _calculateCurrentGrams();
    final food = _food;

    return Consumer3<LogProvider, RecipeProvider, GoalsProvider>(
      builder: (context, logProvider, recipeProvider, goalsProvider, _) {
        final isRecipe = widget.config.context == QuantityEditContext.recipe;
        final servings =
            (isRecipe &&
                widget.config.recipeServings != null &&
                widget.config.recipeServings! > 0)
            ? widget.config.recipeServings!
            : 1.0;

        final divisor = (isRecipe && _isPerServing) ? servings : 1.0;

        // 1. Item Macros
        final itemValues = QuantityEditUtils.calculatePortionMacros(
          food,
          currentGrams,
          divisor,
        );

        // 2. Parent Macros (Projected)
        final parentValues = QuantityEditUtils.calculateParentProjectedMacros(
          totalCalories: isRecipe
              ? recipeProvider.totalCalories
              : logProvider.totalCalories,
          totalProtein: isRecipe
              ? recipeProvider.totalProtein
              : logProvider.totalProtein,
          totalFat: isRecipe ? recipeProvider.totalFat : logProvider.totalFat,
          totalCarbs: isRecipe
              ? recipeProvider.totalCarbs
              : logProvider.totalCarbs,
          totalFiber: isRecipe
              ? recipeProvider.totalFiber
              : logProvider.totalFiber,
          food: food,
          currentGrams: currentGrams,
          originalGrams: widget.config.originalGrams,
          divisor: divisor,
        );

        return Column(
          children: [
            _buildChartSection(
              isRecipe ? "Recipe's Macros" : "Day's Macros",
              parentValues,
              isRecipe ? null : _getGoals(goalsProvider),
            ),
            const SizedBox(height: 12),
            _buildChartSection(
              isRecipe ? "Ingredient's Macros" : "Portion's Macros",
              itemValues,
              null,
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _quantityController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Amount',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
          onTap: () {
            _quantityController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _quantityController.text.length,
            );
          },
        ),
        const SizedBox(height: 16),
        // Add Minus Container Button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _showContainerSelection,
            icon: const Icon(Icons.remove_circle_outline, size: 18),
            label: const Text('Minus Container'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Unit', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _food.servings.map((s) {
            final isSelected = _selectedUnit == s.unit;
            return ChoiceChip(
              label: Text(s.unit),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedUnit = s.unit;
                    _selectedTargetIndex =
                        0; // Selecting a unit switches target to "Unit"
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTargetSelection() {
    final targets = ['Unit', 'Calories', 'Protein', 'Fat', 'Carbs', 'Fiber'];
    return ToggleButtons(
      isSelected: List.generate(
        targets.length,
        (i) => i == _selectedTargetIndex,
      ),
      onPressed: (index) => setState(() {
        _selectedTargetIndex = index;
        if (index != 0) {
          // Selecting a macro target switches unit to "g" (if available)
          final gramServing = _food.servings.firstWhere(
            (s) => s.unit == 'g' || s.unit == 'gram',
            orElse: () => _food.servings.first,
          );
          if (gramServing.unit == 'g' || gramServing.unit == 'gram') {
            _selectedUnit = gramServing.unit;
          }
        }
      }),
      children: targets
          .map(
            (t) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(t),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFooterActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _handleSave,
            child: Text(widget.config.isUpdate ? 'Update' : 'Add'),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeToggle() {
    return Row(
      children: [
        const Text('Visualize: '),
        const SizedBox(width: 8),
        ToggleButtons(
          isSelected: [!_isPerServing, _isPerServing],
          onPressed: (index) => setState(() => _isPerServing = index == 1),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('Total'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('Per Serving'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultDisplay() {
    final currentGrams = _calculateCurrentGrams();
    return Center(
      child: Text(
        'Result: ${currentGrams.toStringAsFixed(1)}g',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  double _calculateCurrentGrams() {
    final quantity = MathEvaluator.evaluate(_quantityController.text) ?? 0.0;
    return QuantityEditUtils.calculateGrams(
      quantity: quantity,
      food: _food,
      selectedUnit: _selectedUnit,
      selectedTargetIndex: _selectedTargetIndex,
    );
  }

  Map<String, double> _getGoals(GoalsProvider provider) {
    final goals = provider.currentGoals;
    return {
      'Calories': goals.calories,
      'Protein': goals.protein,
      'Fat': goals.fat,
      'Carbs': goals.carbs,
      'Fiber': goals.fiber,
    };
  }

  Widget _buildChartSection(
    String title,
    Map<String, double> values,
    Map<String, double>? targets,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMiniBar(
                    '🔥',
                    values['Calories']!,
                    targets?['Calories'] ?? 2650,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildMiniBar(
                    'P',
                    values['Protein']!,
                    targets?['Protein'] ?? 160,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildMiniBar(
                    'F',
                    values['Fat']!,
                    targets?['Fat'] ?? 80,
                    Colors.yellow,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildMiniBar(
                    'C',
                    values['Carbs']!,
                    targets?['Carbs'] ?? 250,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildMiniBar(
                    'Fb',
                    values['Fiber']!,
                    targets?['Fiber'] ?? 15,
                    Colors.brown,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBar(String label, double value, double target, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: HorizontalMiniBarChart(
        consumed: value,
        target: target,
        color: color,
        macroLabel: label,
      ),
    );
  }

  Widget _buildFoodHeader() {
    return Column(
      children: [
        FoodImageWidget(food: _food, size: 80.0),
        const SizedBox(height: 8),
        Text(
          _food.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _handleSave() {
    final grams = _calculateCurrentGrams();
    if (grams > 0) {
      // Call the callback with the updated food reference
      widget.config.onSave(grams, _selectedUnit, _food);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
    }
  }

  Future<void> _handleEditDefinition() async {
    try {
      final result = await Navigator.push<FoodEditResult>(
        context,
        MaterialPageRoute(
          builder: (context) => FoodEditScreen(
            originalFood: _food,
            contextType: FoodEditContext.editDefinition,
          ),
        ),
      );

      if (result != null && mounted) {
        // Reload food from database to get latest changes
        // Always query from 'live' since edited foods are saved there
        final updatedFood = await DatabaseService.instance.getFoodById(
          result.foodId,
          'live',
        );

        if (updatedFood != null && mounted) {
          setState(() {
            _food = updatedFood;
            // Also update selected unit if it no longer exists
            if (!_food.servings.any((s) => s.unit == _selectedUnit)) {
              // Try to find matching unit, otherwise default
              _selectedUnit = _food.servings.first.unit;
            }
          });

          // Refresh the food in the log queue to propagate name/image changes
          final logProvider = Provider.of<LogProvider>(context, listen: false);
          await logProvider.refreshFoodInQueue(result.foodId, updatedFood);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Food definition updated')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating food: $e')));
      }
    }
  }

  Future<void> _showContainerSelection() async {
    // Load containers
    final containers = await DatabaseService.instance.getAllContainers();
    if (!mounted) return;

    if (containers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No containers found. Add them in Settings.'),
        ),
      );
      return;
    }

    final selected = await showModalBottomSheet<FoodContainer>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Container to Subtract',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: containers.length,
              itemBuilder: (context, index) {
                final container = containers[index];
                return ListTile(
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: container.thumbnail != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: FoodImageWidget(
                              thumbnail: container.thumbnail,
                              size: 40,
                            ),
                          )
                        : const Icon(Icons.inventory_2_outlined),
                  ),
                  title: Text(container.name),
                  subtitle: Text('${container.weight} ${container.unit}'),
                  onTap: () => Navigator.pop(context, container),
                );
              },
            ),
          ),
        ],
      ),
    );

    if (selected != null) {
      final currentVal = double.tryParse(_quantityController.text) ?? 0.0;
      // Assume container weight is in grams.
      // If selected unit is NOT grams, we might need conversion?
      // Plan implied simple gram subtraction.
      // If user is in "oz", subtracting "50g" is tricky if we just subtract numbers.
      // Ideally we convert container weight to selected unit.

      double weightToSubtract = selected.weight;

      // Simple conversion check
      if (_selectedUnit != 'g' && _selectedUnit != 'gram') {
        // Try to find conversion based on food serving?
        // Or just warn?
        // "Minus Container" implies we are weighing in GRAMS largely?
        // If I'm weighing yogurt in a container, I'm likely using a scale in Grams.
        // If I'm using "Cups", I'm not weighing the container usually.
        // So let's assume this feature is primarily for Grams input.
        if (_selectedUnit != 'g' && _selectedUnit != 'gram') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please switch unit to "g" to subtract container weight correctly.',
              ),
            ),
          );
          return;
        }
      }

      final newValue = currentVal - weightToSubtract;
      if (newValue < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Container weight is larger than total weight!'),
          ),
        );
      } else {
        setState(() {
          _quantityController.text = newValue.toStringAsFixed(1);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subtracted ${selected.weight}g')),
        );
      }
    }
  }
}
