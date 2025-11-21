import 'package:equatable/equatable.dart';

class FoodPortion extends Equatable {
  final int? id;
  final int foodId;
  final String unit;
  final double grams;
  final double amount; // number of units per portion

  const FoodPortion({
    this.id,
    required this.foodId,
    required this.unit,
    required this.grams,
    required this.amount,
  });

  // fromJson constructor
  factory FoodPortion.fromJson(Map<String, dynamic> json) {
    return FoodPortion(
      id: json['id'],
      foodId: json['food_id'],
      unit: json['unit'],
      grams: json['grams'],
      amount: json['amount'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food_id': foodId,
      'unit': unit,
      'grams': grams,
      'amount': amount,
    };
  }

  @override
  List<Object?> get props => [unit, grams, amount];
}
