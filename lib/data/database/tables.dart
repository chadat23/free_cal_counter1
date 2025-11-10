import 'package:drift/drift.dart';

class Foods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().named('name')();
  TextColumn get source => text().named('source')();
  TextColumn get emoji => text().named('emoji').nullable()();
  TextColumn get thumbnail => text().named('thumbnail').nullable()();
  RealColumn get caloriesPer100g => real().named('caloriesPer100g')();
  RealColumn get proteinPer100g => real().named('proteinPer100g')();
  RealColumn get fatPer100g => real().named('fatPer100g')();
  RealColumn get carbsPer100g => real().named('carbsPer100g')();
  RealColumn get fiberPer100g => real().named('fiberPer100g')();
  IntColumn get sourceFdcId => integer().named('sourceFdcId').nullable()();
  TextColumn get sourceBarcode => text().named('sourceBarcode').nullable()();
  BoolColumn get hidden =>
      boolean().named('hidden').withDefault(const Constant(false))();
}

@DataClassName('FoodUnit')
class FoodUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get foodId => integer().named('foodId').references(Foods, #id)();
  TextColumn get unitName => text().named('unitName')();
  RealColumn get gramsPerUnit => real().named('gramsPerUnit')();
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
  IntColumn get ingredientFoodId =>
      integer().nullable().references(Foods, #id)();
  @ReferenceName('IngredientRecipes')
  IntColumn get ingredientRecipeId =>
      integer().nullable().references(Recipes, #id)();
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
