import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';
import '../datasources/tracking_local_datasource.dart';
import '../models/tracking_mapper.dart';

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

@LazySingleton(as: TrackingRepository)
class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingLocalDataSource _local;

  TrackingRepositoryImpl(this._local);

  @override
  Future<Either<Failure, TrackingOverview>> getOverview() async {
    try {
      final goals = (await _local.getGoals()).map((r) => r.toEntity());
      final weekly = (await _local.getTaskSchedules())
          .where((r) => r.isActiveWeekly)
          .toList();
      final weeklyIds = {for (final r in weekly) r.id};

      final checkins = [
        ...(await _local.getCheckins()).map((r) => r.toEntity()),
        for (final c in await _local.getTaskCompletions())
          if (c.done && weeklyIds.contains(c.scheduleId)) c.toTrackingCheckin(),
      ];
      return Right(
        TrackingOverview(
          goals: [...goals, ...weekly.map((r) => r.toTrackingGoal())],
          checkins: checkins,
        ),
      );
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, int>> saveGoal(TrackingGoal goal) async {
    try {
      final id = goal.id;
      if (id == null) {
        return Right(
          await _local.insertGoal(goal.toInsertCompanion(DateTime.now())),
        );
      }
      await _local.updateGoal(id, goal.toCompanion());
      return Right(id);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteGoal(int goalId) async {
    try {
      await _local.deleteGoal(goalId);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> setCheckin({
    required TrackingGoal goal,
    required DateTime date,
    required bool done,
  }) async {
    try {
      final id = goal.id!;
      final day = _dayOnly(date);
      if (goal.isFromTask) {
        await _local.setTaskDone(id, day, done);
      } else {
        await _local.setCheckin(id, day, done);
      }
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
