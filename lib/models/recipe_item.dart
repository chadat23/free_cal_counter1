import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/models/recipe.dart';

class RecipeItem {
  final int id;
  final Food? food;
  final Recipe? recipe;
  final double grams;
  final String unit;

  RecipeItem({
    required this.id,
    this.food,
    this.recipe,
    required this.grams,
    required this.unit,
  }) : assert(
         food != null || recipe != null,
         'Either food or recipe must be provided',
       );

  bool get isFood => food != null;
  bool get isRecipe => recipe != null;

  String get name => isFood ? food!.name : recipe!.name;

  double get calories => isFood ? food!.calories : recipe!.caloriesPerGram;
  double get protein => isFood ? food!.protein : recipe!.proteinPerGram;
  double get fat => isFood ? food!.fat : recipe!.fatPerGram;
  double get carbs => isFood ? food!.carbs : recipe!.carbsPerGram;
  double get fiber => isFood ? food!.fiber : recipe!.fiberPerGram;
}
