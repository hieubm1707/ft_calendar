import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../repositories/tracking_repository.dart';

@lazySingleton
class DeleteTrackingGoal implements UseCase<Unit, int> {
  final TrackingRepository _repository;

  DeleteTrackingGoal(this._repository);

  @override
  Future<Either<Failure, Unit>> call(int params) {
    return _repository.deleteGoal(params);
  }
}
