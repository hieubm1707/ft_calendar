import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../repositories/typing_repository.dart';

@lazySingleton
class DeleteTypingResult implements UseCase<Unit, int> {
  final TypingRepository _repository;

  DeleteTypingResult(this._repository);

  @override
  Future<Either<Failure, Unit>> call(int params) {
    return _repository.deleteResult(params);
  }
}
