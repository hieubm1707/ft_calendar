import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../repositories/typing_content_pack_repository.dart';

@lazySingleton
class DeleteTypingContentPack implements UseCase<Unit, int> {
  final TypingContentPackRepository _repository;

  DeleteTypingContentPack(this._repository);

  @override
  Future<Either<Failure, Unit>> call(int params) {
    return _repository.deletePack(params);
  }
}
