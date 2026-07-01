import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/event_dao.dart';
import 'tables/event_table.dart';

part 'app_database.g.dart';

/// DB duy nhất của app. Thêm feature mới = thêm table vào đây + 1 DAO.
@DriftDatabase(tables: [EventTable], daos: [EventDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor cho test (in-memory / executor tùy biến).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ft_calender.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
