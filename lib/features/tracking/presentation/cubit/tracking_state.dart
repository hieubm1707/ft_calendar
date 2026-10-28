part of 'tracking_cubit.dart';

enum TrackingStatus { initial, loading, success, failure }

class TrackingState extends Equatable {
  final TrackingStatus status;

  /// Mục tiêu tự tạo + task hằng tuần (nguồn Tasks).
  final List<TrackingGoal> goals;
  final List<TrackingCheckin> checkins;

  /// Khoá `trackingKey` của mọi lượt hoàn thành — tra nhanh done theo ngày.
  final Set<String> doneKeys;

  /// Ngày đang xem trên dải 7 ngày (chuẩn hoá bỏ giờ).
  final DateTime selectedDay;
  final String? errorMessage;

  const TrackingState({
    this.status = TrackingStatus.initial,
    this.goals = const [],
    this.checkins = const [],
    this.doneKeys = const {},
    required this.selectedDay,
    this.errorMessage,
  });

  /// Mục tiêu phải làm vào ngày đang xem.
  List<TrackingGoal> get dueGoals => goalsDueOn(goals, selectedDay);

  int get doneCount =>
      dueGoals.where((g) => isGoalDoneOn(g, selectedDay, doneKeys)).length;

  bool isDone(TrackingGoal goal, DateTime day) =>
      isGoalDoneOn(goal, day, doneKeys);

  /// Bản mới nhất của [goal] trong state (sau khi sửa/đồng bộ), null nếu đã bị xoá.
  TrackingGoal? find(TrackingGoal goal) {
    for (final g in goals) {
      if (g.source == goal.source && g.id == goal.id) return g;
    }
    return null;
  }

  TrackingState copyWith({
    TrackingStatus? status,
    List<TrackingGoal>? goals,
    List<TrackingCheckin>? checkins,
    Set<String>? doneKeys,
    DateTime? selectedDay,
    String? errorMessage,
  }) {
    return TrackingState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
      checkins: checkins ?? this.checkins,
      doneKeys: doneKeys ?? this.doneKeys,
      selectedDay: selectedDay ?? this.selectedDay,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    goals,
    checkins,
    doneKeys,
    selectedDay,
    errorMessage,
  ];
}
