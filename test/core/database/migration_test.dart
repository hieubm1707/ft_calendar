import 'package:drift/native.dart';
import 'package:example_app/core/database/drift/index.dart';
import 'package:flutter_test/flutter_test.dart';

/// Schema của bản v5 (trước khi có focus tag và typing).
const _v5Schema = '''
CREATE TABLE IF NOT EXISTS "event_table" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "title" TEXT NOT NULL, "description" TEXT NULL, "start_time" INTEGER NOT NULL, "end_time" INTEGER NOT NULL, "is_all_day" INTEGER NOT NULL DEFAULT 0, "color" INTEGER NOT NULL DEFAULT 4280391411);
CREATE TABLE IF NOT EXISTS "task_schedule_table" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "title" TEXT NOT NULL, "type" TEXT NOT NULL, "dates_csv" TEXT NULL, "weekdays_mask" INTEGER NOT NULL DEFAULT 0, "start_date" INTEGER NOT NULL, "active" INTEGER NOT NULL DEFAULT 1, "color" INTEGER NOT NULL DEFAULT 4278236070, "created_at" INTEGER NOT NULL, "note" TEXT NULL, "minutes_of_day" INTEGER NULL);
CREATE TABLE IF NOT EXISTS "task_completion_table" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "schedule_id" INTEGER NOT NULL, "date" INTEGER NOT NULL, "done" INTEGER NOT NULL DEFAULT 0);
CREATE TABLE IF NOT EXISTS "pomodoro_session_table" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "started_at" INTEGER NOT NULL, "ended_at" INTEGER NOT NULL, "focus_seconds" INTEGER NOT NULL, "planned_seconds" INTEGER NOT NULL, "completed" INTEGER NOT NULL DEFAULT 1, "label" TEXT NULL, "task_schedule_id" INTEGER NULL);
''';

/// Phần schema mà bản v6 thêm vào.
const _v6Additions = '''
CREATE TABLE IF NOT EXISTS "focus_tag_table" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "title" TEXT NOT NULL, "minutes" INTEGER NOT NULL, "color" INTEGER NOT NULL DEFAULT 4278236070, "emoji" TEXT NULL, "sort_order" INTEGER NOT NULL DEFAULT 0);
ALTER TABLE "pomodoro_session_table" ADD COLUMN "focus_tag_id" INTEGER NULL;
''';

/// Mở AppDatabase trên một DB in-memory đã dựng sẵn bằng [setupSql] và đặt
/// `user_version` = [userVersion], để ép chạy đúng nhánh onUpgrade cần thử.
AppDatabase _openWith({required String setupSql, required int userVersion}) {
  return AppDatabase.forTesting(NativeDatabase.memory(setup: (raw) {
    raw.execute(setupSql);
    raw.execute('PRAGMA user_version = $userVersion;');
  }));
}

Future<Set<String>> _tables(AppDatabase db) async {
  final rows = await db
      .customSelect("SELECT name FROM sqlite_master WHERE type = 'table';")
      .get();
  return rows.map((r) => r.read<String>('name')).toSet();
}

Future<Set<String>> _columns(AppDatabase db, String table) async {
  final rows = await db.customSelect('PRAGMA table_info($table);').get();
  return rows.map((r) => r.read<String>('name')).toSet();
}

void main() {
  test('DB v5 sạch nâng lên v7: có đủ bảng và cột mới', () async {
    final db = _openWith(setupSql: _v5Schema, userVersion: 5);
    addTearDown(db.close);

    expect(await _tables(db), containsAll(['focus_tag_table', 'typing_result_table']));
    expect(await _columns(db, 'pomodoro_session_table'), contains('focus_tag_id'));
  });

  // Đúng trạng thái gặp trên máy macOS: schema đã có phần của v6 nhưng
  // user_version vẫn là 5 (migration lần trước chết giữa chừng).
  // Migration cũ ném "duplicate column name: focus_tag_id" rồi rollback nên
  // typing_result_table không bao giờ được tạo.
  test('DB nửa vời (user_version 5 nhưng schema đã ở v6) vẫn tự chữa được',
      () async {
    final db = _openWith(
      setupSql: '$_v5Schema$_v6Additions',
      userVersion: 5,
    );
    addTearDown(db.close);

    expect(await _tables(db), contains('typing_result_table'));
    expect(await _columns(db, 'pomodoro_session_table'), contains('focus_tag_id'));

    // Và dùng được thật, không chỉ tồn tại.
    await db.typingDao.insertResult(TypingResultTableCompanion.insert(
      takenAt: DateTime(2026, 9, 4, 10, 30),
      language: 'vi',
      mode: 'words',
      durationSeconds: 60,
      elapsedSeconds: 60,
      typedChars: 200,
      correctChars: 190,
      incorrectChars: 10,
      correctWords: 38,
      wpm: 38,
      accuracy: 0.95,
    ));
    final saved = await db.typingDao.getResults(
      from: DateTime(2026, 9, 4),
      to: DateTime(2026, 9, 5),
    );
    expect(saved, hasLength(1));
    expect(saved.single.wpm, 38);
  });

  test('DB v1 (thiếu cả description lẫn color) nâng lên v7 đủ cột', () async {
    final db = _openWith(
      setupSql:
          'CREATE TABLE IF NOT EXISTS "event_table" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "title" TEXT NOT NULL, "start_time" INTEGER NOT NULL, "end_time" INTEGER NOT NULL, "is_all_day" INTEGER NOT NULL DEFAULT 0);',
      userVersion: 1,
    );
    addTearDown(db.close);

    expect(await _columns(db, 'event_table'),
        containsAll(['description', 'color']));
    expect(await _tables(db), containsAll(['task_schedule_table', 'typing_result_table']));
  });

  test('chạy migration 2 lần liên tiếp không lỗi (idempotent)', () async {
    // user_version 6 nhưng schema đã đủ của v7 — bước nào cũng phải bỏ qua êm.
    final db = _openWith(
      setupSql: '$_v5Schema$_v6Additions',
      userVersion: 6,
    );
    addTearDown(db.close);

    expect(await _tables(db), contains('typing_result_table'));
  });
}
