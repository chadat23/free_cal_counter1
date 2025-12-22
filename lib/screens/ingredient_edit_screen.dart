import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart' as model_unit;
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:free_cal_counter1/providers/recipe_provider.dart';
import 'package:free_cal_counter1/widgets/horizontal_mini_bar_chart.dart';
import 'package:free_cal_counter1/utils/math_evaluator.dart';

class IngredientEditScreen extends StatefulWidget {
  final Food food;
  final model_unit.FoodServing? initialUnit;
  final double? initialQuantity;
  final RecipeProvider recipeProvider;
  final Function(FoodPortion)? onUpdate;

  const IngredientEditScreen({
    super.key,
    required this.food,
    required this.recipeProvider,
    this.initialUnit,
    this.initialQuantity,
    this.onUpdate,
  });

  @override
  State<IngredientEditScreen> createState() => _IngredientEditScreenState();
}

class _IngredientEditScreenState extends State<IngredientEditScreen> {
  late model_unit.FoodServing _selectedUnit;
  late TextEditingController _portionController;
  final List<bool> _isPerServingToggle = [true, false]; // [Total, PerServing]

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.initialUnit ?? widget.food.servings.first;
    _portionController = TextEditingController(
      text: widget.initialQuantity?.toString() ?? '1',
    );
    _portionController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _portionController.removeListener(_onAmountChanged);
    _portionController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    setState(() {});
  }

  Widget _buildMacroDisplay() {
    final recipeProvider = widget.recipeProvider;
    // Use MathEvaluator to parse the text
    final amount = MathEvaluator.evaluate(_portionController.text) ?? 0.0;

    // Calculate total grams for CURRENT portion
    final currentGrams = amount * _selectedUnit.gramsPerUnit;

    // Calculate original grams if we are editing an existing item (to subtract from totals)
    double originalGrams = 0.0;
    if (widget.onUpdate != null) {
      final initQ = widget.initialQuantity ?? 1.0;
      final initU = widget.initialUnit ?? widget.food.servings.first;
      originalGrams = initQ * initU.gramsPerUnit;
    }

    final servings = recipeProvider.servingsCreated > 0
        ? recipeProvider.servingsCreated
        : 1.0;
    final isPerServing = _isPerServingToggle[1];

    // Helper to build list of targets
    List<NutritionTarget> buildTargets({
      required double calories,
      required double protein,
      required double fat,
      required double carbs,
      required double fiber,
      double divisor = 1.0,
    }) {
      return [
        NutritionTarget(
          macroLabel: '🔥',
          thisAmount: calories / divisor,
          targetAmount: 2000, // Placeholder target
          unitLabel: '',
          dailyAmounts: [],
          color: Colors.blue,
        ),
        NutritionTarget(
          macroLabel: 'P',
          thisAmount: protein / divisor,
          targetAmount: 150, // Placeholder target
          unitLabel: 'g',
          dailyAmounts: [],
          color: Colors.red,
        ),
        NutritionTarget(
          macroLabel: 'F',
          thisAmount: fat / divisor,
          targetAmount: 70, // Placeholder target
          unitLabel: 'g',
          dailyAmounts: [],
          color: Colors.yellow,
        ),
        NutritionTarget(
          macroLabel: 'C',
          thisAmount: carbs / divisor,
          targetAmount: 250, // Placeholder target
          unitLabel: 'g',
          dailyAmounts: [],
          color: Colors.green,
        ),
        NutritionTarget(
          macroLabel: 'Fb',
          thisAmount: fiber / divisor,
          targetAmount: 30, // Placeholder
          unitLabel: 'g',
          dailyAmounts: [],
          color: Colors.brown,
        ),
      ];
    }

    // 1. Portion Macros (The ingredient itself)
    final portionTargets = buildTargets(
      calories: widget.food.calories * currentGrams,
      protein: widget.food.protein * currentGrams,
      fat: widget.food.fat * currentGrams,
      carbs: widget.food.carbs * currentGrams,
      fiber: widget.food.fiber * currentGrams,
      divisor: isPerServing ? servings : 1.0,
    );

    // 2. Recipe Macros (Projected Total for Recipe)
    // We start with current provider totals, subtract original version of this item (if editing), add new version
    final projectedTargets = buildTargets(
      calories:
          recipeProvider.totalCalories -
          (widget.food.calories * originalGrams) +
          (widget.food.calories * currentGrams),
      protein:
          recipeProvider.totalProtein -
          (widget.food.protein * originalGrams) +
          (widget.food.protein * currentGrams),
      fat:
          recipeProvider.totalFat -
          (widget.food.fat * originalGrams) +
          (widget.food.fat * currentGrams),
      carbs:
          recipeProvider.totalCarbs -
          (widget.food.carbs * originalGrams) +
          (widget.food.carbs * currentGrams),
      fiber:
          recipeProvider.totalFiber -
          (widget.food.fiber * originalGrams) +
          (widget.food.fiber * currentGrams),
      divisor: isPerServing ? servings : 1.0,
    );

    final labelSuffix = isPerServing ? " (Per Serving)" : " (Total)";

    Widget buildChartRow(List<NutritionTarget> targets, String title) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: targets
                .map(
                  (target) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: HorizontalMiniBarChart(
                        consumed: target.thisAmount,
                        target: target.targetAmount,
                        color: target.color,
                        macroLabel: target.macroLabel,
                        unitLabel: target.unitLabel,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.largeWidgetBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ToggleButtons(
              isSelected: _isPerServingToggle,
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < _isPerServingToggle.length; i++) {
                    _isPerServingToggle[i] = i == index;
                  }
                });
              },
              borderRadius: BorderRadius.circular(8),
              constraints: const BoxConstraints(minHeight: 32, minWidth: 80),
              children: const [Text('Total'), Text('Per Serving')],
            ),
          ),
          const SizedBox(height: 12),
          buildChartRow(projectedTargets, "Recipe's Macros$labelSuffix"),
          const SizedBox(height: 12),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 12),
          buildChartRow(portionTargets, "Ingredient's Macros$labelSuffix"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.food.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMacroDisplay(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _portionController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Unit',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.food.servings.map((unit) {
                final isSelected = _selectedUnit == unit;
                return ChoiceChip(
                  label: Text(unit.unit),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedUnit = unit;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final amount =
                        MathEvaluator.evaluate(_portionController.text) ?? 1.0;

                    final calculatedGrams = amount * _selectedUnit.gramsPerUnit;

                    final serving = FoodPortion(
                      food: widget.food,
                      grams: calculatedGrams,
                      unit: _selectedUnit.unit,
                    );

                    if (widget.onUpdate != null) {
                      widget.onUpdate!(serving);
                    }

                    // Do NOT add to LogQueue
                    Navigator.pop(context, serving);
                  },
                  child: Text(widget.onUpdate != null ? 'Update' : 'Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
