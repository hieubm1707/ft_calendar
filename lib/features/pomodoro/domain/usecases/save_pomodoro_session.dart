import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/pomodoro_session.dart';
import '../repositories/pomodoro_repository.dart';

@lazySingleton
class SavePomodoroSession implements UseCase<Unit, PomodoroSession> {
  final PomodoroRepository _repository;

  SavePomodoroSession(this._repository);

  @override
  Future<Either<Failure, Unit>> call(PomodoroSession params) {
    return _repository.saveSession(params);
  }
}
