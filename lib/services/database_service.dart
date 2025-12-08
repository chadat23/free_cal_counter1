import 'package:drift/drift.dart';

import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/models/food_serving.dart' as model_serving;
import 'package:free_cal_counter1/models/food_portion.dart' as model;
import 'package:free_cal_counter1/models/logged_food.dart' as model;
import 'package:free_cal_counter1/services/live_database.dart';
import 'package:free_cal_counter1/services/reference_database.dart'
    hide FoodPortion, FoodsCompanion;

class DatabaseService {
  late final LiveDatabase _liveDb;
  late final ReferenceDatabase _referenceDb;

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

  Future<void> logFoods(
    //    List<model.FoodPortion> portions, {
    //    DateTime? date,
    List<model.FoodPortion> portions,
    DateTime logTimestamp,
    //}) async {
  ) async {
    //final now = date ?? DateTime.now();
    //final timestamp = now.millisecondsSinceEpoch;
    final timestamp = logTimestamp.millisecondsSinceEpoch;

    await _liveDb.transaction(() async {
      for (final portion in portions) {
        final food = portion.food;

        // Check if an identical food already exists in LoggedFoods
        // We compare name and macros.
        // Ideally we should also compare servings, but for now name+macros is a good proxy.
        // If the user modified the food, it should be a new entry.
        final existingLoggedFood =
            await (_liveDb.select(_liveDb.loggedFoods)
                  ..where((t) => t.name.equals(food.name))
                  ..where((t) => t.caloriesPerGram.equals(food.calories))
                  ..where((t) => t.proteinPerGram.equals(food.protein))
                  ..where((t) => t.fatPerGram.equals(food.fat))
                  ..where((t) => t.carbsPerGram.equals(food.carbs))
                  ..where((t) => t.fiberPerGram.equals(food.fiber)))
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
                quantity: portion
                    .grams, // Placeholder, we might need to calc this back if unit != 'g'
              ),
            );
      }
    });
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
}
