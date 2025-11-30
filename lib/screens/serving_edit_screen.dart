import 'package:flutter/material.dart';
import 'package:free_cal_counter1/config/app_colors.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart' as model_unit;
import 'package:free_cal_counter1/providers/log_provider.dart';
import 'package:free_cal_counter1/widgets/vertical_mini_bar_chart.dart';
import 'package:provider/provider.dart';

class ServingEditScreen extends StatefulWidget {
  final Food food;
  final model_unit.FoodServing? initialUnit;

  const ServingEditScreen({super.key, required this.food, this.initialUnit});

  @override
  State<ServingEditScreen> createState() => _ServingEditScreenState();
}

class _ServingEditScreenState extends State<ServingEditScreen> {
  late model_unit.FoodServing _selectedUnit;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.initialUnit ?? widget.food.servings.first;
    _amountController = TextEditingController(text: '1');
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    setState(() {});
  }

  Widget _buildMacroDisplay() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    // Calculate total grams based on serving unit and quantity
    // _selectedUnit.grams is grams per unit (or quantity units)
    // If quantity is 1, it's grams per unit.
    // If quantity is > 1 (e.g. 100g), then grams is 100.
    // We assume _selectedUnit.grams is the weight of ONE "serving" as defined by the unit.
    // But wait, if unit is "g", usually grams=1.
    // Let's stick to the logic: totalGrams = amount * _selectedUnit.grams
    // This assumes 'amount' is the number of 'units'.
    final totalGrams = amount * _selectedUnit.grams;

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
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<model_unit.FoodServing>(
                    value: _selectedUnit,
                    items: widget.food.servings.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit.unit),
                      );
                    }).toList(),
                    onChanged: (unit) {
                      if (unit != null) {
                        setState(() {
                          _selectedUnit = unit;
                        });
                      }
                    },
                  ),
                ),
              ],
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
                    final logProvider = Provider.of<LogProvider>(
                      context,
                      listen: false,
                    );
                    final amount =
                        double.tryParse(_amountController.text) ?? 1.0;
                    final serving = FoodPortion(
                      food: widget.food,
                      grams: amount,
                      unit: _selectedUnit.unit,
                    );
                    logProvider.addFoodToQueue(serving);
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
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
