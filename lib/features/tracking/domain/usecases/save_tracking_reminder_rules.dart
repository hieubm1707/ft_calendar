import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/tracking_reminder_rule.dart';
import '../repositories/tracking_reminder_repository.dart';

@lazySingleton
class SaveTrackingReminderRules
    implements UseCase<Unit, List<TrackingReminderRule>> {
  final TrackingReminderRepository _repository;

  SaveTrackingReminderRules(this._repository);

  @override
  Future<Either<Failure, Unit>> call(List<TrackingReminderRule> params) {
    return _repository.saveRules(params);
  }
}
