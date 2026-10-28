import 'package:example_app/features/tracking/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Thứ Hai 2026-10-05 .. Chủ Nhật 2026-10-11.
  final mon = DateTime(2026, 10, 5);

  TrackingGoal daily({DateTime? start, DateTime? end}) => TrackingGoal(
    id: 1,
    name: 'Uống nước',
    startDate: start ?? DateTime(2026, 10, 1),
    endDate: end,
  );

  TrackingGoal monWedFri() => TrackingGoal(
    id: 2,
    name: 'Chạy bộ',
    frequency: TrackingFrequency.weekdays,
    weekdays: const {1, 3, 5},
    startDate: DateTime(2026, 10, 1),
  );

  Set<DateTime> days(List<int> octDays) => {
    for (final d in octDays) DateTime(2026, 10, d),
  };

  group('isDueOn', () {
    test('hằng ngày: mọi ngày từ ngày bắt đầu, trước đó thì không', () {
      final g = daily();
      expect(g.isDueOn(DateTime(2026, 9, 30)), isFalse);
      expect(g.isDueOn(DateTime(2026, 10, 1, 23, 59)), isTrue);
      expect(g.isDueOn(DateTime(2026, 10, 11)), isTrue);
    });

    test('chọn thứ: chỉ đúng các thứ đã chọn', () {
      final g = monWedFri();
      expect(g.isDueOn(mon), isTrue); // T2
      expect(g.isDueOn(DateTime(2026, 10, 6)), isFalse); // T3
      expect(g.isDueOn(DateTime(2026, 10, 7)), isTrue); // T4
      expect(g.isDueOn(DateTime(2026, 10, 11)), isFalse); // CN
    });

    test('ngày kết thúc: tính cả ngày kết thúc, sau đó thì không', () {
      final g = daily(end: DateTime(2026, 10, 5));
      expect(g.isDueOn(DateTime(2026, 10, 5)), isTrue);
      expect(g.isDueOn(DateTime(2026, 10, 6)), isFalse);
    });
  });

  test('goalsDueOn lọc theo ngày', () {
    final r = goalsDueOn([daily(), monWedFri()], DateTime(2026, 10, 6));
    expect(r.map((g) => g.id), [1]);
  });

  group('computeGoalStats', () {
    test('hôm nay chưa xong không làm đứt chuỗi hiện tại', () {
      // Bắt đầu 1/10, xong 3,4,5; hôm nay 6/10 chưa xong.
      final s = computeGoalStats(
        goal: daily(),
        doneDays: days([3, 4, 5]),
        today: DateTime(2026, 10, 6),
        month: DateTime(2026, 10),
      );
      expect(s.scheduledDays, 6); // 1..6
      expect(s.completedDays, 3);
      expect(s.currentStreak, 3);
      expect(s.bestStreak, 3);
    });

    test('bỏ lỡ 1 ngày làm đứt chuỗi; chuỗi dài nhất giữ nguyên', () {
      // Xong 1,2,3,4 — bỏ 5 — xong 6,7; hôm nay 7.
      final s = computeGoalStats(
        goal: daily(),
        doneDays: days([1, 2, 3, 4, 6, 7]),
        today: DateTime(2026, 10, 7),
        month: DateTime(2026, 10),
      );
      expect(s.currentStreak, 2);
      expect(s.bestStreak, 4);
      expect(s.completionRate, closeTo(6 / 7, 1e-9));
    });

    test('chọn thứ: ngày không phải làm không làm đứt chuỗi', () {
      // T2 5/10, T4 7/10, T6 9/10 đều xong; hôm nay CN 11/10.
      final s = computeGoalStats(
        goal: monWedFri(),
        doneDays: days([2, 5, 7, 9]),
        today: DateTime(2026, 10, 11),
        month: DateTime(2026, 10),
      );
      // 1/10 là T5, 2/10 là T6 → phải làm: 2, 5, 7, 9.
      expect(s.scheduledDays, 4);
      expect(s.completedDays, 4);
      expect(s.currentStreak, 4);
    });

    test('đã kết thúc: chỉ đếm tới ngày kết thúc', () {
      final s = computeGoalStats(
        goal: daily(end: DateTime(2026, 10, 3)),
        doneDays: days([1, 2, 3]),
        today: DateTime(2026, 10, 20),
        month: DateTime(2026, 10),
      );
      expect(s.scheduledDays, 3);
      expect(s.currentStreak, 3);
    });

    test('doneInMonth theo tháng đang xem, totalDone tính hết', () {
      final done = {
        DateTime(2026, 9, 29),
        DateTime(2026, 9, 30),
        ...days([1, 2]),
      };
      final s = computeGoalStats(
        goal: daily(start: DateTime(2026, 9, 1)),
        doneDays: done,
        today: DateTime(2026, 10, 2),
        month: DateTime(2026, 9),
      );
      expect(s.doneInMonth, 2);
      expect(s.totalDone, 4);
    });
  });

  test(
    'monthDayStatus: đã xong / bỏ lỡ / hôm nay chờ / không phải làm / tương lai',
    () {
      final r = monthDayStatus(
        goal: monWedFri(),
        doneDays: days([5]),
        month: DateTime(2026, 10),
        today: DateTime(2026, 10, 9),
      );
      expect(r, hasLength(31));
      expect(r[4], TrackingDayStatus.done); // T2 5/10
      expect(r[5], TrackingDayStatus.notDue); // T3 6/10
      expect(r[6], TrackingDayStatus.missed); // T4 7/10
      expect(r[8], TrackingDayStatus.pending); // T6 9/10 = hôm nay
      expect(r[11], TrackingDayStatus.future); // 12/10
    },
  );

  test('trackingKey phân biệt nguồn mục tiêu và task', () {
    final d = DateTime(2026, 10, 5, 8);
    expect(
      trackingKey(TrackingSource.goal, 1, d),
      isNot(trackingKey(TrackingSource.task, 1, d)),
    );
    expect(
      trackingKey(TrackingSource.goal, 1, d),
      trackingKey(TrackingSource.goal, 1, DateTime(2026, 10, 5)),
    );
  });
}
