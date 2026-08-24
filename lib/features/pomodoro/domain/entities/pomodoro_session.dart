import 'package:equatable/equatable.dart';

/// Một phiên tập trung đã thực hiện (thuần Dart).
class PomodoroSession extends Equatable {
  final int? id;
  final DateTime startedAt;
  final DateTime endedAt;

  /// Số giây đã tập trung thực tế.
  final int focusSeconds;

  /// Độ dài phiên đã đặt (giây).
  final int plannedSeconds;

  /// false = dừng giữa chừng.
  final bool completed;

  /// Việc đang tập trung (tên task hoặc nhãn tự nhập).
  final String? label;

  /// Task liên kết (nếu chọn từ tab Công việc).
  final int? taskScheduleId;

  const PomodoroSession({
    this.id,
    required this.startedAt,
    required this.endedAt,
    required this.focusSeconds,
    required this.plannedSeconds,
    this.completed = true,
    this.label,
    this.taskScheduleId,
  });

  int get focusMinutes => focusSeconds ~/ 60;

  @override
  List<Object?> get props => [
        id,
        startedAt,
        endedAt,
        focusSeconds,
        plannedSeconds,
        completed,
        label,
        taskScheduleId,
      ];
}
