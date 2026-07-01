import 'package:equatable/equatable.dart';

/// Một lần xuất hiện của task vào một ngày (sinh ảo từ TaskSchedule).
class TaskInstance extends Equatable {
  final int scheduleId;
  final DateTime date; // ngày chuẩn hoá (bỏ giờ)
  final String title;
  final int color;
  final bool done;
  final bool isRecurring;
  final String? description;
  final int? timeMinutes;

  const TaskInstance({
    required this.scheduleId,
    required this.date,
    required this.title,
    required this.color,
    required this.done,
    required this.isRecurring,
    this.description,
    this.timeMinutes,
  });

  @override
  List<Object?> get props => [
        scheduleId,
        date,
        title,
        color,
        done,
        isRecurring,
        description,
        timeMinutes,
      ];
}
