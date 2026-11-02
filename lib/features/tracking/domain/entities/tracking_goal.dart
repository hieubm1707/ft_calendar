import 'package:equatable/equatable.dart';

enum TrackingFrequency { daily, weekdays }

/// Nguồn của mục tiêu: tạo trong Tracking, hay là task hằng tuần bên Tasks
/// (hiện "ảo" ở Tracking, dùng chung trạng thái hoàn thành với Tasks).
enum TrackingSource { goal, task }

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Mục tiêu theo dõi (thuần Dart).
class TrackingGoal extends Equatable {
  /// Id theo [source]: id mục tiêu, hoặc id lịch task.
  final int? id;
  final TrackingSource source;
  final String name;
  final String? description;

  /// Màu do người dùng chọn (ARGB).
  final int color;
  final TrackingFrequency frequency;

  /// Thứ trong tuần 1..7 (Mon..Sun) — dùng khi frequency == weekdays.
  final Set<int> weekdays;

  /// Ngày bắt đầu / kết thúc (chuẩn hoá bỏ giờ); [endDate] null = không hạn.
  final DateTime startDate;
  final DateTime? endDate;

  /// Giờ nhắc trong ngày (phút từ 0h), tăng dần.
  final List<int> reminders;

  const TrackingGoal({
    this.id,
    this.source = TrackingSource.goal,
    required this.name,
    this.description,
    this.color = defaultColor,
    this.frequency = TrackingFrequency.daily,
    this.weekdays = const {},
    required this.startDate,
    this.endDate,
    this.reminders = const [],
  });

  /// Xanh hoàng gia — trùng màu nhấn của app.
  static const defaultColor = 0xFF3D6DF2;

  /// Số giờ nhắc tối đa cho 1 mục tiêu.
  static const maxReminders = 5;

  bool get isFromTask => source == TrackingSource.task;

  /// Các thứ thực sự áp dụng (hằng ngày = đủ 7 thứ).
  Set<int> get activeWeekdays => frequency == TrackingFrequency.daily
      ? const {1, 2, 3, 4, 5, 6, 7}
      : weekdays;

  /// Mục tiêu có phải làm vào [day] không (trong khoảng bắt đầu..kết thúc + đúng thứ).
  bool isDueOn(DateTime day) {
    final d = _dayOnly(day);
    if (d.isBefore(_dayOnly(startDate))) return false;
    final end = endDate;
    if (end != null && d.isAfter(_dayOnly(end))) return false;
    return activeWeekdays.contains(d.weekday);
  }

  TrackingGoal copyWith({int? id}) => TrackingGoal(
    id: id ?? this.id,
    source: source,
    name: name,
    description: description,
    color: color,
    frequency: frequency,
    weekdays: weekdays,
    startDate: startDate,
    endDate: endDate,
    reminders: reminders,
  );

  @override
  List<Object?> get props => [
    id,
    source,
    name,
    description,
    color,
    frequency,
    weekdays,
    startDate,
    endDate,
    reminders,
  ];
}
