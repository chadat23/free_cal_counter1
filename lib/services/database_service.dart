import 'package:drift/drift.dart';

import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/models/food_serving.dart' as model_serving;
import 'package:free_cal_counter1/models/food_portion.dart' as model;
import 'package:free_cal_counter1/models/logged_food.dart' as model;
import 'package:free_cal_counter1/models/recipe.dart' as model;
import 'package:free_cal_counter1/models/recipe_item.dart' as model;
import 'package:free_cal_counter1/models/category.dart' as model;
import 'package:free_cal_counter1/services/live_database.dart';
import 'package:free_cal_counter1/models/daily_macro_stats.dart' as model_stats;
import 'package:free_cal_counter1/services/reference_database.dart'
    hide FoodPortion, FoodsCompanion, FoodPortionsCompanion;

class DatabaseService {
  late LiveDatabase _liveDb;
  late ReferenceDatabase _referenceDb;

  static final DatabaseService instance = DatabaseService._internal();

  DatabaseService._internal();

  factory DatabaseService.forTesting(
    LiveDatabase liveDb,
    ReferenceDatabase referenceDb,
  ) {
    return DatabaseService._internal()
      .._liveDb = liveDb
      .._referenceDb = referenceDb;
  }

  static void initSingletonForTesting(
    LiveDatabase liveDb,
    ReferenceDatabase referenceDb,
  ) {
    instance._liveDb = liveDb;
    instance._referenceDb = referenceDb;
  }

  Future<void> init() async {
    _liveDb = LiveDatabase(connection: openLiveConnection());
    _referenceDb = ReferenceDatabase(
      connection: await openReferenceConnection(),
    );
  }

  model.Food _mapFoodData(
    dynamic foodData,
    List<model_serving.FoodServing> servings,
  ) {
    return model.Food(
      id: foodData.id,
      source: foodData.source,
      name: foodData.name,
      emoji: '', // Not available in the database
      calories: foodData.caloriesPerGram,
      protein: foodData.proteinPerGram,
      fat: foodData.fatPerGram,
      carbs: foodData.carbsPerGram,
      fiber: foodData.fiberPerGram,
      servings: servings,
    );
  }

  Future<List<model.Food>> searchFoodsByName(String query) async {
    if (query.isEmpty) return [];
    final lowerCaseQuery = '%${query.toLowerCase()}%';

    final liveFoodsData = await (_liveDb.select(
      _liveDb.foods,
    )..where((f) => f.name.lower().like(lowerCaseQuery))).get();

    final refFoodsData = await (_referenceDb.select(
      _referenceDb.foods,
    )..where((f) => f.name.lower().like(lowerCaseQuery))).get();

    final List<model.Food> liveFoods = [];
    for (final foodData in liveFoodsData) {
      final servings = await getServingsForFood(foodData.id, foodData.source);
      liveFoods.add(_mapFoodData(foodData, servings));
    }

    final List<model.Food> refFoods = [];
    for (final foodData in refFoodsData) {
      final servings = await getServingsForFood(foodData.id, foodData.source);
      refFoods.add(_mapFoodData(foodData, servings));
    }

    return [...liveFoods, ...refFoods];
  }

  Future<List<model_serving.FoodServing>> getServingsForFood(
    int foodId,
    String foodSource,
  ) async {
    List<dynamic> driftServings;
    if (foodSource == 'live') {
      driftServings = await (_liveDb.select(
        _liveDb.foodPortions,
      )..where((s) => s.foodId.equals(foodId))).get();
    } else {
      // 'foundation' or 'reference'
      driftServings = await (_referenceDb.select(
        _referenceDb.foodPortions,
      )..where((s) => s.foodId.equals(foodId))).get();
    }
    final servings = driftServings
        .map(
          (s) => model_serving.FoodServing(
            id: s.id as int,
            foodId: s.foodId as int,
            unit: s.unit as String,
            grams: s.grams as double,
            quantity: s.quantity as double,
          ),
        )
        .toList();

    // Ensure 'g' is always an option
    if (!servings.any((s) => s.unit == 'g')) {
      servings.add(
        model_serving.FoodServing(
          foodId: foodId,
          unit: 'g',
          grams: 1.0,
          quantity: 1.0,
        ),
      );
    }

    return servings;
  }

  Future<String?> getLastLoggedUnit(int originalFoodId) async {
    // We need to find the last LoggedPortion associated with a LoggedFood
    // that corresponds to the given originalFoodId.
    final query =
        _liveDb.select(_liveDb.loggedPortions).join([
            innerJoin(
              _liveDb.loggedFoods,
              _liveDb.loggedFoods.id.equalsExp(
                _liveDb.loggedPortions.loggedFoodId,
              ),
            ),
          ])
          ..where(_liveDb.loggedFoods.originalFoodId.equals(originalFoodId))
          ..orderBy([
            OrderingTerm(
              expression: _liveDb.loggedPortions.logTimestamp,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(1);

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return row.readTable(_liveDb.loggedPortions).unit;
  }

  Future<model.Food?> getFoodByBarcode(String barcode) async {
    final food = await (_liveDb.select(
      _liveDb.foods,
    )..where((f) => f.sourceBarcode.equals(barcode))).getSingleOrNull();
    return food == null ? null : _mapFoodData(food, []);
  }

  Future<model.Food?> getFoodBySourceFdcId(int fdcId) async {
    final food = await (_liveDb.select(
      _liveDb.foods,
    )..where((f) => f.sourceFdcId.equals(fdcId))).getSingleOrNull();
    return food == null ? null : _mapFoodData(food, []);
  }

  Future<void> logPortions(
    List<model.FoodPortion> portions,
    DateTime logTimestamp,
  ) async {
    final timestamp = logTimestamp.millisecondsSinceEpoch;

    await _liveDb.transaction(() async {
      for (final portion in portions) {
        final food = portion.food;

        // Check if an identical food already exists in LoggedFoods
        final existingLoggedFood =
            await (_liveDb.select(_liveDb.loggedFoods)
                  ..where((t) => t.name.equals(food.name))
                  ..where((t) => t.caloriesPerGram.equals(food.calories))
                  ..where((t) => t.proteinPerGram.equals(food.protein))
                  ..where((t) => t.fatPerGram.equals(food.fat))
                  ..where((t) => t.carbsPerGram.equals(food.carbs))
                  ..where((t) => t.fiberPerGram.equals(food.fiber))
                  ..where((t) => t.originalFoodId.equals(food.id))
                  ..where((t) => t.originalFoodSource.equals(food.source)))
                .getSingleOrNull();

        int loggedFoodId;

        if (existingLoggedFood != null) {
          loggedFoodId = existingLoggedFood.id;
        } else {
          // Create new snapshot
          final newLoggedFood = await _liveDb
              .into(_liveDb.loggedFoods)
              .insertReturning(
                LoggedFoodsCompanion.insert(
                  name: food.name,
                  caloriesPerGram: food.calories,
                  proteinPerGram: food.protein,
                  fatPerGram: food.fat,
                  carbsPerGram: food.carbs,
                  fiberPerGram: food.fiber,
                  originalFoodId: Value(food.id),
                  originalFoodSource: Value(food.source),
                ),
              );
          loggedFoodId = newLoggedFood.id;

          // Save servings for this snapshot
          for (final serving in food.servings) {
            await _liveDb
                .into(_liveDb.loggedFoodServings)
                .insert(
                  LoggedFoodServingsCompanion.insert(
                    loggedFoodId: loggedFoodId,
                    unit: serving.unit,
                    grams: serving.grams,
                    quantity: serving.quantity,
                  ),
                );
          }
        }

        // Create the log entry
        await _liveDb
            .into(_liveDb.loggedPortions)
            .insert(
              LoggedPortionsCompanion.insert(
                loggedFoodId: loggedFoodId,
                logTimestamp: timestamp,
                grams: portion.grams,
                unit: portion.unit,
                quantity: portion.grams, // Placeholder
              ),
            );
      }
    });
  }

  Future<bool> isRecipeLogged(int recipeId) async {
    final rows =
        await (_liveDb.select(_liveDb.loggedFoods)..where(
              (t) =>
                  t.originalFoodId.equals(recipeId) &
                  t.originalFoodSource.equals('recipe'),
            ))
            .get();
    return rows.isNotEmpty;
  }

  Future<bool> isRecipeUsedAsIngredient(int recipeId) async {
    final rows = await (_liveDb.select(
      _liveDb.recipeItems,
    )..where((t) => t.ingredientRecipeId.equals(recipeId))).get();
    return rows.isNotEmpty;
  }

  Future<void> hideRecipe(int id) async {
    await (_liveDb.update(_liveDb.recipes)..where((t) => t.id.equals(id)))
        .write(const RecipesCompanion(hidden: Value(true)));
  }

  Future<List<model.LoggedFood>> getLoggedPortionsForDate(DateTime date) async {
    final startOfDay = DateTime(
      date.year,
      date.month,
      date.day,
    ).millisecondsSinceEpoch;
    final endOfDay = DateTime(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
      999,
    ).millisecondsSinceEpoch;

    final query =
        _liveDb.select(_liveDb.loggedPortions).join([
          innerJoin(
            _liveDb.loggedFoods,
            _liveDb.loggedFoods.id.equalsExp(
              _liveDb.loggedPortions.loggedFoodId,
            ),
          ),
        ])..where(
          _liveDb.loggedPortions.logTimestamp.isBetweenValues(
            startOfDay,
            endOfDay,
          ),
        );

    final rows = await query.get();

    final results = <model.LoggedFood>[];

    for (final row in rows) {
      final loggedFoodData = row.readTable(_liveDb.loggedFoods);
      final loggedPortionData = row.readTable(_liveDb.loggedPortions);

      // Fetch servings for this logged food
      final servingsData = await (_liveDb.select(
        _liveDb.loggedFoodServings,
      )..where((t) => t.loggedFoodId.equals(loggedFoodData.id))).get();

      final servings = servingsData
          .map(
            (s) => model_serving.FoodServing(
              id: s.id,
              foodId: loggedFoodData
                  .id, // This is the ID in LoggedFoods, not original
              unit: s.unit,
              grams: s.grams,
              quantity: s.quantity,
            ),
          )
          .toList();

      final food = model.Food(
        id: loggedFoodData.id, // Using LoggedFood ID as the food ID for the UI
        source: 'logged',
        name: loggedFoodData.name,
        calories: loggedFoodData.caloriesPerGram,
        protein: loggedFoodData.proteinPerGram,
        fat: loggedFoodData.fatPerGram,
        carbs: loggedFoodData.carbsPerGram,
        fiber: loggedFoodData.fiberPerGram,
        servings: servings,
      );

      results.add(
        model.LoggedFood(
          id: loggedPortionData.id,
          portion: model.FoodPortion(
            food: food,
            grams: loggedPortionData.grams,
            unit: loggedPortionData.unit,
          ),
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            loggedPortionData.logTimestamp,
          ),
        ),
      );
    }

    return results;
  }

  Future<model.Food> saveFood(model.Food food) async {
    final companion = FoodsCompanion.insert(
      name: food.name,
      source: food.id == 0 ? 'off_cache' : 'user_created',
      caloriesPerGram: food.calories,
      proteinPerGram: food.protein,
      fatPerGram: food.fat,
      carbsPerGram: food.carbs,
      fiberPerGram: food.fiber,
      sourceFdcId: Value(food.id == 0 ? null : food.id),
    );
    final newFoodData = await _liveDb.into(_liveDb.foods).insert(companion);
    return _mapFoodData(newFoodData, []);
  }

  Future<void> deleteLoggedPortion(int id) async {
    await (_liveDb.delete(
      _liveDb.loggedPortions,
    )..where((t) => t.id.equals(id))).go();
  }

  Future<List<model_stats.LoggedMacroDTO>> getLoggedMacrosForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final startOfDay = DateTime(
      start.year,
      start.month,
      start.day,
    ).millisecondsSinceEpoch;
    final endOfDay = DateTime(
      end.year,
      end.month,
      end.day,
      23,
      59,
      59,
      999,
    ).millisecondsSinceEpoch;

    final query =
        _liveDb.select(_liveDb.loggedPortions).join([
          innerJoin(
            _liveDb.loggedFoods,
            _liveDb.loggedFoods.id.equalsExp(
              _liveDb.loggedPortions.loggedFoodId,
            ),
          ),
        ])..where(
          _liveDb.loggedPortions.logTimestamp.isBetweenValues(
            startOfDay,
            endOfDay,
          ),
        );

    final rows = await query.get();

    return rows.map((row) {
      final loggedFoodData = row.readTable(_liveDb.loggedFoods);
      final loggedPortionData = row.readTable(_liveDb.loggedPortions);

      return model_stats.LoggedMacroDTO(
        logTimestamp: DateTime.fromMillisecondsSinceEpoch(
          loggedPortionData.logTimestamp,
        ),
        grams: loggedPortionData.grams,
        caloriesPerGram: loggedFoodData.caloriesPerGram,
        proteinPerGram: loggedFoodData.proteinPerGram,
        fatPerGram: loggedFoodData.fatPerGram,
        carbsPerGram: loggedFoodData.carbsPerGram,
        fiberPerGram: loggedFoodData.fiberPerGram,
      );
    }).toList();
  }

  Future<model.Food?> getFoodById(int id, String source) async {
    dynamic foodData;
    if (source == 'live') {
      foodData = await (_liveDb.select(
        _liveDb.foods,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
    } else {
      foodData = await (_referenceDb.select(
        _referenceDb.foods,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
    }
    if (foodData == null) return null;
    final servings = await getServingsForFood(id, source);
    return _mapFoodData(foodData, servings);
  }

  Future<List<model.Recipe>> getRecipes({bool includeHidden = false}) async {
    final query = _liveDb.select(_liveDb.recipes);
    if (!includeHidden) {
      query.where((t) => t.hidden.equals(false));
    }
    query.orderBy([
      (t) =>
          OrderingTerm(expression: t.createdTimestamp, mode: OrderingMode.desc),
    ]);

    final rows = await query.get();
    final List<model.Recipe> results = [];
    for (final row in rows) {
      results.add(await getRecipeById(row.id));
    }
    return results;
  }

  Future<List<model.Recipe>> getRecipesBySearch(String query) async {
    final searchRows = await (_liveDb.select(
      _liveDb.recipes,
    )..where((t) => t.name.contains(query) & t.hidden.equals(false))).get();

    final List<model.Recipe> results = [];
    for (final row in searchRows) {
      results.add(await getRecipeById(row.id));
    }
    return results;
  }

  Future<model.Recipe> getRecipeById(int id) async {
    final recipeData = await (_liveDb.select(
      _liveDb.recipes,
    )..where((t) => t.id.equals(id))).getSingle();

    final itemsData = await (_liveDb.select(
      _liveDb.recipeItems,
    )..where((t) => t.recipeId.equals(id))).get();

    final items = <model.RecipeItem>[];
    for (final item in itemsData) {
      model.Food? food;
      model.Recipe? subRecipe;

      if (item.ingredientFoodId != null) {
        food = await getFoodById(item.ingredientFoodId!, 'live');
      } else if (item.ingredientRecipeId != null) {
        subRecipe = await getRecipeById(item.ingredientRecipeId!);
      }

      items.add(
        model.RecipeItem(
          id: item.id,
          food: food,
          recipe: subRecipe,
          grams: item.grams,
          unit: item.unit,
        ),
      );
    }

    final categories = await getCategoriesForRecipe(id);

    return model.Recipe(
      id: recipeData.id,
      name: recipeData.name,
      servingsCreated: recipeData.servingsCreated,
      finalWeightGrams: recipeData.finalWeightGrams,
      portionName: recipeData.portionName,
      notes: recipeData.notes,
      isTemplate: recipeData.isTemplate,
      hidden: recipeData.hidden,
      parentId: recipeData.parentId,
      createdTimestamp: recipeData.createdTimestamp,
      items: items,
      categories: categories,
    );
  }

  Future<List<model.Category>> getCategoriesForRecipe(int recipeId) async {
    final query = _liveDb.select(_liveDb.recipeCategoryLinks).join([
      innerJoin(
        _liveDb.categories,
        _liveDb.categories.id.equalsExp(_liveDb.recipeCategoryLinks.categoryId),
      ),
    ])..where(_liveDb.recipeCategoryLinks.recipeId.equals(recipeId));

    final rows = await query.get();
    return rows.map((row) {
      final cat = row.readTable(_liveDb.categories);
      return model.Category(id: cat.id, name: cat.name);
    }).toList();
  }

  Future<int> saveRecipe(model.Recipe recipe) async {
    return await _liveDb.transaction(() async {
      int recipeId;

      if (recipe.id > 0) {
        recipeId = recipe.id;
        // Update basic info
        await (_liveDb.update(
          _liveDb.recipes,
        )..where((t) => t.id.equals(recipeId))).write(
          RecipesCompanion(
            name: Value(recipe.name),
            servingsCreated: Value(recipe.servingsCreated),
            finalWeightGrams: Value(recipe.finalWeightGrams),
            portionName: Value(recipe.portionName),
            notes: Value(recipe.notes),
            isTemplate: Value(recipe.isTemplate),
            hidden: Value(recipe.hidden),
            parentId: Value(recipe.parentId),
          ),
        );

        // Clear associated data for re-insertion
        await (_liveDb.delete(
          _liveDb.recipeItems,
        )..where((t) => t.recipeId.equals(recipeId))).go();
        await (_liveDb.delete(
          _liveDb.recipeCategoryLinks,
        )..where((t) => t.recipeId.equals(recipeId))).go();
      } else {
        recipeId = await _liveDb
            .into(_liveDb.recipes)
            .insert(
              RecipesCompanion.insert(
                name: recipe.name,
                servingsCreated: Value(recipe.servingsCreated),
                finalWeightGrams: Value(recipe.finalWeightGrams),
                portionName: Value(recipe.portionName),
                notes: Value(recipe.notes),
                isTemplate: Value(recipe.isTemplate),
                hidden: Value(recipe.hidden),
                parentId: Value(recipe.parentId),
                createdTimestamp: DateTime.now().millisecondsSinceEpoch,
              ),
            );
      }

      for (final item in recipe.items) {
        int? foodId;
        int? subRecipeId;

        if (item.food != null) {
          final persistedFood = await ensureFoodExists(item.food!);
          foodId = persistedFood.id;
        } else if (item.recipe != null) {
          subRecipeId = item.recipe!.id;
        }

        await _liveDb
            .into(_liveDb.recipeItems)
            .insert(
              RecipeItemsCompanion.insert(
                recipeId: recipeId,
                ingredientFoodId: Value(foodId),
                ingredientRecipeId: Value(subRecipeId),
                grams: item.grams,
                unit: item.unit,
              ),
            );
      }

      for (final category in recipe.categories) {
        await _liveDb
            .into(_liveDb.recipeCategoryLinks)
            .insert(
              RecipeCategoryLinksCompanion.insert(
                recipeId: recipeId,
                categoryId: category.id,
              ),
            );
      }

      return recipeId;
    });
  }

  Future<void> deleteRecipe(int id) async {
    final isLogged = await isRecipeLogged(id);
    final isUsed = await isRecipeUsedAsIngredient(id);

    if (isLogged || isUsed) {
      await hideRecipe(id);
    } else {
      await _liveDb.transaction(() async {
        await (_liveDb.delete(
          _liveDb.recipeItems,
        )..where((t) => t.recipeId.equals(id))).go();
        await (_liveDb.delete(
          _liveDb.recipeCategoryLinks,
        )..where((t) => t.recipeId.equals(id))).go();
        await (_liveDb.delete(
          _liveDb.recipes,
        )..where((t) => t.id.equals(id))).go();
      });
    }
  }

  Future<List<model.Category>> getCategories() async {
    final rows = await _liveDb.select(_liveDb.categories).get();
    return rows
        .map((row) => model.Category(id: row.id, name: row.name))
        .toList();
  }

  Future<int> addCategory(String name) async {
    return await _liveDb
        .into(_liveDb.categories)
        .insert(CategoriesCompanion.insert(name: name));
  }

  Future<model.Food> ensureFoodExists(model.Food food) async {
    // If it's already in the live database, return it
    if (food.source == 'live') {
      return food;
    }

    // Otherwise, check if we've already copied it (by name and macros, or barcode)
    final existingQuery = _liveDb.select(_liveDb.foods)
      ..where((t) => t.name.equals(food.name))
      ..where((t) => t.caloriesPerGram.equals(food.calories))
      ..where((t) => t.proteinPerGram.equals(food.protein));

    final existing = await existingQuery.getSingleOrNull();
    if (existing != null) {
      final servings = await getServingsForFood(existing.id, 'live');
      return _mapFoodData(existing, servings);
    }

    // If not, save it to the live database
    return await _liveDb.transaction(() async {
      final foodId = await _liveDb
          .into(_liveDb.foods)
          .insert(
            FoodsCompanion.insert(
              name: food.name,
              source: 'live',
              caloriesPerGram: food.calories,
              proteinPerGram: food.protein,
              fatPerGram: food.fat,
              carbsPerGram: food.carbs,
              fiberPerGram: food.fiber,
            ),
          );

      // Save servings
      for (final serving in food.servings) {
        await _liveDb
            .into(_liveDb.foodPortions)
            .insert(
              FoodPortionsCompanion.insert(
                foodId: foodId,
                unit: serving.unit,
                grams: serving.grams,
                quantity: serving.quantity,
              ),
            );
      }

      final servings = await getServingsForFood(foodId, 'live');
      final newFoodRow = await (_liveDb.select(
        _liveDb.foods,
      )..where((t) => t.id.equals(foodId))).getSingle();
      return _mapFoodData(newFoodRow, servings);
    });
  }
}
