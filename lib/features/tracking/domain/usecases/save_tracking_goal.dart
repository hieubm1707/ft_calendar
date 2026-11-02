import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/tracking_goal.dart';
import '../repositories/tracking_repository.dart';

/// Tạo mới hoặc cập nhật mục tiêu tự tạo; trả về id đã lưu.
@lazySingleton
class SaveTrackingGoal implements UseCase<int, TrackingGoal> {
  final TrackingRepository _repository;

  SaveTrackingGoal(this._repository);

  @override
  Future<Either<Failure, int>> call(TrackingGoal params) {
    return _repository.saveGoal(params);
  }
}
