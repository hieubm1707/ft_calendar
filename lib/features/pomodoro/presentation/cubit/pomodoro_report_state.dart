part of 'pomodoro_report_cubit.dart';

enum PomodoroReportStatus { initial, loading, success, failure }

/// Bộ lọc khoảng thời gian xem report.
/// [custom] = tự chọn từ ngày → đến ngày.
enum PomodoroRange { week, month, year, custom }

class PomodoroReportState extends Equatable {
  final PomodoroReportStatus status;
  final PomodoroRange range;

  /// Khoảng đang xem (đã chuẩn hoá về ngày, bao gồm cả 2 đầu).
  final DateTime from;
  final DateTime to;

  final PomodoroReport report;

  /// Các phiên trong khoảng, mới nhất trước.
  final List<PomodoroSession> sessions;

  /// Tag hiện có — để lấy màu/tên mới nhất cho focus trend.
  final List<FocusTag> tags;

  final String? errorMessage;

  PomodoroReportState({
    this.status = PomodoroReportStatus.initial,
    this.range = PomodoroRange.week,
    DateTime? from,
    DateTime? to,
    PomodoroReport? report,
    this.sessions = const [],
    this.tags = const [],
    this.errorMessage,
  })  : from = from ?? DateTime(2000),
        to = to ?? DateTime(2000),
        report = report ?? PomodoroReport.empty;

  /// Màu của tag (theo id) để vẽ focus trend; null = tag đã xoá / phiên không tag.
  int? colorOfTag(int? tagId) {
    if (tagId == null) return null;
    for (final t in tags) {
      if (t.id == tagId) return t.color;
    }
    return null;
  }

  /// Emoji của tag (theo id).
  String? emojiOfTag(int? tagId) {
    if (tagId == null) return null;
    for (final t in tags) {
      if (t.id == tagId) return t.emoji;
    }
    return null;
  }

  PomodoroReportState copyWith({
    PomodoroReportStatus? status,
    PomodoroRange? range,
    DateTime? from,
    DateTime? to,
    PomodoroReport? report,
    List<PomodoroSession>? sessions,
    List<FocusTag>? tags,
    String? errorMessage,
  }) {
    return PomodoroReportState(
      status: status ?? this.status,
      range: range ?? this.range,
      from: from ?? this.from,
      to: to ?? this.to,
      report: report ?? this.report,
      sessions: sessions ?? this.sessions,
      tags: tags ?? this.tags,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, range, from, to, report, sessions, tags, errorMessage];
}
