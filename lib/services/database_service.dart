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

  model.Food _mapFoodData(dynamic foodData, String source) {
    return model.Food(
      id: foodData.id,
      source: source,
      name: foodData.name,
      emoji: '', // Not available in the database
      calories: foodData.caloriesPer100g,
      protein: foodData.proteinPer100g,
      fat: foodData.fatPer100g,
      carbs: foodData.carbsPer100g,
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

    final liveFoods = liveFoodsData
        .map((f) => _mapFoodData(f, 'live'))
        .toList();
    final refFoods = refFoodsData
        .map((f) => _mapFoodData(f, 'reference'))
        .toList();

    return [...liveFoods, ...refFoods];
  }

  Future<List<model_unit.FoodUnit>> getUnitsForFood(model.Food food) async {
    List<dynamic> driftUnits;
    if (food.source == 'live') {
      driftUnits = await (_liveDb.select(
        _liveDb.foodUnits,
      )..where((u) => u.foodId.equals(food.id))).get();
    } else {
      // 'reference'
      driftUnits = await (_referenceDb.select(
        _referenceDb.foodUnits,
      )..where((u) => u.foodId.equals(food.id))).get();
    }
    return driftUnits
        .map(
          (u) => model_unit.FoodUnit(
            id: u.id as int,
            foodId: u.foodId as int,
            unitName: u.unitName as String,
            gramsPerUnit: u.gramsPerUnit as double,
          ),
        )
        .toList();
  }

  Future<model.Food?> getFoodByBarcode(String barcode) async {
    final food = await (_liveDb.select(
      _liveDb.foods,
    )..where((f) => f.sourceBarcode.equals(barcode))).getSingleOrNull();
    return food == null ? null : _mapFoodData(food, 'live');
  }

  Future<model.Food?> getFoodBySourceFdcId(int fdcId) async {
    final food = await (_liveDb.select(
      _liveDb.foods,
    )..where((f) => f.sourceFdcId.equals(fdcId))).getSingleOrNull();
    return food == null ? null : _mapFoodData(food, 'live');
  }

  Future<model.Food> saveFood(model.Food food) async {
    final companion = FoodsCompanion.insert(
      name: food.name,
      source: food.id == 0 ? 'off_cache' : 'user_created',
      caloriesPer100g: food.calories,
      proteinPer100g: food.protein,
      fatPer100g: food.fat,
      carbsPer100g: food.carbs,
      fiberPer100g: 0, // Default value
      sourceFdcId: Value(food.id == 0 ? null : food.id),
    );
    final newFoodData = await _liveDb.into(_liveDb.foods).insert(companion);
    return _mapFoodData(newFoodData, 'live');
  }
}
