import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';
import '../datasources/tracking_reminder_local_datasource.dart';
import '../models/tracking_reminder_rule_mapper.dart';

@LazySingleton(as: TrackingReminderRepository)
class TrackingReminderRepositoryImpl implements TrackingReminderRepository {
  final TrackingReminderLocalDataSource _local;

  TrackingReminderRepositoryImpl(this._local);

  @override
  Future<Either<Failure, List<TrackingReminderRule>>> getRules() async {
    try {
      final raw = await _local.getRules();
      if (raw == null) return const Right(TrackingReminderRule.defaults);
      final rules = raw.map(trackingReminderRuleFromJson).toList()
        ..sort((a, b) => a.minutes.compareTo(b.minutes));
      return Right(rules);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveRules(
    List<TrackingReminderRule> rules,
  ) async {
    try {
      await _local.saveRules(rules.map((r) => r.toJson()).toList());
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
