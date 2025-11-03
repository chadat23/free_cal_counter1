
import 'package:drift/drift.dart';

class Foods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get source => text()();
  TextColumn get imageUrl => text().nullable()();
  RealColumn get caloriesPer100g => real()();
  RealColumn get proteinPer100g => real()();
  RealColumn get fatPer100g => real()();
  RealColumn get carbsPer100g => real()();
  RealColumn get fiberPer100g => real()();
  IntColumn get sourceFdcId => integer().nullable()();
  TextColumn get sourceBarcode => text().nullable()();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
}

@DataClassName('FoodUnit')
class FoodUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get foodId => integer().references(Foods, #id)();
  TextColumn get unitName => text()();
  RealColumn get gramsPerUnit => real()();
}

@DataClassName('Recipe')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get servingsCreated => real()();
  RealColumn get finalWeightGrams => real().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
}

@DataClassName('RecipeItem')
class RecipeItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  @ReferenceName('RecipeEntries')
  IntColumn get recipeId => integer().references(Recipes, #id)();
  IntColumn get ingredientFoodId => integer().nullable().references(Foods, #id)();
  @ReferenceName('IngredientRecipes')
  IntColumn get ingredientRecipeId => integer().nullable().references(Recipes, #id)();
  RealColumn get quantity => real()();
  TextColumn get unitName => text()();
}

@DataClassName('LoggedFood')
class LoggedFoods extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get logTimestamp => integer()();
  TextColumn get mealName => text()();
  IntColumn get foodId => integer().nullable().references(Foods, #id)();
  IntColumn get recipeId => integer().nullable().references(Recipes, #id)();
  RealColumn get quantity => real()();
  TextColumn get unitName => text()();
}
