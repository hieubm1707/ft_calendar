import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';
import '../datasources/typing_content_pack_datasource.dart';
import '../models/typing_content_pack_mapper.dart';

@LazySingleton(as: TypingContentPackRepository)
class TypingContentPackRepositoryImpl implements TypingContentPackRepository {
  final TypingContentPackDataSource _local;

  TypingContentPackRepositoryImpl(this._local);

  @override
  Future<Either<Failure, List<TypingContentPack>>> getPacks(
      TypingLanguage language) async {
    try {
      final rows = await _local.getPacks(language.code);
      return Right(rows.map((r) => r.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addPack(TypingContentPack pack) async {
    try {
      await _local.insertPack(pack.toInsertCompanion());
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePack(int id) async {
    try {
      await _local.deletePack(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
