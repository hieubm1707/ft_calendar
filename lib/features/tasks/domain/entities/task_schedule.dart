import 'package:equatable/equatable.dart';

enum TaskRecurrence { dates, weekly }

/// Lịch task (thuần Dart). `dates` = 1 hoặc nhiều ngày cụ thể;
/// `weekly` = lặp theo các thứ trong tuần từ [startDate] đến khi [active] = false.
class TaskSchedule extends Equatable {
  final int? id;
  final String title;
  final TaskRecurrence type;

  /// Các ngày cụ thể (chuẩn hoá bỏ giờ) — dùng khi type == dates.
  final List<DateTime> dates;

  /// Thứ trong tuần 1..7 (Mon..Sun) — dùng khi type == weekly.
  final Set<int> weekdays;

  /// Mốc bắt đầu áp dụng lặp (chuẩn hoá bỏ giờ) — dùng khi type == weekly.
  final DateTime startDate;

  final bool active;

  /// Màu cờ ưu tiên (do người dùng chọn).
  final int color;

  /// Mô tả (tuỳ chọn).
  final String? description;

  /// Giờ trong ngày dạng phút từ 0h (tuỳ chọn, null = không đặt giờ).
  final int? timeMinutes;

  const TaskSchedule({
    this.id,
    required this.title,
    required this.type,
    this.dates = const [],
    this.weekdays = const {},
    required this.startDate,
    this.active = true,
    this.color = 0xFF00B3A6,
    this.description,
    this.timeMinutes,
  });

  bool get isRecurring => type == TaskRecurrence.weekly;

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        dates,
        weekdays,
        startDate,
        active,
        color,
        description,
        timeMinutes,
      ];
}
