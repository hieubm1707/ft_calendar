part of 'calendar_cubit.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  final CalendarStatus status;
  final DateTime? month;
  final List<Event> events;
  final String? errorMessage;

  const CalendarState({
    this.status = CalendarStatus.initial,
    this.month,
    this.events = const [],
    this.errorMessage,
  });

  CalendarState copyWith({
    CalendarStatus? status,
    DateTime? month,
    List<Event>? events,
    String? errorMessage,
  }) {
    return CalendarState(
      status: status ?? this.status,
      month: month ?? this.month,
      events: events ?? this.events,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, month, events, errorMessage];
}
