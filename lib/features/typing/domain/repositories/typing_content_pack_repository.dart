import 'package:dartz/dartz.dart';

import '../../../../core/error/index.dart';
import '../entities/typing_content_pack.dart';
import '../entities/typing_language.dart';

abstract class TypingContentPackRepository {
  /// Gói người dùng đã import cho [language], mới thêm đứng trước.
  Future<Either<Failure, List<TypingContentPack>>> getPacks(
      TypingLanguage language);

  Future<Either<Failure, Unit>> addPack(TypingContentPack pack);

  Future<Either<Failure, Unit>> deletePack(int id);
}
