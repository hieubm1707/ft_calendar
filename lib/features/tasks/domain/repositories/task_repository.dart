import 'package:dartz/dartz.dart';

import '../../../../core/error/index.dart';
import '../entities/task_instance.dart';
import '../entities/task_schedule.dart';

abstract class TaskRepository {
  Future<Either<Failure, Unit>> createSchedule(TaskSchedule schedule);

  Future<Either<Failure, List<TaskInstance>>> getInstances({
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, Unit>> setDone({
    required int scheduleId,
    required DateTime date,
    required bool done,
  });

  /// Huỷ lịch lặp (active = false) — dừng sinh instance tương lai.
  Future<Either<Failure, Unit>> cancelSchedule(int scheduleId);

  /// Xoá hẳn lịch task (kèm trạng thái hoàn thành).
  Future<Either<Failure, Unit>> deleteSchedule(int scheduleId);
}
