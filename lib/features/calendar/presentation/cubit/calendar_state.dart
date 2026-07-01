part of 'calendar_cubit.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  final CalendarStatus status;

  /// Sự kiện gom theo ngày (key = DateTime(year, month, day)).
  final Map<DateTime, List<Event>> eventsByDay;
  final String? errorMessage;

  const CalendarState({
    this.status = CalendarStatus.initial,
    this.eventsByDay = const {},
    this.errorMessage,
  });

  List<Event> eventsOf(DateTime day) =>
      eventsByDay[DateTime(day.year, day.month, day.day)] ?? const [];

  CalendarState copyWith({
    CalendarStatus? status,
    Map<DateTime, List<Event>>? eventsByDay,
    String? errorMessage,
  }) {
    return CalendarState(
      status: status ?? this.status,
      eventsByDay: eventsByDay ?? this.eventsByDay,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, eventsByDay, errorMessage];
}
