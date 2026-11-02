import 'package:injectable/injectable.dart';

import '../../../../core/database/drift/index.dart';
import '../../../../core/error/index.dart';

/// Truy cập DB cục bộ (Drift) cho tracking. Ngoài bảng riêng còn đọc/ghi lịch
/// task hằng tuần + trạng thái hoàn thành của chúng (cùng 1 DB) để 2 tính năng
/// dùng chung dữ liệu, không sao chép.
abstract class TrackingLocalDataSource {
  Future<List<TrackingGoalTableData>> getGoals();
  Future<List<TrackingCheckinTableData>> getCheckins();
  Future<int> insertGoal(TrackingGoalTableCompanion goal);
  Future<void> updateGoal(int id, TrackingGoalTableCompanion goal);
  Future<void> deleteGoal(int id);
  Future<void> setCheckin(int goalId, DateTime date, bool done);

  Future<List<TaskScheduleTableData>> getTaskSchedules();
  Future<List<TaskCompletionTableData>> getTaskCompletions();
  Future<void> setTaskDone(int scheduleId, DateTime date, bool done);
}

@LazySingleton(as: TrackingLocalDataSource)
class TrackingDriftDataSource implements TrackingLocalDataSource {
  final TrackingDao _dao;
  final TaskDao _taskDao;

  TrackingDriftDataSource(this._dao, this._taskDao);

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<TrackingGoalTableData>> getGoals() => _guard(_dao.getGoals);

  @override
  Future<List<TrackingCheckinTableData>> getCheckins() =>
      _guard(_dao.getCheckins);

  @override
  Future<int> insertGoal(TrackingGoalTableCompanion goal) =>
      _guard(() => _dao.insertGoal(goal));

  @override
  Future<void> updateGoal(int id, TrackingGoalTableCompanion goal) =>
      _guard(() => _dao.updateGoal(id, goal));

  @override
  Future<void> deleteGoal(int id) => _guard(() => _dao.deleteGoal(id));

  @override
  Future<void> setCheckin(int goalId, DateTime date, bool done) =>
      _guard(() => _dao.setCheckin(goalId, date, done));

  @override
  Future<List<TaskScheduleTableData>> getTaskSchedules() =>
      _guard(_taskDao.getSchedules);

  @override
  Future<List<TaskCompletionTableData>> getTaskCompletions() =>
      _guard(_taskDao.getCompletions);

  @override
  Future<void> setTaskDone(int scheduleId, DateTime date, bool done) =>
      _guard(() => _taskDao.setDone(scheduleId, date, done));
}
