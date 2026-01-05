import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:free_cal_counter1/data/database/tables.dart';

part 'live_database.g.dart';

@DriftDatabase(
  tables: [
    Foods,
    FoodPortions,
    Recipes,
    RecipeItems,
    Categories,
    RecipeCategoryLinks,
    LoggedFoods,
    LoggedFoodServings,
    LoggedPortions,
  ],
)
class LiveDatabase extends _$LiveDatabase {
  LiveDatabase({required QueryExecutor connection}) : super(connection);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Add parentId to Foods
          await m.addColumn(foods, foods.parentId);
          // Create new tables
          await m.createTable(recipes);
          await m.createTable(recipeItems);
          await m.createTable(categories);
          await m.createTable(recipeCategoryLinks);
        }
        if (from < 3) {
          await m.addColumn(loggedFoods, loggedFoods.originalFoodSource);
        }
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          // Initialize categories or other data if needed
        }
      },
    );
  }
}

Future<File> getLiveDbFile() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  return File(p.join(dbFolder.path, 'live.db'));
}

QueryExecutor openLiveConnection() {
  return LazyDatabase(() async {
    return NativeDatabase(await getLiveDbFile());
  });
}
