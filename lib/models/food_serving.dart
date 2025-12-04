import 'package:equatable/equatable.dart';

class FoodServing extends Equatable {
  final int? id;
  final int foodId;
  final String unit; // unit of measurement of a serving
  final double grams; // weight of a serving in grams
  final double quantity; // number of units per serving

  const FoodServing({
    this.id,
    required this.foodId,
    required this.unit,
    required this.grams,
    required this.quantity,
  });

  // fromJson constructor
  factory FoodServing.fromJson(Map<String, dynamic> json) {
    return FoodServing(
      id: json['id'],
      foodId: json['food_id'],
      unit: json['unit'],
      grams: json['grams'],
      quantity: json['quantity'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food_id': foodId,
      'unit': unit,
      'grams': grams,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [unit, grams, quantity];

  /// The weight of a single unit in grams.
  double get gramsPerUnit => grams / quantity;

  /// Calculates the quantity (number of units) from a total weight in grams.
  double quantityFromGrams(double totalGrams) {
    if (gramsPerUnit == 0) return 0;
    return totalGrams / gramsPerUnit;
  }

  /// Calculates the total weight in grams from a quantity (number of units).
  double gramsFromQuantity(double quantity) {
    return quantity * gramsPerUnit;
  }
}
