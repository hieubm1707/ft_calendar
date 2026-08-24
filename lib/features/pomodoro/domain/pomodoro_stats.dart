import 'package:equatable/equatable.dart';

import 'entities/pomodoro_session.dart';

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Tổng hợp của MỘT ngày.
class PomodoroDaySummary extends Equatable {
  final DateTime date;
  final int sessions;
  final int focusSeconds;

  const PomodoroDaySummary({
    required this.date,
    required this.sessions,
    required this.focusSeconds,
  });

  @override
  List<Object?> get props => [date, sessions, focusSeconds];
}

/// Tổng hợp theo việc đã tập trung. [label] rỗng = phiên không đặt tên.
class PomodoroLabelSummary extends Equatable {
  final String label;
  final int sessions;
  final int focusSeconds;

  const PomodoroLabelSummary({
    required this.label,
    required this.sessions,
    required this.focusSeconds,
  });

  @override
  List<Object?> get props => [label, sessions, focusSeconds];
}

/// Kết quả report cho một khoảng ngày.
class PomodoroReport extends Equatable {
  final DateTime from;
  final DateTime to;
  final int totalSessions;
  final int completedSessions;
  final int totalFocusSeconds;

  /// Mọi ngày trong khoảng, kể cả ngày không có phiên (để vẽ biểu đồ).
  final List<PomodoroDaySummary> days;

  /// Gom theo việc, giảm dần theo thời gian tập trung.
  final List<PomodoroLabelSummary> labels;

  const PomodoroReport({
    required this.from,
    required this.to,
    required this.totalSessions,
    required this.completedSessions,
    required this.totalFocusSeconds,
    required this.days,
    required this.labels,
  });

  static final empty = PomodoroReport(
    from: _dayOnly(DateTime(2000)),
    to: _dayOnly(DateTime(2000)),
    totalSessions: 0,
    completedSessions: 0,
    totalFocusSeconds: 0,
    days: const [],
    labels: const [],
  );

  /// Số ngày thực sự có tập trung.
  int get activeDays => days.where((d) => d.sessions > 0).length;

  /// Trung bình giây/ngày (chỉ tính ngày có tập trung).
  int get averageSecondsPerActiveDay =>
      activeDays == 0 ? 0 : totalFocusSeconds ~/ activeDays;

  int get bestDayFocusSeconds =>
      days.fold(0, (m, d) => d.focusSeconds > m ? d.focusSeconds : m);

  /// Số ngày liên tiếp có tập trung, tính lùi từ cuối khoảng.
  /// Ngày cuối chưa tập trung thì không phá streak (mới sang ngày mới).
  int get streakDays {
    var streak = 0;
    for (var i = days.length - 1; i >= 0; i--) {
      if (days[i].sessions > 0) {
        streak++;
      } else if (i != days.length - 1) {
        break;
      }
    }
    return streak;
  }

  @override
  List<Object?> get props => [
        from,
        to,
        totalSessions,
        completedSessions,
        totalFocusSeconds,
        days,
        labels,
      ];
}

/// Gom [sessions] thành report cho khoảng ngày [from]..[to] (bao gồm cả 2 đầu).
/// Logic thuần (không phụ thuộc Drift/Flutter) → dễ unit test.
PomodoroReport summarizePomodoro({
  required List<PomodoroSession> sessions,
  required DateTime from,
  required DateTime to,
}) {
  final start = _dayOnly(from);
  final end = _dayOnly(to);

  final byDay = <DateTime, List<PomodoroSession>>{};
  final byLabel = <String, List<PomodoroSession>>{};
  var totalSeconds = 0;
  var completed = 0;
  var total = 0;

  for (final s in sessions) {
    final day = _dayOnly(s.startedAt);
    if (day.isBefore(start) || day.isAfter(end)) continue;
    (byDay[day] ??= []).add(s);
    (byLabel[s.label?.trim() ?? ''] ??= []).add(s);
    totalSeconds += s.focusSeconds;
    total++;
    if (s.completed) completed++;
  }

  final days = <PomodoroDaySummary>[];
  for (var d = start;
      !d.isAfter(end);
      d = DateTime(d.year, d.month, d.day + 1)) {
    final items = byDay[d] ?? const <PomodoroSession>[];
    days.add(PomodoroDaySummary(
      date: d,
      sessions: items.length,
      focusSeconds: items.fold(0, (sum, s) => sum + s.focusSeconds),
    ));
  }

  final labels = byLabel.entries
      .map((e) => PomodoroLabelSummary(
            label: e.key,
            sessions: e.value.length,
            focusSeconds: e.value.fold(0, (sum, s) => sum + s.focusSeconds),
          ))
      .toList()
    ..sort((a, b) {
      final byTime = b.focusSeconds.compareTo(a.focusSeconds);
      return byTime != 0 ? byTime : a.label.compareTo(b.label);
    });

  return PomodoroReport(
    from: start,
    to: end,
    totalSessions: total,
    completedSessions: completed,
    totalFocusSeconds: totalSeconds,
    days: days,
    labels: labels,
  );
}
