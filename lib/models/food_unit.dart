class FoodUnit {
  final int? id;
  final int foodId;
  final String name;
  final double grams;

  FoodUnit({
    this.id,
    required this.foodId,
    required this.name,
    required this.grams,
  });

  // fromJson constructor
  factory FoodUnit.fromJson(Map<String, dynamic> json) {
    return FoodUnit(
      id: json['id'],
      foodId: json['food_id'],
      name: json['name'],
      grams: json['grams'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food_id': foodId,
      'name': name,
      'grams': grams,
    };
  }
}