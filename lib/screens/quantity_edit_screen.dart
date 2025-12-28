import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/quantity_edit_config.dart';
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/providers/recipe_provider.dart';
import 'package:free_cal_counter1/utils/math_evaluator.dart';
import 'package:free_cal_counter1/widgets/horizontal_mini_bar_chart.dart';

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

  @override
  void initState() {
    super.initState();
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMacroDisplay(),
            const SizedBox(height: 24),
            _buildInputSection(),
            const SizedBox(height: 16),
            if (widget.config.context == QuantityEditContext.recipe)
              _buildRecipeToggle(),
            const SizedBox(height: 24),
            _buildTargetSelection(),
            const SizedBox(height: 32),
            _buildFooterActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroDisplay() {
    final currentGrams = _calculateCurrentGrams();
    final food = widget.config.food;

    return Consumer2<LogProvider, RecipeProvider>(
      builder: (context, logProvider, recipeProvider, _) {
        final isRecipe = widget.config.context == QuantityEditContext.recipe;
        final servings =
            (isRecipe &&
                widget.config.recipeServings != null &&
                widget.config.recipeServings! > 0)
            ? widget.config.recipeServings!
            : 1.0;

        final divisor = (isRecipe && _isPerServing) ? servings : 1.0;

        // 1. Item Macros
        final itemValues = _calculatePortionMacros(food, currentGrams, divisor);

        // 2. Parent Macros (Projected)
        final parentValues = _calculateParentProjectedMacros(
          isRecipe ? recipeProvider : logProvider,
          food,
          currentGrams,
          widget.config.originalGrams,
          divisor,
        );

        return Column(
          children: [
            _buildChartSection(
              isRecipe ? "Recipe's Macros" : "Day's Macros",
              parentValues,
              isRecipe ? null : _getDayTargets(logProvider),
            ),
            const SizedBox(height: 12),
            _buildChartSection(
              isRecipe ? "Ingredient's Macros" : "Portion's Macros",
              itemValues,
              null,
            ),
            if (currentGrams > 0) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Result: ${currentGrams.toStringAsFixed(1)}g',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
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
        ),
        const SizedBox(height: 16),
        const Text('Unit', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: widget.config.food.servings.map((s) {
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
    final targets = ['Unit', 'Calories', 'Protein', 'Fat', 'Carbs'];
    return ToggleButtons(
      isSelected: List.generate(
        targets.length,
        (i) => i == _selectedTargetIndex,
      ),
      onPressed: (index) => setState(() {
        _selectedTargetIndex = index;
        if (index != 0) {
          // Selecting a macro target switches unit to "g" (if available)
          final hasGrams = widget.config.food.servings.any(
            (s) => s.unit == 'g',
          );
          if (hasGrams) {
            _selectedUnit = 'g';
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

  double _calculateCurrentGrams() {
    final quantity = MathEvaluator.evaluate(_quantityController.text) ?? 0.0;
    if (_selectedTargetIndex == 0) {
      // Unit target
      final serving = widget.config.food.servings.firstWhere(
        (s) => s.unit == _selectedUnit,
        orElse: () => widget.config.food.servings.first,
      );
      return serving.gramsFromQuantity(quantity);
    } else {
      // Macro target (Cal, Protein, Fat, Carbs)
      final food = widget.config.food;
      double perGram;
      switch (_selectedTargetIndex) {
        case 1:
          perGram = food.calories;
          break;
        case 2:
          perGram = food.protein;
          break;
        case 3:
          perGram = food.fat;
          break;
        case 4:
          perGram = food.carbs;
          break;
        default:
          perGram = 1.0;
      }
      return perGram > 0 ? quantity / perGram : 0.0;
    }
  }

  Map<String, double> _calculatePortionMacros(
    Food food,
    double grams,
    double divisor,
  ) {
    return {
      'Calories': (food.calories * grams) / divisor,
      'Protein': (food.protein * grams) / divisor,
      'Fat': (food.fat * grams) / divisor,
      'Carbs': (food.carbs * grams) / divisor,
    };
  }

  Map<String, double> _calculateParentProjectedMacros(
    dynamic provider,
    Food food,
    double currentGrams,
    double originalGrams,
    double divisor,
  ) {
    final double calories =
        (provider.totalCalories -
            (food.calories * originalGrams) +
            (food.calories * currentGrams)) /
        divisor;
    final double protein =
        (provider.totalProtein -
            (food.protein * originalGrams) +
            (food.protein * currentGrams)) /
        divisor;
    final double fat =
        (provider.totalFat -
            (food.fat * originalGrams) +
            (food.fat * currentGrams)) /
        divisor;
    final double carbs =
        (provider.totalCarbs -
            (food.carbs * originalGrams) +
            (food.carbs * currentGrams)) /
        divisor;

    return {
      'Calories': calories,
      'Protein': protein,
      'Fat': fat,
      'Carbs': carbs,
    };
  }

  Map<String, double> _getDayTargets(LogProvider provider) {
    return {
      'Calories': provider.dailyTargetCalories,
      'Protein': provider.dailyTargetProtein,
      'Fat': provider.dailyTargetFat,
      'Carbs': provider.dailyTargetCarbs,
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
                    targets?['Calories'] ?? 2000,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildMiniBar(
                    'P',
                    values['Protein']!,
                    targets?['Protein'] ?? 150,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildMiniBar(
                    'F',
                    values['Fat']!,
                    targets?['Fat'] ?? 70,
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

  void _handleSave() {
    final grams = _calculateCurrentGrams();
    if (grams > 0) {
      widget.config.onSave(grams, _selectedUnit);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
    }
  }
}
