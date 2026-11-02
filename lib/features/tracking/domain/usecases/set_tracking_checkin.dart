import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/tracking_goal.dart';
import '../repositories/tracking_repository.dart';

@lazySingleton
class SetTrackingCheckin implements UseCase<Unit, SetTrackingCheckinParams> {
  final TrackingRepository _repository;

  SetTrackingCheckin(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SetTrackingCheckinParams params) {
    return _repository.setCheckin(
      goal: params.goal,
      date: params.date,
      done: params.done,
    );
  }
}

class SetTrackingCheckinParams extends Equatable {
  final TrackingGoal goal;
  final DateTime date;
  final bool done;

  const SetTrackingCheckinParams({
    required this.goal,
    required this.date,
    required this.done,
  });

  @override
  List<Object?> get props => [goal, date, done];
}
