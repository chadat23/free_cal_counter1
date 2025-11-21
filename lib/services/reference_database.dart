import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:free_cal_counter1/data/database/tables.dart';

part 'reference_database.g.dart';

@DriftDatabase(tables: [Foods, FoodPortions])
class ReferenceDatabase extends _$ReferenceDatabase {
  ReferenceDatabase({required QueryExecutor connection}) : super(connection);

  @override
  int get schemaVersion => 1;
}

Future<QueryExecutor> openReferenceConnection() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'reference.db'));

  if (!await file.exists()) {
    final blob = await rootBundle.load('assets/reference.db');
    final buffer = blob.buffer;
    await file.writeAsBytes(
      buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
    );
  }

  return NativeDatabase(file);
}
