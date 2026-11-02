import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/task_table.dart';

part 'task_dao.g.dart';

/// Truy vấn Drift cho lịch task + trạng thái hoàn thành. Chỉ SQL, không nghiệp vụ.
@DriftAccessor(tables: [TaskScheduleTable, TaskCompletionTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Future<int> insertSchedule(TaskScheduleTableCompanion schedule) {
    return into(taskScheduleTable).insert(schedule);
  }

  Future<List<TaskScheduleTableData>> getSchedules() {
    return select(taskScheduleTable).get();
  }

  Future<void> setScheduleActive(int id, bool active) {
    return (update(taskScheduleTable)..where((t) => t.id.equals(id)))
        .write(TaskScheduleTableCompanion(active: Value(active)));
  }

  Future<void> deleteSchedule(int id) {
    return transaction(() async {
      await (delete(taskCompletionTable)
            ..where((t) => t.scheduleId.equals(id)))
          .go();
      await (delete(taskScheduleTable)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<List<TaskCompletionTableData>> getCompletions() {
    return select(taskCompletionTable).get();
  }

  /// Upsert trạng thái hoàn thành cho (scheduleId, date).
  Future<void> setDone(int scheduleId, DateTime date, bool done) {
    return transaction(() async {
      await (delete(taskCompletionTable)
            ..where(
                (t) => t.scheduleId.equals(scheduleId) & t.date.equals(date)))
          .go();
      await into(taskCompletionTable).insert(
        TaskCompletionTableCompanion.insert(
          scheduleId: scheduleId,
          date: date,
          done: Value(done),
        ),
      );
    });
  }
}
