import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/event_dao.dart';
import 'daos/focus_tag_dao.dart';
import 'daos/pomodoro_dao.dart';
import 'daos/remote_device_dao.dart';
import 'daos/task_dao.dart';
import 'daos/typing_content_dao.dart';
import 'daos/typing_dao.dart';
import 'tables/event_table.dart';
import 'tables/focus_tag_table.dart';
import 'tables/pomodoro_table.dart';
import 'tables/remote_device_table.dart';
import 'tables/task_table.dart';
import 'tables/typing_content_table.dart';
import 'tables/typing_table.dart';

part 'app_database.g.dart';

/// DB duy nhất của app. Thêm feature mới = thêm table vào đây + 1 DAO.
@DriftDatabase(
  tables: [
    EventTable,
    TaskScheduleTable,
    TaskCompletionTable,
    PomodoroSessionTable,
    FocusTagTable,
    TypingResultTable,
    TypingContentPackTable,
    RemoteDeviceTable,
  ],
  daos: [
    EventDao,
    TaskDao,
    PomodoroDao,
    FocusTagDao,
    TypingDao,
    TypingContentDao,
    RemoteDeviceDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor cho test (in-memory / executor tùy biến).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        // ⚠️ KHÔNG tin tuyệt đối vào `from`. Một DB thật có thể ở trạng thái
        // NỬA VỜI: schema đã đổi nhưng `user_version` chưa kịp tăng (migration
        // lần trước chết giữa chừng). Khi đó bước `addColumn` theo số phiên bản
        // sẽ ném "duplicate column name" → cả migration rollback → DB kẹt mãi ở
        // phiên bản cũ và bảng mới không bao giờ được tạo.
        //
        // Mọi bước từ trước tới nay đều chỉ THÊM bảng/cột (không biến đổi dữ
        // liệu), nên cách chắc ăn là đối chiếu lại với schema hiện tại: tạo bảng
        // còn thiếu, thêm cột còn thiếu, bỏ qua thứ đã có. Migration nhờ vậy
        // chạy lại được nhiều lần và tự chữa DB đang hỏng.
        // Thêm cột mới về sau: khai báo ở table rồi thêm 1 dòng
        // `_addColumnIfMissing` vào đây.
        onUpgrade: (m, from, to) async {
          // createAll sinh `CREATE TABLE IF NOT EXISTS` → bảng đã có thì bỏ qua.
          await m.createAll();

          await _addColumnIfMissing(m, eventTable, eventTable.description);
          await _addColumnIfMissing(m, eventTable, eventTable.color);
          await _addColumnIfMissing(
              m, taskScheduleTable, taskScheduleTable.note);
          await _addColumnIfMissing(
              m, taskScheduleTable, taskScheduleTable.minutesOfDay);
          await _addColumnIfMissing(
              m, pomodoroSessionTable, pomodoroSessionTable.focusTagId);
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

  /// Thêm [column] vào [table] nếu bảng chưa có cột đó.
  /// SQLite không hỗ trợ `ALTER TABLE ... ADD COLUMN IF NOT EXISTS` nên phải
  /// hỏi `PRAGMA table_info` trước.
  Future<void> _addColumnIfMissing(
    Migrator m,
    TableInfo table,
    GeneratedColumn column,
  ) async {
    final info =
        await customSelect('PRAGMA table_info(${table.actualTableName});')
            .get();
    final exists = info.any((row) => row.read<String>('name') == column.name);
    if (!exists) await m.addColumn(table, column);
  }

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
