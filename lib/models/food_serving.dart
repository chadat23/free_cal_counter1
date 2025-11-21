import 'package:equatable/equatable.dart';

class FoodServing extends Equatable {
  final int? id;
  final int foodId;
  final String unit;
  final double grams;
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
}
