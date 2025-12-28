import 'package:free_cal_counter1/models/recipe_item.dart';
import 'package:free_cal_counter1/models/category.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/food_serving.dart';

class Recipe {
  final int id;
  final String name;
  final double servingsCreated;
  final double? finalWeightGrams;
  final String portionName;
  final String? notes;
  final bool isTemplate;
  final bool hidden;
  final int? parentId;
  final int createdTimestamp;
  final List<RecipeItem> items;
  final List<Category> categories;

  Recipe({
    required this.id,
    required this.name,
    this.servingsCreated = 1.0,
    this.finalWeightGrams,
    this.portionName = 'portion',
    this.notes,
    this.isTemplate = false,
    this.hidden = false,
    this.parentId,
    required this.createdTimestamp,
    this.items = const [],
    this.categories = const [],
  });

  double get totalGrams =>
      finalWeightGrams ?? items.fold(0, (sum, item) => sum + item.grams);

  double get totalCalories =>
      items.fold(0, (sum, item) => sum + (item.calories * item.grams));
  double get totalProtein =>
      items.fold(0, (sum, item) => sum + (item.protein * item.grams));
  double get totalFat =>
      items.fold(0, (sum, item) => sum + (item.fat * item.grams));
  double get totalCarbs =>
      items.fold(0, (sum, item) => sum + (item.carbs * item.grams));
  double get totalFiber =>
      items.fold(0, (sum, item) => sum + (item.fiber * item.grams));

  double get caloriesPerGram => totalCalories / totalGrams;
  double get proteinPerGram => totalProtein / totalGrams;
  double get fatPerGram => totalFat / totalGrams;
  double get carbsPerGram => totalCarbs / totalGrams;
  double get fiberPerGram => totalFiber / totalGrams;

  double get caloriesPerPortion => totalCalories / servingsCreated;
  double get proteinPerPortion => totalProtein / servingsCreated;
  double get fatPerPortion => totalFat / servingsCreated;
  double get carbsPerPortion => totalCarbs / servingsCreated;
  double get fiberPerPortion => totalFiber / servingsCreated;

  double get gramsPerPortion => totalGrams / servingsCreated;

  Food toFood() {
    return Food(
      id: id,
      name: name,
      source: 'recipe',
      calories: caloriesPerGram,
      protein: proteinPerGram,
      fat: fatPerGram,
      carbs: carbsPerGram,
      fiber: fiberPerGram,
      servings: [
        FoodServing(
          foodId: id,
          unit: portionName,
          grams: gramsPerPortion,
          quantity: 1.0,
        ),
        FoodServing(foodId: id, unit: 'g', grams: 1.0, quantity: 1.0),
      ],
    );
  }
}
