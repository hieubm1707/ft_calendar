import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../repositories/task_repository.dart';

/// Gỡ một lịch task: [hard]=true xoá hẳn (dùng cho task ngày cụ thể),
/// [hard]=false huỷ lặp (active=false, dùng cho task hàng tuần).
@lazySingleton
class RemoveTaskSchedule implements UseCase<Unit, RemoveTaskScheduleParams> {
  final TaskRepository _repository;

  RemoveTaskSchedule(this._repository);

  @override
  Future<Either<Failure, Unit>> call(RemoveTaskScheduleParams params) {
    return params.hard
        ? _repository.deleteSchedule(params.scheduleId)
        : _repository.cancelSchedule(params.scheduleId);
  }
}

class RemoveTaskScheduleParams extends Equatable {
  final int scheduleId;
  final bool hard;

  const RemoveTaskScheduleParams({required this.scheduleId, required this.hard});

  @override
  List<Object?> get props => [scheduleId, hard];
}
