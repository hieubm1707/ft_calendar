import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:example_app/core/database/drift/index.dart';
import 'package:example_app/features/tracking/data/index.dart';
import 'package:example_app/features/tracking/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TrackingRepositoryImpl repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = TrackingRepositoryImpl(
      TrackingDriftDataSource(db.trackingDao, db.taskDao),
    );
  });
  tearDown(() => db.close());

  Future<int> addTask(String type, {bool active = true, int mask = 0}) =>
      db.taskDao.insertSchedule(
        TaskScheduleTableCompanion.insert(
          title: 'Task $type',
          type: type,
          startDate: DateTime(2026, 10, 1),
          createdAt: DateTime(2026, 10, 1),
          weekdaysMask: Value(mask),
          active: Value(active),
        ),
      );

  Future<TrackingOverview> overview() async =>
      (await repo.getOverview()).getOrElse(() => throw 'failed');

  test('lưu, đọc lại, sửa rồi xoá mục tiêu tự tạo', () async {
    final goal = TrackingGoal(
      name: 'Đọc sách',
      frequency: TrackingFrequency.weekdays,
      weekdays: const {1, 3},
      startDate: DateTime(2026, 10, 1, 15),
      reminders: const [1260, 480],
    );
    final id = (await repo.saveGoal(goal)).getOrElse(() => -1);
    var saved = (await overview()).goals.single;
    expect(saved.id, id);
    expect(saved.weekdays, {1, 3});
    expect(saved.startDate, DateTime(2026, 10, 1));
    expect(saved.reminders, [480, 1260]);

    await repo.saveGoal(
      TrackingGoal(
        id: id,
        name: 'Đọc sách 30p',
        startDate: DateTime(2026, 10, 1),
      ),
    );
    saved = (await overview()).goals.single;
    expect(saved.name, 'Đọc sách 30p');
    expect(saved.frequency, TrackingFrequency.daily);
    expect(saved.reminders, isEmpty);

    await repo.setCheckin(goal: saved, date: DateTime(2026, 10, 2), done: true);
    await repo.deleteGoal(id);
    final o = await overview();
    expect(o.goals, isEmpty);
    expect(o.checkins, isEmpty);
  });

  test('chỉ task hằng tuần đang hoạt động mới thành mục tiêu', () async {
    final weekly = await addTask('weekly', mask: 0x15); // T2, T4, T6
    await addTask('dates');
    await addTask('weekly', active: false, mask: 127);

    final goals = (await overview()).goals;
    expect(goals, hasLength(1));
    expect(goals.single.source, TrackingSource.task);
    expect(goals.single.id, weekly);
    expect(goals.single.activeWeekdays, {1, 3, 5});
  });

  test(
    'check-in mục tiêu từ Tasks ghi vào trạng thái hoàn thành của task (2 chiều)',
    () async {
      final weekly = await addTask('weekly', mask: 127);
      final goal = (await overview()).goals.single;
      final day = DateTime(2026, 10, 5);

      await repo.setCheckin(goal: goal, date: day, done: true);
      final completions = await db.taskDao.getCompletions();
      expect(completions.single.scheduleId, weekly);
      expect(completions.single.done, isTrue);
      expect(db.trackingDao.getCheckins(), completion(isEmpty));

      // Bên Tasks bỏ đánh dấu → Tracking thấy chưa xong.
      await db.taskDao.setDone(weekly, day, false);
      expect((await overview()).checkins, isEmpty);

      // Bên Tasks đánh dấu → Tracking thấy đã xong.
      await db.taskDao.setDone(weekly, day, true);
      final checkins = (await overview()).checkins;
      expect(
        checkins.single,
        TrackingCheckin(source: TrackingSource.task, goalId: weekly, date: day),
      );
    },
  );
}
