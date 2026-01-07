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
  ],
)
class LiveDatabase extends _$LiveDatabase {
  LiveDatabase({required QueryExecutor connection}) : super(connection);

  @override
  int get schemaVersion => 4;

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
          // This was the old addColumn for loggedFoods, technically irrelevant now if we drop the table below,
          // but we keep history for correctness of sequential upgrades found in old versions.
          // However, since we are doing a destructive update in version 4, prior logical steps might fail if the table is gone.
          // Standard Drift practice: migration steps run sequentially.
          // But since from < 3 is OLD, and we are now moving to 4...
          // If a user is on v2, they go v2->v3->v4.
          // v2->v3 adds column to loggedFoods.
          // v3->v4 deletes loggedFoods.
          // So it's fine.
          try {
            // Use raw SQL or check if table exists to avoid errors if we messed up generated headers?
            // Actually, 'loggedFoods' accessor might be missing from 'this' if I removed the table from the annotation.
            // Accessors like 'loggedFoods' are generated in _$LiveDatabase.
            // If I remove them from @DriftDatabase, _$LiveDatabase won't have 'loggedFoods'.
            // So I CANNOT use 'loggedFoods' in the code here if it's not in the tables list.
            // This is a Catch-22 in Drift when removing tables.
            // Solution: Use m.deleteTable('logged_foods') if possible, or just ignore errors?
            // Drift's Migator uses TableInfo.
            // Since TableInfo is gone, I can't use the typed variable.
            // I must use customStatement('DROP TABLE IF EXISTS logged_foods');
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
