import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/typing_content_pack.dart';
import '../repositories/typing_content_pack_repository.dart';

@lazySingleton
class AddTypingContentPack implements UseCase<Unit, TypingContentPack> {
  final TypingContentPackRepository _repository;

  AddTypingContentPack(this._repository);

  @override
  Future<Either<Failure, Unit>> call(TypingContentPack params) {
    return _repository.addPack(params);
  }
}
