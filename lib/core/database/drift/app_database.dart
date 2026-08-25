import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/event_dao.dart';
import 'daos/focus_tag_dao.dart';
import 'daos/pomodoro_dao.dart';
import 'daos/task_dao.dart';
import 'tables/event_table.dart';
import 'tables/focus_tag_table.dart';
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
    FocusTagTable,
  ],
  daos: [EventDao, TaskDao, PomodoroDao, FocusTagDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor cho test (in-memory / executor tùy biến).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

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
          if (from < 6) {
            await m.createTable(focusTagTable);
            await m.addColumn(
                pomodoroSessionTable, pomodoroSessionTable.focusTagId);
          }
        },
        // Seed tag mặc định 1 lần (cài mới hoặc vừa nâng cấp lên v6).
        // Không seed lại nếu người dùng đã tự xoá hết tag.
        beforeOpen: (details) async {
          if (details.wasCreated || details.hadUpgrade) {
            await _seedFocusTagsIfEmpty();
          }
        },
      );

  /// 5 tag có sẵn khi mới cài — người dùng sửa tên/số phút hoặc xoá tuỳ ý.
  static const _defaultFocusTags = [
    (title: 'Work', minutes: 25, color: 0xFF4C8DFF, emoji: '💼'),
    (title: 'Read', minutes: 30, color: 0xFFFFA726, emoji: '📖'),
    (title: 'Fitness', minutes: 10, color: 0xFF66BB6A, emoji: '🏃'),
    (title: 'Focus', minutes: 25, color: 0xFF00B3A6, emoji: '🎯'),
    (title: 'Study', minutes: 45, color: 0xFFAB47BC, emoji: '📚'),
  ];

  Future<void> _seedFocusTagsIfEmpty() async {
    final existing = await select(focusTagTable).get();
    if (existing.isNotEmpty) return;
    await batch((b) {
      b.insertAll(focusTagTable, [
        for (var i = 0; i < _defaultFocusTags.length; i++)
          FocusTagTableCompanion.insert(
            title: _defaultFocusTags[i].title,
            minutes: _defaultFocusTags[i].minutes,
            color: Value(_defaultFocusTags[i].color),
            emoji: Value(_defaultFocusTags[i].emoji),
            sortOrder: Value(i),
          ),
      ]);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ft_calender.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
