import 'package:example_app/features/pomodoro/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PomodoroSession session({
    required DateTime start,
    int seconds = 25 * 60,
    bool completed = true,
    String? label,
    int? focusTagId,
  }) =>
      PomodoroSession(
        startedAt: start,
        endedAt: start.add(Duration(seconds: seconds)),
        focusSeconds: seconds,
        plannedSeconds: 25 * 60,
        completed: completed,
        label: label,
        focusTagId: focusTagId,
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

  test('gom theo nhãn, giảm dần theo thời gian; nhãn rỗng gom chung', () {
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
    expect(r.tags.first.label, 'Học Flutter');
    expect(r.tags.first.focusSeconds, 1500);
    final unnamed = r.tags.firstWhere((l) => l.label.isEmpty);
    expect(unnamed.sessions, 2); // '  ' (trim) + null gom chung
    expect(unnamed.focusSeconds, 600);
  });

  test('focus trend: gom theo tag, lấy tên tag hiện tại chứ không phải nhãn cũ',
      () {
    final r = summarizePomodoro(
      sessions: [
        // Nhãn lưu trong phiên là tên cũ của tag 1.
        session(
            start: DateTime(2026, 8, 19, 9),
            seconds: 900,
            label: 'Cong viec',
            focusTagId: 1),
        session(
            start: DateTime(2026, 8, 20, 9),
            seconds: 1500,
            label: 'Work',
            focusTagId: 1),
        session(
            start: DateTime(2026, 8, 21, 9),
            seconds: 600,
            label: 'Read',
            focusTagId: 2),
      ],
      from: from,
      to: to,
      tagTitles: const {1: 'Work', 2: 'Read'},
    );
    expect(r.tags.length, 2);
    expect(r.topTag!.tagId, 1);
    expect(r.topTag!.label, 'Work');
    expect(r.topTag!.sessions, 2);
    expect(r.topTag!.focusSeconds, 2400);
    expect(r.shareOf(r.topTag!), closeTo(2400 / 3000, 0.0001));
  });

  test('cùng nhãn nhưng khác tag thì tách riêng', () {
    final r = summarizePomodoro(
      sessions: [
        session(start: DateTime(2026, 8, 19, 9), seconds: 600, focusTagId: 1),
        session(start: DateTime(2026, 8, 20, 9), seconds: 600, focusTagId: 2),
        session(start: DateTime(2026, 8, 21, 9), seconds: 600, label: 'Focus'),
      ],
      from: from,
      to: to,
      tagTitles: const {1: 'Focus', 2: 'Focus'},
    );
    // 2 tag trùng tên + 1 phiên không gắn tag = 3 nhóm.
    expect(r.tags.length, 3);
  });

  test('bucket: khoảng ngắn giữ theo ngày, khoảng dài gom theo tháng', () {
    final r = summarizePomodoro(
      sessions: [
        session(start: DateTime(2026, 1, 5, 9), seconds: 600),
        session(start: DateTime(2026, 1, 20, 9), seconds: 900),
        session(start: DateTime(2026, 3, 2, 9), seconds: 300),
      ],
      from: DateTime(2026, 1, 1),
      to: DateTime(2026, 3, 31),
    );
    expect(autoBucketUnit(r.dayCount), PomodoroBucketUnit.month);

    final months = bucketDaySummaries(r.days, PomodoroBucketUnit.month);
    expect(months.length, 3); // 1, 2, 3 — tháng trống vẫn có mặt
    expect(months.first.start, DateTime(2026, 1));
    expect(months.first.focusSeconds, 1500);
    expect(months[1].focusSeconds, 0);
    expect(months.last.focusSeconds, 300);

    final short = summarizePomodoro(
        sessions: const [], from: DateTime(2026, 8, 18), to: DateTime(2026, 8, 24));
    expect(autoBucketUnit(short.dayCount), PomodoroBucketUnit.day);
    expect(bucketDaySummaries(short.days, PomodoroBucketUnit.day).length, 7);
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
