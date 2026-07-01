import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../repositories/task_repository.dart';

@lazySingleton
class SetTaskDone implements UseCase<Unit, SetTaskDoneParams> {
  final TaskRepository _repository;

  SetTaskDone(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SetTaskDoneParams params) {
    return _repository.setDone(
      scheduleId: params.scheduleId,
      date: params.date,
      done: params.done,
    );
  }
}

class SetTaskDoneParams extends Equatable {
  final int scheduleId;
  final DateTime date;
  final bool done;

  const SetTaskDoneParams({
    required this.scheduleId,
    required this.date,
    required this.done,
  });

  @override
  List<Object?> get props => [scheduleId, date, done];
}
