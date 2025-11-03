
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:free_cal_counter1/data/database/tables.dart';

part 'live_database.g.dart';

@DriftDatabase(tables: [Foods, FoodUnits, Recipes, RecipeItems, LoggedFoods])
class LiveDatabase extends _$LiveDatabase {
  LiveDatabase({required QueryExecutor connection}) : super(connection);

  @override
  int get schemaVersion => 1;
}

QueryExecutor openLiveConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'live.db'));
    return NativeDatabase(file);
  });
}
