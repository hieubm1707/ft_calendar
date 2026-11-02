import 'package:example_app/features/tracking/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrackingReminderRule.matches', () {
    const lt50 = TrackingReminderRule(minutes: 1200, percent: 50);
    const eq0 = TrackingReminderRule(
      minutes: 1140,
      comparison: ReminderComparison.equals,
      percent: 0,
    );

    test('< so chính xác theo tỉ lệ', () {
      expect(lt50.matches(done: 1, total: 3), isTrue); // 33%
      expect(lt50.matches(done: 1, total: 2), isFalse); // đúng 50%
      expect(lt50.matches(done: 2, total: 3), isFalse); // 67%
    });

    test('= so theo % làm tròn', () {
      expect(eq0.matches(done: 0, total: 4), isTrue);
      expect(eq0.matches(done: 1, total: 4), isFalse);
      const eq67 = TrackingReminderRule(
        minutes: 0,
        comparison: ReminderComparison.equals,
        percent: 67,
      );
      expect(eq67.matches(done: 2, total: 3), isTrue);
    });

    test('ngày không có mục tiêu thì không nhắc', () {
      expect(eq0.matches(done: 0, total: 0), isFalse);
      expect(lt50.matches(done: 0, total: 0), isFalse);
    });
  });

  group('planTrackingReminders', () {
    final daily = TrackingGoal(
      id: 1,
      name: 'A',
      startDate: DateTime(2026, 10, 1),
    );
    final daily2 = TrackingGoal(
      id: 2,
      name: 'B',
      startDate: DateTime(2026, 10, 1),
    );
    // Chỉ thứ 2 (2026-11-02).
    final mondays = TrackingGoal(
      id: 3,
      name: 'C',
      frequency: TrackingFrequency.weekdays,
      weekdays: const {1},
      startDate: DateTime(2026, 10, 1),
    );
    // Thứ 5 29/10/2026, 20:30.
    final now = DateTime(2026, 10, 29, 20, 30);

    test(
      'hôm nay: bỏ giờ đã qua, chỉ đặt luật đang thoả; ngày sau tính 0 lượt',
      () {
        final plan = planTrackingReminders(
          rules: TrackingReminderRule.defaults,
          goals: [daily, daily2],
          // Hôm nay xong 1/2 = 50%.
          doneKeys: {trackingKey(TrackingSource.goal, 1, now)},
          now: now,
          days: 2,
        );
        final today = plan.where((p) => p.dayIndex == 0).toList();
        // 20:00 đã qua; 21:00 (<65) và 22:00, 23:00 (<80) thoả với 50%.
        expect(today.map((p) => p.when.hour), [21, 22, 23]);
        expect(today.first.done, 1);
        expect(today.first.percent, 50);

        final tomorrow = plan.where((p) => p.dayIndex == 1).toList();
        expect(tomorrow.map((p) => p.when.hour), [20, 21, 22, 23]);
        expect(tomorrow.first.when, DateTime(2026, 10, 30, 20));
        expect(tomorrow.first.done, 0);
      },
    );

    test('đã xong hết thì không nhắc gì hôm nay', () {
      final plan = planTrackingReminders(
        rules: TrackingReminderRule.defaults,
        goals: [daily],
        doneKeys: {trackingKey(TrackingSource.goal, 1, now)},
        now: now,
        days: 1,
      );
      expect(plan, isEmpty);
    });

    test('luật tắt bị bỏ qua; ngày không có mục tiêu không nhắc', () {
      final plan = planTrackingReminders(
        rules: [
          const TrackingReminderRule(minutes: 1260, percent: 100),
          const TrackingReminderRule(
            minutes: 1320,
            percent: 100,
            enabled: false,
          ),
        ],
        goals: [mondays],
        doneKeys: const {},
        now: now,
        days: 7,
      );
      // Chỉ thứ 2/11 có mục tiêu.
      expect(plan, hasLength(1));
      expect(plan.single.when, DateTime(2026, 11, 2, 21));
      expect(plan.single.dayIndex, 4);
    });
  });
}
