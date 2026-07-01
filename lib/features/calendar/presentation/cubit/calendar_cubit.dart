import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/index.dart';
// ⭐ Tái sử dụng usecase THUỘC feature `events` — chỉ import barrel domain của nó.
import '../../../events/domain/index.dart';

part 'calendar_state.dart';

/// Feature `calendar` không có repository/data riêng cho sự kiện —
/// nó dùng lại usecase của `events`. Đây là ví dụ tái sử dụng hợp lệ:
/// chỉ phụ thuộc `events/domain`, không đụng `events/data`.
@injectable
class CalendarCubit extends Cubit<CalendarState> {
  final GetScheduledEvents _getScheduledEvents;

  CalendarCubit(this._getScheduledEvents) : super(const CalendarState());

  Future<void> loadMonth(DateTime month) async {
    emit(state.copyWith(status: CalendarStatus.loading));
    final from = DateTime(month.year, month.month, 1);
    final to = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final result =
        await _getScheduledEvents(GetScheduledEventsParams(from: from, to: to));

    result.fold(
      (failure) => emit(state.copyWith(
        status: CalendarStatus.failure,
        errorMessage: failure.message,
      )),
      (events) => emit(state.copyWith(
        status: CalendarStatus.success,
        month: month,
        events: events,
      )),
    );
  }
}
