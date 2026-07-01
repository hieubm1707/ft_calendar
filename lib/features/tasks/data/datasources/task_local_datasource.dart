import 'package:injectable/injectable.dart';

import '../../../../core/database/drift/index.dart';
import '../../../../core/error/index.dart';

/// Truy cập DB cục bộ (Drift) cho tasks. Chỗ DUY NHẤT biết về Drift.
abstract class TaskLocalDataSource {
  Future<void> createSchedule(TaskScheduleTableCompanion schedule);
  Future<List<TaskScheduleTableData>> getSchedules();
  Future<List<TaskCompletionTableData>> getCompletions();
  Future<void> setDone(int scheduleId, DateTime date, bool done);
  Future<void> setActive(int scheduleId, bool active);
  Future<void> deleteSchedule(int scheduleId);
}

@LazySingleton(as: TaskLocalDataSource)
class TaskDriftDataSource implements TaskLocalDataSource {
  final TaskDao _dao;

  TaskDriftDataSource(this._dao);

  @override
  Future<void> createSchedule(TaskScheduleTableCompanion schedule) async {
    try {
      await _dao.insertSchedule(schedule);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<TaskScheduleTableData>> getSchedules() async {
    try {
      return await _dao.getSchedules();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<TaskCompletionTableData>> getCompletions() async {
    try {
      return await _dao.getCompletions();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> setDone(int scheduleId, DateTime date, bool done) async {
    try {
      await _dao.setDone(scheduleId, date, done);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> setActive(int scheduleId, bool active) async {
    try {
      await _dao.setScheduleActive(scheduleId, active);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> deleteSchedule(int scheduleId) async {
    try {
      await _dao.deleteSchedule(scheduleId);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
