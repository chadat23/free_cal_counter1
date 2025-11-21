import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_portion.dart';
import 'package:free_cal_counter1/models/food_serving.dart' as model_unit;
import 'package:free_cal_counter1/providers/log_provider.dart';
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
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.food.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
