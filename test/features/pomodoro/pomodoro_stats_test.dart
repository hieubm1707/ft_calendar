import 'package:example_app/features/pomodoro/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PomodoroSession session({
    required DateTime start,
    int seconds = 25 * 60,
    bool completed = true,
    String? label,
  }) =>
      PomodoroSession(
        startedAt: start,
        endedAt: start.add(Duration(seconds: seconds)),
        focusSeconds: seconds,
        plannedSeconds: 25 * 60,
        completed: completed,
        label: label,
      );

  final from = DateTime(2026, 8, 18); // Thứ Ba
  final to = DateTime(2026, 8, 24); // Hôm nay (7 ngày)

  test('mọi ngày trong khoảng đều có mặt, kể cả ngày không tập trung', () {
    final r = summarizePomodoro(sessions: [], from: from, to: to);
    expect(r.days.length, 7);
    expect(r.days.first.date, DateTime(2026, 8, 18));
    expect(r.days.last.date, DateTime(2026, 8, 24));
    expect(r.days.every((d) => d.sessions == 0), isTrue);
    expect(r.totalFocusSeconds, 0);
    expect(r.activeDays, 0);
    expect(r.averageSecondsPerActiveDay, 0);
  });

  test('cộng dồn theo ngày và tổng chung', () {
    final r = summarizePomodoro(
      sessions: [
        session(start: DateTime(2026, 8, 20, 9), seconds: 1500),
        session(start: DateTime(2026, 8, 20, 14), seconds: 900),
        session(start: DateTime(2026, 8, 24, 8), seconds: 600),
      ],
      from: from,
      to: to,
    );
    expect(r.totalSessions, 3);
    expect(r.totalFocusSeconds, 3000);
    final day20 = r.days.firstWhere((d) => d.date == DateTime(2026, 8, 20));
    expect(day20.sessions, 2);
    expect(day20.focusSeconds, 2400);
    expect(r.bestDayFocusSeconds, 2400);
    expect(r.activeDays, 2);
    expect(r.averageSecondsPerActiveDay, 1500);
  });

  test('bỏ qua phiên ngoài khoảng', () {
    final r = summarizePomodoro(
      sessions: [
        session(start: DateTime(2026, 8, 17, 10)), // trước from
        session(start: DateTime(2026, 8, 25, 10)), // sau to
        session(start: DateTime(2026, 8, 19, 10)),
      ],
      from: from,
      to: to,
    );
    expect(r.totalSessions, 1);
  });

  test('đếm riêng phiên trọn vẹn và phiên dừng sớm', () {
    final r = summarizePomodoro(
      sessions: [
        session(start: DateTime(2026, 8, 21, 9)),
        session(start: DateTime(2026, 8, 21, 10), seconds: 300, completed: false),
      ],
      from: from,
      to: to,
    );
    expect(r.totalSessions, 2);
    expect(r.completedSessions, 1);
    expect(r.totalFocusSeconds, 1800);
  });

  test('gom theo việc, giảm dần theo thời gian; nhãn rỗng gom chung', () {
    final r = summarizePomodoro(
      sessions: [
        session(start: DateTime(2026, 8, 19, 9), seconds: 600, label: 'Viết blog'),
        session(start: DateTime(2026, 8, 20, 9), seconds: 1500, label: 'Học Flutter'),
        session(start: DateTime(2026, 8, 21, 9), seconds: 300, label: '  '),
        session(start: DateTime(2026, 8, 22, 9), seconds: 300),
      ],
      from: from,
      to: to,
    );
    expect(r.labels.first.label, 'Học Flutter');
    expect(r.labels.first.focusSeconds, 1500);
    final unnamed = r.labels.firstWhere((l) => l.label.isEmpty);
    expect(unnamed.sessions, 2); // '  ' (trim) + null gom chung
    expect(unnamed.focusSeconds, 600);
  });

  test('streak: đếm lùi từ cuối, ngày cuối trống không phá chuỗi', () {
    final r = summarizePomodoro(
      sessions: [
        session(start: DateTime(2026, 8, 22, 9)),
        session(start: DateTime(2026, 8, 23, 9)),
      ],
      from: from,
      to: to, // 24/8 chưa tập trung
    );
    expect(r.streakDays, 2);

    final broken = summarizePomodoro(
      sessions: [
        session(start: DateTime(2026, 8, 20, 9)),
        session(start: DateTime(2026, 8, 23, 9)),
      ],
      from: from,
      to: to,
    );
    expect(broken.streakDays, 1);
  });
}
