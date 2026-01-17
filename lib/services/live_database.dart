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
    LoggedPortions,
    Weights,
  ],
)
class LiveDatabase extends _$LiveDatabase {
  LiveDatabase({required QueryExecutor connection}) : super(connection);

  @override
  int get schemaVersion => 7;

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
          try {
            // See previous comments on version 3
          } catch (e) {
            print('Migration error: $e');
          }
        }
        if (from < 4) {
          // Destructive migration for Unified Foods
          await customStatement('DROP TABLE IF EXISTS logged_foods');
          await customStatement('DROP TABLE IF EXISTS logged_food_servings');
          await customStatement('DROP TABLE IF EXISTS logged_portions');
          await m.createTable(loggedPortions);
        }
        if (from < 5) {
          // Add usageNote to Foods
          await m.addColumn(foods, foods.usageNote);
        }
        if (from < 6) {
          // Add Weights table
          await m.createTable(weights);
        }
        if (from < 7) {
          // Add isFasted to Weights
          await m.addColumn(weights, weights.isFasted);
        }
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          // Initialize categories or other data if needed
        }
        // Enable foreign_keys is usually default or handled by Drift,
        // but ensuring it is good practice if using raw SQL.
        await customStatement('PRAGMA foreign_keys = ON');
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
