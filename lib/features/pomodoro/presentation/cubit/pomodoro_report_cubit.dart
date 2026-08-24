import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/index.dart';

part 'pomodoro_report_state.dart';

/// Thống kê thời gian đã tập trung theo khoảng ngày.
@injectable
class PomodoroReportCubit extends Cubit<PomodoroReportState> {
  final GetPomodoroSessions _getSessions;
  final DeletePomodoroSession _deleteSession;

  PomodoroReportCubit(this._getSessions, this._deleteSession)
      : super(PomodoroReportState());

  Future<void> load([PomodoroRange? range]) async {
    final selected = range ?? state.range;
    emit(state.copyWith(
        status: PomodoroReportStatus.loading, range: selected));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final to = today.add(const Duration(days: 1)); // hết ngày hôm nay
    final from = switch (selected) {
      PomodoroRange.week => today.subtract(const Duration(days: 6)),
      PomodoroRange.month => today.subtract(const Duration(days: 29)),
      PomodoroRange.all => DateTime(2000),
    };

    final result =
        await _getSessions(GetPomodoroSessionsParams(from: from, to: to));
    result.fold(
      (failure) => emit(state.copyWith(
          status: PomodoroReportStatus.failure,
          errorMessage: failure.message)),
      (sessions) {
        // "Tất cả": khoảng vẽ biểu đồ bắt đầu từ phiên sớm nhất, không phải năm 2000.
        final start = selected == PomodoroRange.all
            ? _earliestDay(sessions) ?? today
            : from;
        emit(state.copyWith(
          status: PomodoroReportStatus.success,
          sessions: sessions,
          report:
              summarizePomodoro(sessions: sessions, from: start, to: today),
        ));
      },
    );
  }

  Future<void> changeRange(PomodoroRange range) => load(range);

  Future<void> remove(int id) async {
    final result = await _deleteSession(id);
    await result.fold(
      (failure) async => emit(state.copyWith(
          status: PomodoroReportStatus.failure,
          errorMessage: failure.message)),
      (_) async => load(),
    );
  }

  DateTime? _earliestDay(List<PomodoroSession> sessions) {
    if (sessions.isEmpty) return null;
    var earliest = sessions.first.startedAt;
    for (final s in sessions) {
      if (s.startedAt.isBefore(earliest)) earliest = s.startedAt;
    }
    return DateTime(earliest.year, earliest.month, earliest.day);
  }
}
