import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';
import '../datasources/typing_content_datasource.dart';
import '../datasources/typing_content_pack_datasource.dart';
import '../models/typing_content_pack_mapper.dart';

/// Kho nội dung = nội dung có sẵn trong assets **cộng** các gói người dùng đã
/// import. Gói đọc lại mỗi lần gọi (không cache) để vừa import xong là dùng
/// được ngay.
@LazySingleton(as: TypingContentRepository)
class TypingContentRepositoryImpl implements TypingContentRepository {
  final TypingContentDataSource _assets;
  final TypingContentPackDataSource _packs;

  TypingContentRepositoryImpl(this._assets, this._packs);

  @override
  Future<Either<Failure, TypingContentBank>> getBank(
      TypingLanguage language) async {
    try {
      var bank = await _assets.loadBank(language);
      for (final row in await _packs.getPacks(language.code)) {
        final pack = row.toEntity();
        bank = bank.merge(TypingContentBank(
          language: language,
          words: pack.words,
          paragraphs: pack.paragraphs,
        ));
      }
      return Right(bank);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
