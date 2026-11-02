import 'package:dartz/dartz.dart';

import '../../../../core/error/index.dart';
import '../entities/focus_tag.dart';

abstract class FocusTagRepository {
  /// Tag theo thứ tự hiển thị.
  Future<Either<Failure, List<FocusTag>>> getTags();

  /// [tag] có `id` null = thêm mới, ngược lại = cập nhật.
  Future<Either<Failure, Unit>> saveTag(FocusTag tag);

  Future<Either<Failure, Unit>> deleteTag(int id);
}
