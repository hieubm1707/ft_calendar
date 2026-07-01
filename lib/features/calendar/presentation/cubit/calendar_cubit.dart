import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/index.dart';
import '../../../../core/notifications/index.dart';
// ⭐ Tái sử dụng usecase THUỘC feature `events` — chỉ import barrel domain của nó.
import '../../../events/domain/index.dart';

part 'calendar_state.dart';

/// Feature `calendar` không có repository/data riêng — dùng lại usecase của `events`.
/// Đây là ví dụ tái sử dụng hợp lệ: chỉ phụ thuộc `events/domain`.
@injectable
class CalendarCubit extends Cubit<CalendarState> {
  final GetScheduledEvents _getScheduledEvents;
  final CreateEvent _createEvent;
  final UpdateEvent _updateEvent;
  final DeleteEvent _deleteEvent;
  final NotificationService _notifications;

  CalendarCubit(
    this._getScheduledEvents,
    this._createEvent,
    this._updateEvent,
    this._deleteEvent,
    this._notifications,
  ) : super(const CalendarState());

  DateTime? _from;
  DateTime? _to;

  /// Nạp toàn bộ sự kiện trong dải [from, to] (nhiều tháng) và gom theo ngày.
  Future<void> loadRange(DateTime from, DateTime to) async {
    _from = from;
    _to = to;
    emit(state.copyWith(status: CalendarStatus.loading));

    final result =
        await _getScheduledEvents(GetScheduledEventsParams(from: from, to: to));

    result.fold(
      (failure) => emit(state.copyWith(
        status: CalendarStatus.failure,
        errorMessage: failure.message,
      )),
      (events) => emit(state.copyWith(
        status: CalendarStatus.success,
        eventsByDay: _groupByDay(events),
      )),
    );
  }

  /// Tạo sự kiện mới, đặt nhắc, rồi nạp lại dải hiện tại.
  Future<void> addEvent(Event event) async {
    final result = await _createEvent(event);
    await result.fold(
      (f) async => _emitFailure(f.message),
      (created) async {
        await _notifications.scheduleEventReminder(
          id: created.id!,
          title: created.title,
          when: created.startTime,
        );
        await _reload();
      },
    );
  }

  /// Cập nhật sự kiện, đặt lại nhắc, rồi nạp lại dải hiện tại.
  Future<void> updateEvent(Event event) async {
    final result = await _updateEvent(event);
    await result.fold(
      (f) async => _emitFailure(f.message),
      (updated) async {
        if (updated.id != null) {
          await _notifications.cancel(updated.id!);
          await _notifications.scheduleEventReminder(
            id: updated.id!,
            title: updated.title,
            when: updated.startTime,
          );
        }
        await _reload();
      },
    );
  }

  /// Xoá sự kiện, huỷ nhắc, rồi nạp lại dải hiện tại.
  Future<void> deleteEvent(int id) async {
    final result = await _deleteEvent(id);
    await result.fold(
      (f) async => _emitFailure(f.message),
      (_) async {
        await _notifications.cancel(id);
        await _reload();
      },
    );
  }

  /// Đặt bộ lọc màu (rỗng = hiện tất cả). Chỉ đổi UI, không cần nạp lại DB.
  void setColorFilter(Set<int> colors) {
    emit(state.copyWith(activeColors: colors));
  }

  void _emitFailure(String message) => emit(state.copyWith(
        status: CalendarStatus.failure,
        errorMessage: message,
      ));

  Future<void> _reload() async {
    if (_from != null && _to != null) await loadRange(_from!, _to!);
  }

  Map<DateTime, List<Event>> _groupByDay(List<Event> events) {
    final map = <DateTime, List<Event>>{};
    for (final e in events) {
      final key = DateTime(e.startTime.year, e.startTime.month, e.startTime.day);
      (map[key] ??= []).add(e);
    }
    return map;
  }
}
