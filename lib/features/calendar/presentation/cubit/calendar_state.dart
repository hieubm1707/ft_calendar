part of 'calendar_cubit.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  final CalendarStatus status;

  /// Sự kiện gom theo ngày (key = DateTime(year, month, day)).
  final Map<DateTime, List<Event>> eventsByDay;

  /// Màu đang bật để hiển thị (rỗng = hiện tất cả).
  final Set<int> activeColors;
  final String? errorMessage;

  const CalendarState({
    this.status = CalendarStatus.initial,
    this.eventsByDay = const {},
    this.activeColors = const {},
    this.errorMessage,
  });

  /// Sự kiện của một ngày, đã áp bộ lọc màu.
  List<Event> eventsOf(DateTime day) {
    final all = eventsByDay[DateTime(day.year, day.month, day.day)] ?? const [];
    if (activeColors.isEmpty) return all;
    return all.where((e) => activeColors.contains(e.color)).toList();
  }

  CalendarState copyWith({
    CalendarStatus? status,
    Map<DateTime, List<Event>>? eventsByDay,
    Set<int>? activeColors,
    String? errorMessage,
  }) {
    return CalendarState(
      status: status ?? this.status,
      eventsByDay: eventsByDay ?? this.eventsByDay,
      activeColors: activeColors ?? this.activeColors,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, eventsByDay, activeColors, errorMessage];
}
