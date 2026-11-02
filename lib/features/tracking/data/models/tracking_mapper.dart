import 'package:drift/drift.dart';

import '../../../../core/database/drift/index.dart';
import '../../domain/index.dart';

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

const _allDaysMask = 127;

/// weekdays (1..7) ↔ bitmask (bit weekday-1) — cùng quy ước với bảng task.
int _toMask(Set<int> weekdays) =>
    weekdays.fold(0, (m, w) => m | (1 << (w - 1)));

Set<int> _fromMask(int mask) => {
  for (var w = 1; w <= 7; w++)
    if (mask & (1 << (w - 1)) != 0) w,
};

List<int> _parseReminders(String? csv) => (csv == null || csv.isEmpty)
    ? const []
    : (csv.split(',').map(int.parse).toList()..sort());

extension TrackingGoalRowMapper on TrackingGoalTableData {
  TrackingGoal toEntity() => TrackingGoal(
    id: id,
    name: name,
    description: description,
    color: color,
    frequency: weekdaysMask == _allDaysMask
        ? TrackingFrequency.daily
        : TrackingFrequency.weekdays,
    weekdays: _fromMask(weekdaysMask),
    startDate: startDate,
    endDate: endDate,
    reminders: _parseReminders(remindersCsv),
  );
}

extension TrackingGoalEntityMapper on TrackingGoal {
  TrackingGoalTableCompanion toCompanion() => TrackingGoalTableCompanion(
    name: Value(name),
    description: Value(description),
    color: Value(color),
    weekdaysMask: Value(
      frequency == TrackingFrequency.daily ? _allDaysMask : _toMask(weekdays),
    ),
    startDate: Value(_dayOnly(startDate)),
    endDate: Value(endDate == null ? null : _dayOnly(endDate!)),
    remindersCsv: Value(reminders.isEmpty ? null : reminders.join(',')),
  );
}

extension TrackingCheckinRowMapper on TrackingCheckinTableData {
  TrackingCheckin toEntity() => TrackingCheckin(
    source: TrackingSource.goal,
    goalId: goalId,
    date: _dayOnly(date),
  );
}

/// Task hằng tuần bên Tasks → mục tiêu "ảo" ở Tracking.
extension TaskScheduleAsTrackingGoal on TaskScheduleTableData {
  bool get isActiveWeekly => type == 'weekly' && active;

  TrackingGoal toTrackingGoal() => TrackingGoal(
    id: id,
    source: TrackingSource.task,
    name: title,
    description: note,
    color: color,
    frequency: weekdaysMask == _allDaysMask
        ? TrackingFrequency.daily
        : TrackingFrequency.weekdays,
    weekdays: _fromMask(weekdaysMask),
    startDate: _dayOnly(startDate),
  );
}

extension TaskCompletionAsCheckin on TaskCompletionTableData {
  TrackingCheckin toTrackingCheckin() => TrackingCheckin(
    source: TrackingSource.task,
    goalId: scheduleId,
    date: _dayOnly(date),
  );
}
