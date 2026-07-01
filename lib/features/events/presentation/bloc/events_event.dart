part of 'events_bloc.dart';

sealed class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

/// Nạp danh sách sự kiện (tùy chọn lọc theo khoảng thời gian).
class EventsLoaded extends EventsEvent {
  final DateTime? from;
  final DateTime? to;

  const EventsLoaded({this.from, this.to});

  @override
  List<Object?> get props => [from, to];
}

class EventCreated extends EventsEvent {
  final Event event;

  const EventCreated(this.event);

  @override
  List<Object?> get props => [event];
}

class EventDeleted extends EventsEvent {
  final int id;

  const EventDeleted(this.id);

  @override
  List<Object?> get props => [id];
}
