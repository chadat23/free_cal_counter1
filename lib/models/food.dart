import 'package:free_cal_counter1/models/food_serving.dart';

class Food {
  final int id;
  final String source;
  final String name;
  final String? emoji;
  final String? thumbnail;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;
  final List<FoodServing> servings;

  Food({
    required this.id,
    required this.source,
    required this.name,
    this.emoji,
    this.thumbnail,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    this.servings = const [], // Initialize with an empty list
  });

  Food copyWith({
    int? id,
    String? source,
    String? name,
    String? emoji,
    String? thumbnail,
    double? calories,
    double? protein,
    double? fat,
    double? carbs,
    double? fiber,
    List<FoodServing>? servings,
  }) {
    return Food(
      id: id ?? this.id,
      source: source ?? this.source,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      thumbnail: thumbnail ?? this.thumbnail,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      fiber: fiber ?? this.fiber,
      servings: servings ?? this.servings,
    );
  }
}
