class MacroGoals {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;

  const MacroGoals({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.fiber = 15.0, // Default fiber
  });

  // Factory for hardcoded targets as requested
  factory MacroGoals.hardcoded() {
    return const MacroGoals(
      calories: 2650,
      protein: 160,
      fat: 80,
      carbs: 323,
      fiber: 15,
    );
  }

  factory MacroGoals.fromJson(Map<String, dynamic> json) {
    return MacroGoals(
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fiber: (json['fiber'] as num? ?? 15.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'fiber': fiber,
    };
  }
}
