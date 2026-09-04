import 'package:dartz/dartz.dart';

import '../../../../core/error/index.dart';
import '../entities/typing_content.dart';
import '../entities/typing_language.dart';

abstract class TypingContentRepository {
  /// Kho từ + đoạn văn của [language] (gộp mọi file nội dung đã import).
  Future<Either<Failure, TypingContentBank>> getBank(TypingLanguage language);
}
