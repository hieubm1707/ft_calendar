import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/typing_result.dart';
import '../repositories/typing_repository.dart';

@lazySingleton
class SaveTypingResult implements UseCase<Unit, TypingResult> {
  final TypingRepository _repository;

  SaveTypingResult(this._repository);

  @override
  Future<Either<Failure, Unit>> call(TypingResult params) {
    return _repository.saveResult(params);
  }
}
