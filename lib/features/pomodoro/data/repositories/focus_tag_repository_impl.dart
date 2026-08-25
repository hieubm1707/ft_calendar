import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';
import '../datasources/focus_tag_local_datasource.dart';
import '../models/focus_tag_mapper.dart';

@LazySingleton(as: FocusTagRepository)
class FocusTagRepositoryImpl implements FocusTagRepository {
  final FocusTagLocalDataSource _local;

  FocusTagRepositoryImpl(this._local);

  @override
  Future<Either<Failure, List<FocusTag>>> getTags() async {
    try {
      final rows = await _local.getTags();
      return Right(rows.map((r) => r.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveTag(FocusTag tag) async {
    try {
      final id = tag.id;
      if (id == null) {
        await _local.insertTag(tag.toInsertCompanion());
      } else {
        await _local.updateTag(id, tag.toUpdateCompanion());
      }
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTag(int id) async {
    try {
      await _local.deleteTag(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
