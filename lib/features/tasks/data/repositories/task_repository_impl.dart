import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_mapper.dart';

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _local;

  TaskRepositoryImpl(this._local);

  @override
  Future<Either<Failure, Unit>> createSchedule(TaskSchedule schedule) async {
    try {
      await _local.createSchedule(schedule.toInsertCompanion());
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<TaskInstance>>> getInstances({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final schedules = (await _local.getSchedules()).map((r) => r.toEntity());
      final completions = await _local.getCompletions();
      final doneKeys = <String>{
        for (final c in completions)
          if (c.done) taskDoneKey(c.scheduleId, c.date),
      };
      final instances = expandTaskInstances(
        schedules: schedules.toList(),
        doneKeys: doneKeys,
        from: from,
        to: to,
      );
      return Right(instances);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> setDone({
    required int scheduleId,
    required DateTime date,
    required bool done,
  }) async {
    try {
      await _local.setDone(scheduleId, _dayOnly(date), done);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelSchedule(int scheduleId) async {
    try {
      await _local.setActive(scheduleId, false);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSchedule(int scheduleId) async {
    try {
      await _local.deleteSchedule(scheduleId);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
