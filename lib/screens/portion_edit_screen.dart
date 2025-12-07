import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart' as model_unit;
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/widgets/vertical_mini_bar_chart.dart';
import 'package:provider/provider.dart';

import 'package:free_cal_counter1/utils/math_evaluator.dart';

class PortionEditScreen extends StatefulWidget {
  final Food food;
  final model_unit.FoodServing? initialUnit;
  final double? initialQuantity;
  final Function(FoodPortion)? onUpdate;

  const PortionEditScreen({
    super.key,
    required this.food,
    this.initialUnit,
    this.initialQuantity,
    this.onUpdate,
  });

  @override
  State<PortionEditScreen> createState() => _PortionEditScreenState();
}

class _PortionEditScreenState extends State<PortionEditScreen> {
  late model_unit.FoodServing _selectedUnit;
  late TextEditingController _portionController;

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
    // Use MathEvaluator to parse the text
    final amount = MathEvaluator.evaluate(_portionController.text) ?? 0.0;

    // Calculate total grams based on serving unit and quantity
    // _selectedUnit.grams is the total weight of the serving (e.g. 50g for 2 cookies)
    // _selectedUnit.quantity is the number of units in the serving (e.g. 2)
    // We want the weight of the amount entered by the user.
    // totalGrams = amount * (grams / quantity)
    final totalGrams = amount * _selectedUnit.gramsPerUnit;

    final calories = widget.food.calories * totalGrams;
    final protein = widget.food.protein * totalGrams;
    final fat = widget.food.fat * totalGrams;
    final carbs = widget.food.carbs * totalGrams;
    final fiber = widget.food.fiber * totalGrams;

    // Hardcoded targets for now, matching OverviewScreen
    const targetCalories = 2143.0;
    const targetProtein = 141.0;
    const targetFat = 71.0;
    const targetCarbs = 233.0;
    const targetFiber = 30.0;

    final macros = [
      _MacroData(
        value: calories,
        target: targetCalories,
        label: '🔥',
        unit: '',
        color: Colors.blue,
      ),
      _MacroData(
        value: protein,
        target: targetProtein,
        label: 'P',
        unit: 'g',
        color: Colors.red,
      ),
      _MacroData(
        value: fat,
        target: targetFat,
        label: 'F',
        unit: 'g',
        color: Colors.yellow,
      ),
      _MacroData(
        value: carbs,
        target: targetCarbs,
        label: 'C',
        unit: 'g',
        color: Colors.green,
      ),
      _MacroData(
        value: fiber,
        target: targetFiber,
        label: 'Fb',
        unit: 'g',
        color: Colors.brown,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.largeWidgetBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: macros.map((data) {
          return Column(
            children: [
              VerticalMiniBarChart(
                value: data.value,
                maxValue: data.target,
                color: data.color,
              ),
              const SizedBox(height: 8),
              Text(
                '${data.value.toInt()} ${data.label}\nof ${data.target.toInt()}${data.unit}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }).toList(),
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
                    // Use visiblePassword to allow math symbols but avoid auto-correct
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
                    // Evaluate the math expression
                    final amount =
                        MathEvaluator.evaluate(_portionController.text) ?? 1.0;

                    // Calculate the actual weight in grams
                    final calculatedGrams = amount * _selectedUnit.gramsPerUnit;

                    final serving = FoodPortion(
                      food: widget.food,
                      grams: calculatedGrams,
                      unit: _selectedUnit.unit,
                    );

                    if (widget.onUpdate != null) {
                      widget.onUpdate!(serving);
                    } else {
                      final logProvider = Provider.of<LogProvider>(
                        context,
                        listen: false,
                      );
                      logProvider.addFoodToQueue(serving);
                    }
                    Navigator.pop(context);
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

class _MacroData {
  final double value;
  final double target;
  final String label;
  final String unit;
  final Color color;

  _MacroData({
    required this.value,
    required this.target,
    required this.label,
    required this.unit,
    required this.color,
  });
}
