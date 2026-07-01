import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/index.dart';
import '../../../../core/error/index.dart';
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

  CalendarCubit(
    this._getScheduledEvents,
    this._createEvent,
    this._updateEvent,
    this._deleteEvent,
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

  /// Tạo sự kiện mới rồi nạp lại dải hiện tại.
  Future<void> addEvent(Event event) => _mutate(_createEvent(event));

  /// Cập nhật sự kiện rồi nạp lại dải hiện tại.
  Future<void> updateEvent(Event event) => _mutate(_updateEvent(event));

  /// Xoá sự kiện rồi nạp lại dải hiện tại.
  Future<void> deleteEvent(int id) => _mutate(_deleteEvent(id));

  /// Chạy một thao tác thay đổi dữ liệu, lỗi thì báo, thành công thì reload.
  Future<void> _mutate(Future<Either<Failure, Object?>> op) async {
    final result = await op;
    await result.fold(
      (failure) async => emit(state.copyWith(
        status: CalendarStatus.failure,
        errorMessage: failure.message,
      )),
      (_) async {
        if (_from != null && _to != null) {
          await loadRange(_from!, _to!);
        }
      },
    );
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
