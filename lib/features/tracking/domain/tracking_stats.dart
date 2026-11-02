import 'package:equatable/equatable.dart';

import 'entities/tracking_checkin.dart';
import 'entities/tracking_goal.dart';

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Khoá hoàn thành (nguồn + id + ngày) để tra nhanh trạng thái done.
String trackingKey(TrackingSource source, int goalId, DateTime date) {
  final d = _dayOnly(date);
  return '${source.name}|$goalId|${d.year}-${d.month}-${d.day}';
}

Set<String> trackingDoneKeys(Iterable<TrackingCheckin> checkins) => {
  for (final c in checkins) trackingKey(c.source, c.goalId, c.date),
};

bool isGoalDoneOn(TrackingGoal goal, DateTime day, Set<String> doneKeys) =>
    goal.id != null &&
    doneKeys.contains(trackingKey(goal.source, goal.id!, day));

/// Mục tiêu phải làm vào [day], giữ nguyên thứ tự đầu vào.
List<TrackingGoal> goalsDueOn(List<TrackingGoal> goals, DateTime day) =>
    goals.where((g) => g.isDueOn(day)).toList();

/// Chỉ số của 1 mục tiêu (logic thuần → unit test được).
class TrackingGoalStats extends Equatable {
  /// Số ngày phải làm từ ngày bắt đầu tới hôm nay (hoặc ngày kết thúc).
  final int scheduledDays;

  /// Số ngày trong [scheduledDays] đã hoàn thành.
  final int completedDays;

  /// Chuỗi ngày-phải-làm liên tiếp đã hoàn thành tính tới hôm nay. Hôm nay
  /// chưa xong thì tính từ ngày phải làm trước đó (chưa xong ≠ đứt chuỗi).
  final int currentStreak;
  final int bestStreak;

  /// Lượt hoàn thành trong tháng đang xem.
  final int doneInMonth;

  /// Tổng lượt hoàn thành.
  final int totalDone;

  const TrackingGoalStats({
    required this.scheduledDays,
    required this.completedDays,
    required this.currentStreak,
    required this.bestStreak,
    required this.doneInMonth,
    required this.totalDone,
  });

  double get completionRate =>
      scheduledDays == 0 ? 0 : completedDays / scheduledDays;

  @override
  List<Object?> get props => [
    scheduledDays,
    completedDays,
    currentStreak,
    bestStreak,
    doneInMonth,
    totalDone,
  ];
}

/// Ngày đã hoàn thành của [goal] (chuẩn hoá bỏ giờ).
Set<DateTime> goalDoneDays(
  TrackingGoal goal,
  Iterable<TrackingCheckin> checkins,
) => {
  for (final c in checkins)
    if (c.source == goal.source && c.goalId == goal.id) _dayOnly(c.date),
};

TrackingGoalStats computeGoalStats({
  required TrackingGoal goal,
  required Set<DateTime> doneDays,
  required DateTime today,
  required DateTime month,
}) {
  final t = _dayOnly(today);
  final start = _dayOnly(goal.startDate);
  final end = goal.endDate == null ? t : _dayOnly(goal.endDate!);
  final last = end.isBefore(t) ? end : t;

  var scheduled = 0, completed = 0, run = 0, best = 0;
  for (var d = start; !d.isAfter(last); d = _nextDay(d)) {
    if (!goal.isDueOn(d)) continue;
    scheduled++;
    if (doneDays.contains(d)) {
      completed++;
      run++;
      if (run > best) best = run;
    } else if (d != t) {
      // Hôm nay chưa xong thì chưa tính là đứt chuỗi.
      run = 0;
    }
  }

  return TrackingGoalStats(
    scheduledDays: scheduled,
    completedDays: completed,
    currentStreak: run,
    bestStreak: best,
    doneInMonth: doneDays
        .where((d) => d.year == month.year && d.month == month.month)
        .length,
    totalDone: doneDays.length,
  );
}

/// Trạng thái 1 ô lịch tháng ở trang chi tiết. [pending] = hôm nay phải làm
/// nhưng chưa xong (vẫn còn thời gian, chưa tính là bỏ lỡ).
enum TrackingDayStatus { done, missed, pending, notDue, future }

/// Trạng thái từng ngày (1..số ngày) của tháng chứa [month].
List<TrackingDayStatus> monthDayStatus({
  required TrackingGoal goal,
  required Set<DateTime> doneDays,
  required DateTime month,
  required DateTime today,
}) {
  final t = _dayOnly(today);
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  return [
    for (var i = 1; i <= daysInMonth; i++)
      _statusOf(goal, doneDays, DateTime(month.year, month.month, i), t),
  ];
}

TrackingDayStatus _statusOf(
  TrackingGoal goal,
  Set<DateTime> doneDays,
  DateTime d,
  DateTime today,
) {
  if (doneDays.contains(d)) return TrackingDayStatus.done;
  if (d.isAfter(today)) return TrackingDayStatus.future;
  if (!goal.isDueOn(d)) return TrackingDayStatus.notDue;
  return d == today ? TrackingDayStatus.pending : TrackingDayStatus.missed;
}

// Cộng theo lịch (không cộng 24h) để không lệch ngày khi đổi giờ mùa hè.
DateTime _nextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);
