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
    required this.fiber,
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
}
