import 'package:equatable/equatable.dart';

import 'entities/typing_language.dart';
import 'entities/typing_result.dart';

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Tổng hợp của MỘT ngày.
class TypingDaySummary extends Equatable {
  final DateTime date;
  final int tests;
  final double bestWpm;
  final double averageWpm;
  final double averageAccuracy;
  final int totalSeconds;

  const TypingDaySummary({
    required this.date,
    this.tests = 0,
    this.bestWpm = 0,
    this.averageWpm = 0,
    this.averageAccuracy = 0,
    this.totalSeconds = 0,
  });

  @override
  List<Object?> get props =>
      [date, tests, bestWpm, averageWpm, averageAccuracy, totalSeconds];
}

/// Tổng hợp theo ngôn ngữ — xem mình gõ tiếng Anh hay tiếng Việt nhanh hơn.
class TypingLanguageSummary extends Equatable {
  final TypingLanguage language;
  final int tests;
  final double bestWpm;
  final double averageWpm;
  final double averageAccuracy;

  const TypingLanguageSummary({
    required this.language,
    required this.tests,
    required this.bestWpm,
    required this.averageWpm,
    required this.averageAccuracy,
  });

  @override
  List<Object?> get props =>
      [language, tests, bestWpm, averageWpm, averageAccuracy];
}

/// Độ gom của biểu đồ: khoảng ngắn xem từng ngày, khoảng dài xem từng tháng.
enum TypingBucketUnit { day, month }

/// Một cột của biểu đồ (1 ngày hoặc 1 tháng).
class TypingBucket extends Equatable {
  final DateTime start;
  final TypingBucketUnit unit;
  final int tests;
  final double bestWpm;
  final double averageWpm;

  const TypingBucket({
    required this.start,
    required this.unit,
    required this.tests,
    required this.bestWpm,
    required this.averageWpm,
  });

  @override
  List<Object?> get props => [start, unit, tests, bestWpm, averageWpm];
}

/// Kết quả thống kê cho một khoảng ngày.
class TypingReport extends Equatable {
  final DateTime from;
  final DateTime to;
  final int totalTests;
  final double bestWpm;
  final double averageWpm;
  final double averageAccuracy;
  final int totalSeconds;

  /// Mọi ngày trong khoảng, kể cả ngày không làm bài (để vẽ biểu đồ).
  final List<TypingDaySummary> days;

  /// Gom theo ngôn ngữ, nhiều bài nhất đứng trước.
  final List<TypingLanguageSummary> languages;

  const TypingReport({
    required this.from,
    required this.to,
    required this.totalTests,
    required this.bestWpm,
    required this.averageWpm,
    required this.averageAccuracy,
    required this.totalSeconds,
    required this.days,
    required this.languages,
  });

  static final empty = TypingReport(
    from: _dayOnly(DateTime(2000)),
    to: _dayOnly(DateTime(2000)),
    totalTests: 0,
    bestWpm: 0,
    averageWpm: 0,
    averageAccuracy: 0,
    totalSeconds: 0,
    days: const [],
    languages: const [],
  );

  /// Số ngày có làm bài.
  int get activeDays => days.where((d) => d.tests > 0).length;

  /// Số ngày trong khoảng.
  int get dayCount => days.length;

  /// Số ngày liên tiếp có luyện, tính lùi từ cuối khoảng.
  /// Ngày cuối chưa luyện thì không phá chuỗi (mới sang ngày mới).
  int get streakDays {
    var streak = 0;
    for (var i = days.length - 1; i >= 0; i--) {
      if (days[i].tests > 0) {
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
        totalTests,
        bestWpm,
        averageWpm,
        averageAccuracy,
        totalSeconds,
        days,
        languages,
      ];
}

/// Gom [results] thành report cho khoảng ngày [from]..[to] (bao gồm cả 2 đầu).
/// Logic thuần (không phụ thuộc Drift/Flutter) → dễ unit test.
TypingReport summarizeTyping({
  required List<TypingResult> results,
  required DateTime from,
  required DateTime to,
}) {
  final start = _dayOnly(from);
  final end = _dayOnly(to);

  final byDay = <DateTime, List<TypingResult>>{};
  final byLanguage = <TypingLanguage, List<TypingResult>>{};
  final inRange = <TypingResult>[];

  for (final r in results) {
    final day = _dayOnly(r.takenAt);
    if (day.isBefore(start) || day.isAfter(end)) continue;
    (byDay[day] ??= []).add(r);
    (byLanguage[r.language] ??= []).add(r);
    inRange.add(r);
  }

  final days = <TypingDaySummary>[];
  for (var d = start;
      !d.isAfter(end);
      d = DateTime(d.year, d.month, d.day + 1)) {
    final items = byDay[d] ?? const <TypingResult>[];
    days.add(TypingDaySummary(
      date: d,
      tests: items.length,
      bestWpm: _best(items),
      averageWpm: _averageWpm(items),
      averageAccuracy: _averageAccuracy(items),
      totalSeconds: items.fold(0, (sum, r) => sum + r.elapsedSeconds),
    ));
  }

  final languages = byLanguage.entries
      .map((e) => TypingLanguageSummary(
            language: e.key,
            tests: e.value.length,
            bestWpm: _best(e.value),
            averageWpm: _averageWpm(e.value),
            averageAccuracy: _averageAccuracy(e.value),
          ))
      .toList()
    ..sort((a, b) {
      final byTests = b.tests.compareTo(a.tests);
      return byTests != 0 ? byTests : a.language.index.compareTo(b.language.index);
    });

  return TypingReport(
    from: start,
    to: end,
    totalTests: inRange.length,
    bestWpm: _best(inRange),
    averageWpm: _averageWpm(inRange),
    averageAccuracy: _averageAccuracy(inRange),
    totalSeconds: inRange.fold(0, (sum, r) => sum + r.elapsedSeconds),
    days: days,
    languages: languages,
  );
}

/// Khoảng dài (> 62 ngày) thì vẽ theo tháng cho dễ đọc.
TypingBucketUnit autoTypingBucketUnit(int dayCount) =>
    dayCount > 62 ? TypingBucketUnit.month : TypingBucketUnit.day;

/// Gom tổng hợp ngày thành cột biểu đồ theo [unit]; WPM trung bình của tháng
/// tính theo trọng số số bài (không phải trung bình của trung bình ngày).
List<TypingBucket> bucketTypingDays(
  List<TypingDaySummary> days,
  TypingBucketUnit unit,
) {
  if (unit == TypingBucketUnit.day) {
    return days
        .map((d) => TypingBucket(
              start: d.date,
              unit: unit,
              tests: d.tests,
              bestWpm: d.bestWpm,
              averageWpm: d.averageWpm,
            ))
        .toList();
  }

  final tests = <DateTime, int>{};
  final best = <DateTime, double>{};
  final sumWpm = <DateTime, double>{};
  for (final d in days) {
    final key = DateTime(d.date.year, d.date.month);
    tests[key] = (tests[key] ?? 0) + d.tests;
    final currentBest = best[key] ?? 0;
    best[key] = d.bestWpm > currentBest ? d.bestWpm : currentBest;
    sumWpm[key] = (sumWpm[key] ?? 0) + d.averageWpm * d.tests;
  }
  final keys = tests.keys.toList()..sort();
  return [
    for (final k in keys)
      TypingBucket(
        start: k,
        unit: unit,
        tests: tests[k]!,
        bestWpm: best[k]!,
        averageWpm: tests[k]! == 0 ? 0 : sumWpm[k]! / tests[k]!,
      ),
  ];
}

double _best(List<TypingResult> items) =>
    items.fold(0.0, (m, r) => r.wpm > m ? r.wpm : m);

double _averageWpm(List<TypingResult> items) => items.isEmpty
    ? 0
    : items.fold(0.0, (sum, r) => sum + r.wpm) / items.length;

double _averageAccuracy(List<TypingResult> items) => items.isEmpty
    ? 0
    : items.fold(0.0, (sum, r) => sum + r.accuracy) / items.length;
