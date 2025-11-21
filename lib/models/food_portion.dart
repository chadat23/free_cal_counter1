import 'package:equatable/equatable.dart';

class FoodPortion extends Equatable {
  final int? id;
  final int foodId;
  final String name;
  final double grams;
  final double amount; // number of units per portion

  const FoodPortion({
    this.id,
    required this.foodId,
    required this.name,
    required this.grams,
    required this.amount,
  });

  // fromJson constructor
  factory FoodPortion.fromJson(Map<String, dynamic> json) {
    return FoodPortion(
      id: json['id'],
      foodId: json['food_id'],
      name: json['name'],
      grams: json['grams'],
      amount: json['amount'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food_id': foodId,
      'name': name,
      'grams': grams,
      'amount': amount,
    };
  }

  @override
  List<Object?> get props => [name, grams, amount];
}
