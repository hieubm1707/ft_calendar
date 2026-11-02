import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/typing_content.dart';
import '../entities/typing_language.dart';
import '../repositories/typing_content_repository.dart';

@lazySingleton
class GetTypingContent implements UseCase<TypingContentBank, TypingLanguage> {
  final TypingContentRepository _repository;

  GetTypingContent(this._repository);

  @override
  Future<Either<Failure, TypingContentBank>> call(TypingLanguage params) {
    return _repository.getBank(params);
  }
}
