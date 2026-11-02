import 'package:equatable/equatable.dart';

import 'tracking_goal.dart';

/// Một lượt hoàn thành mục tiêu vào một ngày.
class TrackingCheckin extends Equatable {
  final TrackingSource source;
  final int goalId;
  final DateTime date; // ngày chuẩn hoá (bỏ giờ)

  const TrackingCheckin({
    required this.source,
    required this.goalId,
    required this.date,
  });

  @override
  List<Object?> get props => [source, goalId, date];
}

/// Toàn bộ dữ liệu trang Tracking: mục tiêu (tự tạo + task hằng tuần) + lượt hoàn thành.
class TrackingOverview extends Equatable {
  final List<TrackingGoal> goals;
  final List<TrackingCheckin> checkins;

  const TrackingOverview({required this.goals, required this.checkins});

  @override
  List<Object?> get props => [goals, checkins];
}
