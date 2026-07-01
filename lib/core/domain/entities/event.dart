import 'package:equatable/equatable.dart';

/// Entity nghiệp vụ thuần Dart — KHÔNG import Flutter/Drift.
/// Dùng chung bởi feature `events` (CRUD) và `calendar` (hiển thị).
class Event extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;

  const Event({
    this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.isAllDay = false,
  });

  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, startTime, endTime, isAllDay];
}
