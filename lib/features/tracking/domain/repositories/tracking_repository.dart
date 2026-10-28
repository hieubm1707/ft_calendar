import 'package:dartz/dartz.dart';

import '../../../../core/error/index.dart';
import '../entities/tracking_checkin.dart';
import '../entities/tracking_goal.dart';

abstract class TrackingRepository {
  /// Mục tiêu tự tạo + task hằng tuần đang hoạt động bên Tasks, kèm mọi lượt
  /// hoàn thành của chúng.
  Future<Either<Failure, TrackingOverview>> getOverview();

  /// Tạo mới (id null) hoặc cập nhật mục tiêu tự tạo; trả về id đã lưu.
  Future<Either<Failure, int>> saveGoal(TrackingGoal goal);

  /// Xoá hẳn mục tiêu tự tạo (kèm lượt hoàn thành).
  Future<Either<Failure, Unit>> deleteGoal(int goalId);

  /// Đánh dấu/bỏ hoàn thành [goal] vào [date]. Mục tiêu từ Tasks ghi thẳng vào
  /// trạng thái hoàn thành của task → 2 bên luôn khớp.
  Future<Either<Failure, Unit>> setCheckin({
    required TrackingGoal goal,
    required DateTime date,
    required bool done,
  });
}
