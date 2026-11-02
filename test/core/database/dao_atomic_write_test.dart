import 'package:drift/native.dart';
import 'package:example_app/core/database/drift/index.dart';
import 'package:flutter_test/flutter_test.dart';

/// Các thao tác gồm nhiều câu lệnh ghi phải toàn vẹn: câu sau lỗi thì câu trước
/// được hoàn tác. Trigger SQLite dùng để giả lập câu sau bị lỗi.
void main() {
  late AppDatabase db;
  final day = DateTime(2026, 11, 2);

  Future<void> failOn(String event, String table) => db.customStatement(
    "CREATE TRIGGER fail_write BEFORE $event ON $table "
    "BEGIN SELECT RAISE(ABORT, 'boom'); END;",
  );

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> addGoal() => db.trackingDao.insertGoal(
    TrackingGoalTableCompanion.insert(
      name: 'Đọc sách',
      startDate: day,
      createdAt: day,
    ),
  );

  Future<int> addSchedule() => db.taskDao.insertSchedule(
    TaskScheduleTableCompanion.insert(
      title: 'Tập thể dục',
      type: 'weekly',
      startDate: day,
      createdAt: day,
    ),
  );

  test('setCheckin lỗi khi thêm thì giữ nguyên lượt cũ', () async {
    final id = await addGoal();
    await db.trackingDao.setCheckin(id, day, true);
    await failOn('INSERT', 'tracking_checkin_table');

    await expectLater(
      db.trackingDao.setCheckin(id, day, true),
      throwsA(isA<Exception>()),
    );

    expect(await db.trackingDao.getCheckins(), hasLength(1));
  });

  test(
    'deleteGoal lỗi khi xoá mục tiêu thì giữ nguyên lượt hoàn thành',
    () async {
      final id = await addGoal();
      await db.trackingDao.setCheckin(id, day, true);
      await failOn('DELETE', 'tracking_goal_table');

      await expectLater(
        db.trackingDao.deleteGoal(id),
        throwsA(isA<Exception>()),
      );

      expect(await db.trackingDao.getCheckins(), hasLength(1));
    },
  );

  test('setDone lỗi khi thêm thì giữ nguyên trạng thái cũ', () async {
    final id = await addSchedule();
    await db.taskDao.setDone(id, day, true);
    await failOn('INSERT', 'task_completion_table');

    await expectLater(
      db.taskDao.setDone(id, day, false),
      throwsA(isA<Exception>()),
    );

    final rows = await db.taskDao.getCompletions();
    expect(rows, hasLength(1));
    expect(rows.single.done, isTrue);
  });

  test(
    'deleteSchedule lỗi khi xoá lịch thì giữ nguyên trạng thái hoàn thành',
    () async {
      final id = await addSchedule();
      await db.taskDao.setDone(id, day, true);
      await failOn('DELETE', 'task_schedule_table');

      await expectLater(
        db.taskDao.deleteSchedule(id),
        throwsA(isA<Exception>()),
      );

      expect(await db.taskDao.getCompletions(), hasLength(1));
    },
  );

  test(
    'setCheckin ghi và bỏ hoàn thành bình thường, không tạo dòng trùng',
    () async {
      final id = await addGoal();
      await db.trackingDao.setCheckin(id, day, true);
      await db.trackingDao.setCheckin(id, day, true);
      expect(await db.trackingDao.getCheckins(), hasLength(1));

      await db.trackingDao.setCheckin(id, day, false);
      expect(await db.trackingDao.getCheckins(), isEmpty);
    },
  );
}
