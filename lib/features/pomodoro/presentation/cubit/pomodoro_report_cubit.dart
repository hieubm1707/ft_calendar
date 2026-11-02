import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/index.dart';
import '../../domain/index.dart';

part 'pomodoro_report_state.dart';

/// Thống kê thời gian đã tập trung: nền tảng là tổng hợp THEO NGÀY, các bộ lọc
/// tuần/tháng/năm/tuỳ chọn chỉ đổi khoảng ngày được gom.
@injectable
class PomodoroReportCubit extends Cubit<PomodoroReportState> {
  final GetPomodoroSessions _getSessions;
  final DeletePomodoroSession _deleteSession;
  final GetFocusTags _getFocusTags;

  PomodoroReportCubit(
    this._getSessions,
    this._deleteSession,
    this._getFocusTags,
  ) : super(PomodoroReportState());

  /// Nạp report. [range] null = giữ khoảng hiện tại.
  /// Với [PomodoroRange.custom] phải truyền [from]/[to].
  Future<void> load({
    PomodoroRange? range,
    DateTime? from,
    DateTime? to,
  }) async {
    final selected = range ?? state.range;
    final bounds = _boundsFor(selected, from: from, to: to);

    emit(state.copyWith(
      status: PomodoroReportStatus.loading,
      range: selected,
      from: bounds.from,
      to: bounds.to,
    ));

    final tags = await _loadTags();
    final result = await _getSessions(GetPomodoroSessionsParams(
      from: bounds.from,
      to: bounds.to.add(const Duration(days: 1)), // [from, to] theo ngày
    ));

    result.fold(
      (failure) => emit(state.copyWith(
          status: PomodoroReportStatus.failure,
          errorMessage: failure.message)),
      (sessions) => emit(state.copyWith(
        status: PomodoroReportStatus.success,
        sessions: sessions,
        tags: tags,
        report: summarizePomodoro(
          sessions: sessions,
          from: bounds.from,
          to: bounds.to,
          tagTitles: {
            for (final t in tags)
              if (t.id != null) t.id!: t.title,
          },
        ),
      )),
    );
  }

  Future<void> changeRange(PomodoroRange range) => load(range: range);

  /// Chọn khoảng bất kỳ: từ ngày → đến ngày.
  Future<void> setCustomRange(DateTime from, DateTime to) =>
      load(range: PomodoroRange.custom, from: from, to: to);

  Future<void> remove(int id) async {
    final result = await _deleteSession(id);
    await result.fold(
      (failure) async => emit(state.copyWith(
          status: PomodoroReportStatus.failure,
          errorMessage: failure.message)),
      (_) async => load(),
    );
  }

  Future<List<FocusTag>> _loadTags() async {
    final result = await _getFocusTags(const NoParams());
    return result.fold((_) => state.tags, (tags) => tags);
  }

  /// Khoảng ngày của từng bộ lọc — luôn kết thúc ở hôm nay (trừ khoảng tuỳ chọn).
  ({DateTime from, DateTime to}) _boundsFor(
    PomodoroRange range, {
    DateTime? from,
    DateTime? to,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (range) {
      case PomodoroRange.week:
        // Tuần này: từ thứ Hai.
        return (from: today.subtract(Duration(days: today.weekday - 1)), to: today);
      case PomodoroRange.month:
        return (from: DateTime(today.year, today.month), to: today);
      case PomodoroRange.year:
        return (from: DateTime(today.year), to: today);
      case PomodoroRange.custom:
        final start = _dayOnly(from ?? state.from);
        final end = _dayOnly(to ?? state.to);
        return end.isBefore(start)
            ? (from: end, to: start)
            : (from: start, to: end);
    }
  }

  DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
