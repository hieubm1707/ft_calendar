import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../repositories/pomodoro_repository.dart';

@lazySingleton
class DeletePomodoroSession implements UseCase<Unit, int> {
  final PomodoroRepository _repository;

  DeletePomodoroSession(this._repository);

  @override
  Future<Either<Failure, Unit>> call(int params) {
    return _repository.deleteSession(params);
  }
}
