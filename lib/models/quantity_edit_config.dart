import 'package:free_cal_counter1/models/food.dart';

enum QuantityEditContext { day, recipe }

typedef QuantitySaveCallback = void Function(double grams, String unit);

class QuantityEditConfig {
  final QuantityEditContext context;
  final Food food;
  final double initialQuantity;
  final String initialUnit;
  final bool isUpdate;
  final double originalGrams;
  final QuantitySaveCallback onSave;

  // Recipe specific
  final double? recipeServings;

  const QuantityEditConfig({
    required this.context,
    required this.food,
    this.initialQuantity = 0.0,
    required this.initialUnit,
    this.isUpdate = false,
    this.originalGrams = 0.0,
    required this.onSave,
    this.recipeServings,
  });
}
