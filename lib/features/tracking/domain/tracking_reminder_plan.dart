import 'package:equatable/equatable.dart';

import 'entities/tracking_goal.dart';
import 'entities/tracking_reminder_rule.dart';
import 'tracking_stats.dart';

/// Một thông báo nhắc cần đặt: luật [ruleIndex] vào ngày thứ [dayIndex] tính
/// từ hôm nay (0 = hôm nay), lúc [when], khi đã xong [done]/[total] mục tiêu.
class PlannedTrackingReminder extends Equatable {
  final int ruleIndex;
  final int dayIndex;
  final DateTime when;
  final int done;
  final int total;

  const PlannedTrackingReminder({
    required this.ruleIndex,
    required this.dayIndex,
    required this.when,
    required this.done,
    required this.total,
  });

  int get percent => total == 0 ? 0 : (done * 100 / total).round();

  @override
  List<Object?> get props => [ruleIndex, dayIndex, when, done, total];
}

/// Lên danh sách nhắc cho [days] ngày tính từ hôm nay (logic thuần → unit test).
///
/// Thông báo cục bộ không tự kiểm tra điều kiện lúc nổ, nên điều kiện được xét
/// NGAY khi lên lịch: hôm nay theo số đã xong hiện tại; các ngày sau chưa thể
/// có lượt nào nên tính theo 0 lượt. Tỉ lệ chỉ đổi khi người dùng check-in
/// trong app → app lên lịch lại sau mỗi thay đổi là luôn đúng. Ngày không có
/// mục tiêu nào và giờ đã qua thì bỏ.
List<PlannedTrackingReminder> planTrackingReminders({
  required List<TrackingReminderRule> rules,
  required List<TrackingGoal> goals,
  required Set<String> doneKeys,
  required DateTime now,
  int days = 7,
}) {
  final out = <PlannedTrackingReminder>[];
  for (var dayIndex = 0; dayIndex < days; dayIndex++) {
    final day = DateTime(now.year, now.month, now.day + dayIndex);
    final due = goalsDueOn(goals, day);
    if (due.isEmpty) continue;
    final done = dayIndex == 0
        ? due.where((g) => isGoalDoneOn(g, day, doneKeys)).length
        : 0;
    for (var i = 0; i < rules.length; i++) {
      final rule = rules[i];
      if (!rule.enabled) continue;
      final when = DateTime(
        day.year,
        day.month,
        day.day,
        rule.minutes ~/ 60,
        rule.minutes % 60,
      );
      if (!when.isAfter(now)) continue;
      if (!rule.matches(done: done, total: due.length)) continue;
      out.add(
        PlannedTrackingReminder(
          ruleIndex: i,
          dayIndex: dayIndex,
          when: when,
          done: done,
          total: due.length,
        ),
      );
    }
  }
  return out;
}
