import 'package:drift/drift.dart';

class Foods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().named('name')();
  TextColumn get source => text().named('source')();
  TextColumn get emoji => text().named('emoji').nullable()();
  TextColumn get thumbnail => text().named('thumbnail').nullable()();
  RealColumn get caloriesPerGram => real().named('caloriesPerGram')();
  RealColumn get proteinPerGram => real().named('proteinPerGram')();
  RealColumn get fatPerGram => real().named('fatPerGram')();
  RealColumn get carbsPerGram => real().named('carbsPerGram')();
  RealColumn get fiberPerGram => real().named('fiberPerGram')();
  IntColumn get sourceFdcId => integer().named('sourceFdcId').nullable()();
  TextColumn get sourceBarcode => text().named('sourceBarcode').nullable()();
  BoolColumn get hidden =>
      boolean().named('hidden').withDefault(const Constant(false))();
  IntColumn get parentId =>
      integer().named('parentId').nullable().references(Foods, #id)();
}

@DataClassName('FoodPortion')
class FoodPortions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get foodId => integer().named('foodId').references(Foods, #id)();
  TextColumn get unit => text().named('unitName')();
  RealColumn get grams => real().named('gramsPerPortion')();
  RealColumn get quantity => real().named('quantityPerPortion')();
}

@DataClassName('Recipe')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get servingsCreated => real().withDefault(const Constant(1.0))();
  RealColumn get finalWeightGrams => real().nullable()();
  TextColumn get portionName => text().withDefault(const Constant('portion'))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isTemplate =>
      boolean().withDefault(const Constant(false))(); // "Decompose Only" mode
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
  IntColumn get parentId => integer().nullable().references(Recipes, #id)();
  IntColumn get createdTimestamp => integer()();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().customConstraint('UNIQUE')();
}

class RecipeCategoryLinks extends Table {
  IntColumn get recipeId => integer().references(Recipes, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {recipeId, categoryId},
  ];
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
  RealColumn get grams => real()();
  TextColumn get unit => text()();
}

@DataClassName('LoggedFood')
class LoggedFoods extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Snapshot of food details
  TextColumn get name => text().named('name')();
  RealColumn get caloriesPerGram => real().named('caloriesPerGram')();
  RealColumn get proteinPerGram => real().named('proteinPerGram')();
  RealColumn get fatPerGram => real().named('fatPerGram')();
  RealColumn get carbsPerGram => real().named('carbsPerGram')();
  RealColumn get fiberPerGram => real().named('fiberPerGram')();
  // Optional reference to the original food ID (if it still exists/is relevant)
  IntColumn get originalFoodId => integer().nullable()();
}

@DataClassName('LoggedFoodServing')
class LoggedFoodServings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get loggedFoodId =>
      integer().named('loggedFoodId').references(LoggedFoods, #id)();
  TextColumn get unit => text().named('unitName')();
  RealColumn get grams => real().named('gramsPerPortion')();
  RealColumn get quantity => real().named('quantityPerPortion')();
}

@DataClassName('LoggedPortion')
class LoggedPortions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get loggedFoodId =>
      integer().named('loggedFoodId').references(LoggedFoods, #id)();
  IntColumn get logTimestamp => integer()(); // Unix timestamp
  RealColumn get grams => real().named('grams')();
  TextColumn get unit => text().named('unit')();
  RealColumn get quantity => real().named('quantity')();
}
