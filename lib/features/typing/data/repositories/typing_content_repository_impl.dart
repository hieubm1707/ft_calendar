import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';
import '../datasources/typing_content_datasource.dart';

@LazySingleton(as: TypingContentRepository)
class TypingContentRepositoryImpl implements TypingContentRepository {
  final TypingContentDataSource _source;

  TypingContentRepositoryImpl(this._source);

  @override
  Future<Either<Failure, TypingContentBank>> getBank(
      TypingLanguage language) async {
    try {
      return Right(await _source.loadBank(language));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
