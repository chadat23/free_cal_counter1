import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart' as model_unit;
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/models/nutrition_target.dart';
import 'package:free_cal_counter1/widgets/horizontal_mini_bar_chart.dart';
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
    return Consumer<LogProvider>(
      builder: (context, logProvider, child) {
        // Use MathEvaluator to parse the text
        final amount = MathEvaluator.evaluate(_portionController.text) ?? 0.0;

        // Calculate total grams for CURRENT portion
        final currentGrams = amount * _selectedUnit.gramsPerUnit;

        // Calculate original grams if we are editing an existing item
        double originalGrams = 0.0;
        if (widget.onUpdate != null) {
          final initQ = widget.initialQuantity ?? 1.0;
          final initU = widget.initialUnit ?? widget.food.servings.first;
          originalGrams = initQ * initU.gramsPerUnit;
        }

        // Helper to build list of targets
        List<NutritionTarget> buildTargets({
          required double calories,
          required double protein,
          required double fat,
          required double carbs,
          required double fiber,
        }) {
          return [
            NutritionTarget(
              macroLabel: '🔥',
              thisAmount: calories,
              targetAmount: logProvider.dailyTargetCalories,
              unitLabel: '',
              dailyAmounts: [],
              color: Colors.blue,
            ),
            NutritionTarget(
              macroLabel: 'P',
              thisAmount: protein,
              targetAmount: logProvider.dailyTargetProtein,
              unitLabel: 'g',
              dailyAmounts: [],
              color: Colors.red,
            ),
            NutritionTarget(
              macroLabel: 'F',
              thisAmount: fat,
              targetAmount: logProvider.dailyTargetFat,
              unitLabel: 'g',
              dailyAmounts: [],
              color: Colors.yellow,
            ),
            NutritionTarget(
              macroLabel: 'C',
              thisAmount: carbs,
              targetAmount: logProvider.dailyTargetCarbs,
              unitLabel: 'g',
              dailyAmounts: [],
              color: Colors.green,
            ),
            NutritionTarget(
              macroLabel: 'Fb',
              thisAmount: fiber,
              targetAmount: logProvider.dailyTargetFiber,
              unitLabel: 'g',
              dailyAmounts: [],
              color: Colors.brown,
            ),
          ];
        }

        // 1. Portion Macros
        final portionTargets = buildTargets(
          calories: widget.food.calories * currentGrams,
          protein: widget.food.protein * currentGrams,
          fat: widget.food.fat * currentGrams,
          carbs: widget.food.carbs * currentGrams,
          fiber: widget.food.fiber * currentGrams,
        );

        // 2. Day's Macros (Projected)
        final projectedTargets = buildTargets(
          calories:
              logProvider.totalCalories -
              (widget.food.calories * originalGrams) +
              (widget.food.calories * currentGrams),
          protein:
              logProvider.totalProtein -
              (widget.food.protein * originalGrams) +
              (widget.food.protein * currentGrams),
          fat:
              logProvider.totalFat -
              (widget.food.fat * originalGrams) +
              (widget.food.fat * currentGrams),
          carbs:
              logProvider.totalCarbs -
              (widget.food.carbs * originalGrams) +
              (widget.food.carbs * currentGrams),
          fiber:
              logProvider.totalFiber -
              (widget.food.fiber * originalGrams) +
              (widget.food.fiber * currentGrams),
        );

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
              buildChartRow(projectedTargets, "Day's Macros"),
              const SizedBox(height: 12),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 12),
              buildChartRow(portionTargets, "Portion's Macros"),
            ],
          ),
        );
      },
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
