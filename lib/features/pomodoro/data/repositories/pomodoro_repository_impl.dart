import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';
import '../datasources/pomodoro_local_datasource.dart';
import '../models/pomodoro_mapper.dart';

@LazySingleton(as: PomodoroRepository)
class PomodoroRepositoryImpl implements PomodoroRepository {
  final PomodoroLocalDataSource _local;

  PomodoroRepositoryImpl(this._local);

  @override
  Future<Either<Failure, Unit>> saveSession(PomodoroSession session) async {
    try {
      await _local.insertSession(session.toInsertCompanion());
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<PomodoroSession>>> getSessions({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final rows = await _local.getSessions(from: from, to: to);
      return Right(rows.map((r) => r.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSession(int id) async {
    try {
      await _local.deleteSession(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
