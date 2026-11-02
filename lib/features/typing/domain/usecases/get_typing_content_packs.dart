import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/typing_content_pack.dart';
import '../entities/typing_language.dart';
import '../repositories/typing_content_pack_repository.dart';

@lazySingleton
class GetTypingContentPacks
    implements UseCase<List<TypingContentPack>, TypingLanguage> {
  final TypingContentPackRepository _repository;

  GetTypingContentPacks(this._repository);

  @override
  Future<Either<Failure, List<TypingContentPack>>> call(TypingLanguage params) {
    return _repository.getPacks(params);
  }
}
