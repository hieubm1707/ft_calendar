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

/// Tổng hợp theo tag/việc đã tập trung — dữ liệu cho "focus trend".
/// [tagId] null = phiên không gắn tag (nhãn tự do hoặc task); [label] rỗng =
/// phiên không đặt tên.
class PomodoroTagSummary extends Equatable {
  final int? tagId;
  final String label;
  final int sessions;
  final int focusSeconds;

  const PomodoroTagSummary({
    this.tagId,
    required this.label,
    required this.sessions,
    required this.focusSeconds,
  });

  @override
  List<Object?> get props => [tagId, label, sessions, focusSeconds];
}

/// Độ gom của biểu đồ: khoảng ngắn xem từng ngày, khoảng dài (năm) xem từng tháng.
enum PomodoroBucketUnit { day, month }

/// Một cột của biểu đồ (1 ngày hoặc 1 tháng).
class PomodoroBucket extends Equatable {
  final DateTime start;
  final PomodoroBucketUnit unit;
  final int sessions;
  final int focusSeconds;

  const PomodoroBucket({
    required this.start,
    required this.unit,
    required this.sessions,
    required this.focusSeconds,
  });

  @override
  List<Object?> get props => [start, unit, sessions, focusSeconds];
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

  /// Gom theo tag/việc, giảm dần theo thời gian tập trung (focus trend).
  final List<PomodoroTagSummary> tags;

  const PomodoroReport({
    required this.from,
    required this.to,
    required this.totalSessions,
    required this.completedSessions,
    required this.totalFocusSeconds,
    required this.days,
    required this.tags,
  });

  static final empty = PomodoroReport(
    from: _dayOnly(DateTime(2000)),
    to: _dayOnly(DateTime(2000)),
    totalSessions: 0,
    completedSessions: 0,
    totalFocusSeconds: 0,
    days: const [],
    tags: const [],
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

  /// Tag được tập trung nhiều nhất trong khoảng (null nếu chưa có phiên nào).
  PomodoroTagSummary? get topTag => tags.isEmpty ? null : tags.first;

  /// Tỉ lệ 0..1 thời gian dành cho [tag] trên tổng.
  double shareOf(PomodoroTagSummary tag) =>
      totalFocusSeconds == 0 ? 0 : tag.focusSeconds / totalFocusSeconds;

  /// Số ngày trong khoảng.
  int get dayCount => days.length;

  @override
  List<Object?> get props => [
        from,
        to,
        totalSessions,
        completedSessions,
        totalFocusSeconds,
        days,
        tags,
      ];
}

/// Gom [sessions] thành report cho khoảng ngày [from]..[to] (bao gồm cả 2 đầu).
/// [tagTitles] map `tagId -> tên tag hiện tại`: đổi tên tag thì report cũ cũng
/// hiển thị theo tên mới (nhãn lưu trong phiên chỉ là bản chụp lúc chạy).
/// Logic thuần (không phụ thuộc Drift/Flutter) → dễ unit test.
PomodoroReport summarizePomodoro({
  required List<PomodoroSession> sessions,
  required DateTime from,
  required DateTime to,
  Map<int, String> tagTitles = const {},
}) {
  final start = _dayOnly(from);
  final end = _dayOnly(to);

  final byDay = <DateTime, List<PomodoroSession>>{};
  // key: 'tag:<id>' nếu có tag, ngược lại 'label:<nhãn>' — hai tag trùng tên
  // vẫn tách riêng.
  final byTag = <String, List<PomodoroSession>>{};
  final tagNames = <String, ({int? tagId, String label})>{};
  var totalSeconds = 0;
  var completed = 0;
  var total = 0;

  for (final s in sessions) {
    final day = _dayOnly(s.startedAt);
    if (day.isBefore(start) || day.isAfter(end)) continue;
    (byDay[day] ??= []).add(s);

    final tagId = s.focusTagId;
    final label = (tagId == null ? null : tagTitles[tagId]) ??
        (s.label?.trim() ?? '');
    final key = tagId == null ? 'label:$label' : 'tag:$tagId';
    (byTag[key] ??= []).add(s);
    tagNames[key] = (tagId: tagId, label: label);
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

  final tags = byTag.entries
      .map((e) => PomodoroTagSummary(
            tagId: tagNames[e.key]!.tagId,
            label: tagNames[e.key]!.label,
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
    tags: tags,
  );
}

/// Khoảng dài (> 62 ngày, tức từ ~2 tháng trở lên) thì vẽ theo tháng cho dễ đọc.
PomodoroBucketUnit autoBucketUnit(int dayCount) =>
    dayCount > 62 ? PomodoroBucketUnit.month : PomodoroBucketUnit.day;

/// Gom tổng hợp ngày thành cột biểu đồ theo [unit]. Giữ nguyên thứ tự thời gian
/// và không bỏ tháng trống (để biểu đồ liền mạch).
List<PomodoroBucket> bucketDaySummaries(
  List<PomodoroDaySummary> days,
  PomodoroBucketUnit unit,
) {
  if (unit == PomodoroBucketUnit.day) {
    return days
        .map((d) => PomodoroBucket(
              start: d.date,
              unit: unit,
              sessions: d.sessions,
              focusSeconds: d.focusSeconds,
            ))
        .toList();
  }

  final buckets = <DateTime, PomodoroBucket>{};
  for (final d in days) {
    final key = DateTime(d.date.year, d.date.month);
    final current = buckets[key];
    buckets[key] = PomodoroBucket(
      start: key,
      unit: unit,
      sessions: (current?.sessions ?? 0) + d.sessions,
      focusSeconds: (current?.focusSeconds ?? 0) + d.focusSeconds,
    );
  }
  final keys = buckets.keys.toList()..sort();
  return [for (final k in keys) buckets[k]!];
}
