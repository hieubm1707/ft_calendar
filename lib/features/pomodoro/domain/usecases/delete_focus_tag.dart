import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../repositories/focus_tag_repository.dart';

@lazySingleton
class DeleteFocusTag implements UseCase<Unit, int> {
  final FocusTagRepository _repository;

  DeleteFocusTag(this._repository);

  @override
  Future<Either<Failure, Unit>> call(int params) {
    return _repository.deleteTag(params);
  }
}
