import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/tracking_checkin.dart';
import '../repositories/tracking_repository.dart';

@lazySingleton
class GetTrackingOverview implements UseCase<TrackingOverview, NoParams> {
  final TrackingRepository _repository;

  GetTrackingOverview(this._repository);

  @override
  Future<Either<Failure, TrackingOverview>> call(NoParams params) {
    return _repository.getOverview();
  }
}
