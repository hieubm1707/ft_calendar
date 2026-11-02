import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/focus_tag.dart';
import '../repositories/focus_tag_repository.dart';

/// Thêm mới (id null) hoặc sửa tag tập trung.
@lazySingleton
class SaveFocusTag implements UseCase<Unit, FocusTag> {
  final FocusTagRepository _repository;

  SaveFocusTag(this._repository);

  @override
  Future<Either<Failure, Unit>> call(FocusTag params) {
    return _repository.saveTag(params);
  }
}
