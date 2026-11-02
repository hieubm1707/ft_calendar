import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/tracking_reminder_rule.dart';
import '../repositories/tracking_reminder_repository.dart';

@lazySingleton
class GetTrackingReminderRules
    implements UseCase<List<TrackingReminderRule>, NoParams> {
  final TrackingReminderRepository _repository;

  GetTrackingReminderRules(this._repository);

  @override
  Future<Either<Failure, List<TrackingReminderRule>>> call(NoParams params) {
    return _repository.getRules();
  }
}
