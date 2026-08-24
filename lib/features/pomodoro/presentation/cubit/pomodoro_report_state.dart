part of 'pomodoro_report_cubit.dart';

enum PomodoroReportStatus { initial, loading, success, failure }

/// Khoảng thời gian xem report.
enum PomodoroRange { week, month, all }

class PomodoroReportState extends Equatable {
  final PomodoroReportStatus status;
  final PomodoroRange range;
  final PomodoroReport report;

  /// Các phiên trong khoảng, mới nhất trước.
  final List<PomodoroSession> sessions;
  final String? errorMessage;

  PomodoroReportState({
    this.status = PomodoroReportStatus.initial,
    this.range = PomodoroRange.week,
    PomodoroReport? report,
    this.sessions = const [],
    this.errorMessage,
  }) : report = report ?? PomodoroReport.empty;

  PomodoroReportState copyWith({
    PomodoroReportStatus? status,
    PomodoroRange? range,
    PomodoroReport? report,
    List<PomodoroSession>? sessions,
    String? errorMessage,
  }) {
    return PomodoroReportState(
      status: status ?? this.status,
      range: range ?? this.range,
      report: report ?? this.report,
      sessions: sessions ?? this.sessions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, range, report, sessions, errorMessage];
}
