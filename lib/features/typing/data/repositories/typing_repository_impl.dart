import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';
import '../datasources/typing_local_datasource.dart';
import '../models/typing_mapper.dart';

@LazySingleton(as: TypingRepository)
class TypingRepositoryImpl implements TypingRepository {
  final TypingLocalDataSource _local;

  TypingRepositoryImpl(this._local);

  @override
  Future<Either<Failure, Unit>> saveResult(TypingResult result) async {
    try {
      await _local.insertResult(result.toInsertCompanion());
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<TypingResult>>> getResults({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final rows = await _local.getResults(from: from, to: to);
      return Right(rows.map((r) => r.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteResult(int id) async {
    try {
      await _local.deleteResult(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
