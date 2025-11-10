import 'package:flutter/material.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_unit.dart' as model_unit;

class FoodLoggingWidget extends StatefulWidget {
  final Food food;
  final List<model_unit.FoodUnit> units;
  final VoidCallback onCancel;
  final Function(double quantity, model_unit.FoodUnit unit) onLog;

  const FoodLoggingWidget({
    super.key,
    required this.food,
    required this.units,
    required this.onCancel,
    required this.onLog,
  });

  @override
  State<FoodLoggingWidget> createState() => _FoodLoggingWidgetState();
}

class _FoodLoggingWidgetState extends State<FoodLoggingWidget> {
  final _quantityController = TextEditingController(text: '100');
  late model_unit.FoodUnit _selectedUnit;
  double _quantity = 100.0;

  @override
  void initState() {
    super.initState();
    // Also add a grams unit by default
    final allUnits = [
      model_unit.FoodUnit(
        id: 0,
        foodId: widget.food.id,
        unitName: 'g',
        gramsPerUnit: 1.0,
      ),
      ...widget.units,
    ];
    _selectedUnit = allUnits.firstWhere(
      (u) => u.unitName == 'g',
      orElse: () => allUnits.first,
    );

    _quantityController.addListener(() {
      setState(() {
        _quantity = double.tryParse(_quantityController.text) ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calories =
        (widget.food.calories / 100) * _selectedUnit.gramsPerUnit * _quantity;
    final protein =
        (widget.food.protein / 100) * _selectedUnit.gramsPerUnit * _quantity;
    final fat =
        (widget.food.fat / 100) * _selectedUnit.gramsPerUnit * _quantity;
    final carbs =
        (widget.food.carbs / 100) * _selectedUnit.gramsPerUnit * _quantity;

    final allUnits = [
      model_unit.FoodUnit(
        id: 0,
        foodId: widget.food.id,
        unitName: 'g',
        gramsPerUnit: 1.0,
      ),
      ...widget.units,
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Text(widget.food.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onCancel,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<model_unit.FoodUnit>(
                  initialValue: _selectedUnit,
                  items: allUnits.map((unit) {
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(unit.unitName),
                    );
                  }).toList(),
                  onChanged: (unit) {
                    if (unit != null) {
                      setState(() {
                        _selectedUnit = unit;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('🔥${calories.toInt()}'),
              Text('P: ${protein.toStringAsFixed(1)}'),
              Text('F: ${fat.toStringAsFixed(1)}'),
              Text('C: ${carbs.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onLog(_quantity, _selectedUnit);
            },
            child: const Text('Add to Log'),
          ),
        ],
      ),
    );
  }
}
