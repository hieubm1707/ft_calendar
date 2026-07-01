import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/index.dart';
import '../../domain/index.dart';

part 'events_event.dart';
part 'events_state.dart';

/// Bloc chỉ điều phối UseCase — không biết Repository hay Drift.
@injectable
class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetScheduledEvents _getScheduledEvents;
  final CreateEvent _createEvent;
  final DeleteEvent _deleteEvent;

  EventsBloc(
    this._getScheduledEvents,
    this._createEvent,
    this._deleteEvent,
  ) : super(const EventsState()) {
    on<EventsLoaded>(_onLoaded);
    on<EventCreated>(_onCreated);
    on<EventDeleted>(_onDeleted);
  }

  Future<void> _onLoaded(EventsLoaded event, Emitter<EventsState> emit) async {
    emit(state.copyWith(status: EventsStatus.loading));
    final result = await _getScheduledEvents(
      GetScheduledEventsParams(from: event.from, to: event.to),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: EventsStatus.failure,
        errorMessage: failure.message,
      )),
      (events) => emit(state.copyWith(
        status: EventsStatus.success,
        events: events,
      )),
    );
  }

  Future<void> _onCreated(EventCreated event, Emitter<EventsState> emit) async {
    final result = await _createEvent(event.event);
    result.fold(
      (failure) => emit(state.copyWith(
        status: EventsStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => add(const EventsLoaded()),
    );
  }

  Future<void> _onDeleted(EventDeleted event, Emitter<EventsState> emit) async {
    final result = await _deleteEvent(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: EventsStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => add(const EventsLoaded()),
    );
  }
}
