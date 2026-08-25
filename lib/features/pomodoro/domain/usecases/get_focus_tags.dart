import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/focus_tag.dart';
import '../repositories/focus_tag_repository.dart';

@lazySingleton
class GetFocusTags implements UseCase<List<FocusTag>, NoParams> {
  final FocusTagRepository _repository;

  GetFocusTags(this._repository);

  @override
  Future<Either<Failure, List<FocusTag>>> call(NoParams params) {
    return _repository.getTags();
  }
}
