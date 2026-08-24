import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/event_dao.dart';
import 'daos/pomodoro_dao.dart';
import 'daos/task_dao.dart';
import 'tables/event_table.dart';
import 'tables/pomodoro_table.dart';
import 'tables/task_table.dart';

part 'app_database.g.dart';

/// DB duy nhất của app. Thêm feature mới = thêm table vào đây + 1 DAO.
@DriftDatabase(
  tables: [
    EventTable,
    TaskScheduleTable,
    TaskCompletionTable,
    PomodoroSessionTable,
  ],
  daos: [EventDao, TaskDao, PomodoroDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor cho test (in-memory / executor tùy biến).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(eventTable, eventTable.color);
          }
          if (from < 3) {
            await m.createTable(taskScheduleTable);
            await m.createTable(taskCompletionTable);
          }
          if (from < 4) {
            await m.addColumn(taskScheduleTable, taskScheduleTable.note);
            await m.addColumn(
                taskScheduleTable, taskScheduleTable.minutesOfDay);
          }
          if (from < 5) {
            await m.createTable(pomodoroSessionTable);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ft_calender.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
