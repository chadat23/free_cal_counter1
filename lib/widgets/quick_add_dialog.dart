import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_serving.dart';
import 'package:free_cal_counter1/services/database_service.dart';

class QuickAddDialog extends StatefulWidget {
  const QuickAddDialog({super.key});

  @override
  State<QuickAddDialog> createState() => _QuickAddDialogState();
}

class _QuickAddDialogState extends State<QuickAddDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = 'Quick Add';
  double _calories = 0;
  double _protein = 0;
  double _fat = 0;
  double _carbs = 0;
  double _fiber = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quick Add'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (val) => _name = val ?? 'Quick Add',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _calories = double.tryParse(val ?? '0') ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Protein (g)'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _protein = double.tryParse(val ?? '0') ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Fat (g)'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _fat = double.tryParse(val ?? '0') ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Carbs (g)'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _carbs = double.tryParse(val ?? '0') ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Fiber (g)'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _fiber = double.tryParse(val ?? '0') ?? 0,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Create a hidden food entry
      final food = Food(
        id: 0,
        name: _name,
        source: 'live',
        calories: _calories,
        protein: _protein,
        fat: _fat,
        carbs: _carbs,
        fiber: _fiber,
        hidden: true,
        servings: [
          FoodServing(
            foodId: 0,
            unit: 'serving',
            quantity: 1,
            grams: 100,
          ), // Dummy unit
        ],
      );

      final savedFoodId = await DatabaseService.instance.saveFood(food);
      final savedFood = await DatabaseService.instance.getFoodById(
        savedFoodId,
        'live',
      );

      if (mounted && savedFood != null) {
        Navigator.pop(context, savedFood);
      }
    }
  }
}
