import 'package:dartz/dartz.dart';

import '../../../../core/error/index.dart';
import '../entities/tracking_reminder_rule.dart';

abstract class TrackingReminderRepository {
  /// Bộ nhắc đã lưu; chưa từng lưu thì trả [TrackingReminderRule.defaults].
  Future<Either<Failure, List<TrackingReminderRule>>> getRules();

  Future<Either<Failure, Unit>> saveRules(List<TrackingReminderRule> rules);
}
