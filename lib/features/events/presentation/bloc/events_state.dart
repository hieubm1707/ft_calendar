part of 'events_bloc.dart';

enum EventsStatus { initial, loading, success, failure }

class EventsState extends Equatable {
  final EventsStatus status;
  final List<Event> events;
  final String? errorMessage;

  const EventsState({
    this.status = EventsStatus.initial,
    this.events = const [],
    this.errorMessage,
  });

  EventsState copyWith({
    EventsStatus? status,
    List<Event>? events,
    String? errorMessage,
  }) {
    return EventsState(
      status: status ?? this.status,
      events: events ?? this.events,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, events, errorMessage];
}
