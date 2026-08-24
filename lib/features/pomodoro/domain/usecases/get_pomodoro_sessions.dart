import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/pomodoro_session.dart';
import '../repositories/pomodoro_repository.dart';

@lazySingleton
class GetPomodoroSessions
    implements UseCase<List<PomodoroSession>, GetPomodoroSessionsParams> {
  final PomodoroRepository _repository;

  GetPomodoroSessions(this._repository);

  @override
  Future<Either<Failure, List<PomodoroSession>>> call(
      GetPomodoroSessionsParams params) {
    return _repository.getSessions(from: params.from, to: params.to);
  }
}

class GetPomodoroSessionsParams extends Equatable {
  /// Bao gồm [from], KHÔNG bao gồm [to].
  final DateTime from;
  final DateTime to;

  const GetPomodoroSessionsParams({required this.from, required this.to});

  @override
  List<Object?> get props => [from, to];
}
