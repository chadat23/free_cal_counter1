import 'package:drift/drift.dart';

import 'package:free_cal_counter1/models/food.dart' as model;
import 'package:free_cal_counter1/models/food_unit.dart' as model_unit;
import 'package:free_cal_counter1/services/live_database.dart';
import 'package:free_cal_counter1/services/reference_database.dart'
    hide FoodUnit, FoodsCompanion;

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

  model.Food _mapFoodData(dynamic foodData, List<model_unit.FoodUnit> units) {
    return model.Food(
      id: foodData.id,
      source: foodData.source,
      name: foodData.name,
      emoji: '', // Not available in the database
      calories: foodData.caloriesPerGram,
      protein: foodData.proteinPerGram,
      fat: foodData.fatPerGram,
      carbs: foodData.carbsPerGram,
      units: units,
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
      final units = await getUnitsForFood(foodData.id, foodData.source);
      liveFoods.add(_mapFoodData(foodData, units));
    }

    final List<model.Food> refFoods = [];
    for (final foodData in refFoodsData) {
      final units = await getUnitsForFood(foodData.id, foodData.source);
      refFoods.add(_mapFoodData(foodData, units));
    }

    return [...liveFoods, ...refFoods];
  }

  Future<List<model_unit.FoodUnit>> getUnitsForFood(int foodId, String foodSource) async {
    List<dynamic> driftUnits;
    if (foodSource == 'live') {
      driftUnits = await (_liveDb.select(
        _liveDb.foodUnits,
      )..where((u) => u.foodId.equals(foodId))).get();
    } else {
      // 'foundation' or 'reference'
      driftUnits = await (_referenceDb.select(
        _referenceDb.foodUnits,
      )..where((u) => u.foodId.equals(foodId))).get();
    }
    return driftUnits
        .map(
          (u) => model_unit.FoodUnit(
            id: u.id as int,
            foodId: u.foodId as int,
            name: u.unitName as String,
            grams: u.gramsPerUnit as double,
          ),
        )
        .toList();
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
      fiberPerGram: 0, // Default value
      sourceFdcId: Value(food.id == 0 ? null : food.id),
    );
    final newFoodData = await _liveDb.into(_liveDb.foods).insert(companion);
    return _mapFoodData(newFoodData, []);
  }
}
