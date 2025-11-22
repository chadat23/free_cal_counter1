import 'package:drift/drift.dart';

import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/models/food_serving.dart' as model_serving;
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
