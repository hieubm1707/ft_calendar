import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/task_schedule.dart';
import '../repositories/task_repository.dart';

@lazySingleton
class CreateTaskSchedule implements UseCase<Unit, TaskSchedule> {
  final TaskRepository _repository;

  CreateTaskSchedule(this._repository);

  @override
  Future<Either<Failure, Unit>> call(TaskSchedule params) {
    return _repository.createSchedule(params);
  }
}
