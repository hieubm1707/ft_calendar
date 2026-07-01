import 'package:drift/drift.dart';

import '../../../../core/database/drift/index.dart';
import '../../domain/index.dart';

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
String _fmt(DateTime d) => '${d.year}-${d.month}-${d.day}';

DateTime _parse(String s) {
  final p = s.split('-');
  return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
}

/// weekdays (1..7) ↔ bitmask (bit weekday-1).
int weekdaysToMask(Set<int> weekdays) =>
    weekdays.fold(0, (m, w) => m | (1 << (w - 1)));

Set<int> maskToWeekdays(int mask) =>
    {for (var w = 1; w <= 7; w++) if (mask & (1 << (w - 1)) != 0) w};

extension TaskScheduleRowMapper on TaskScheduleTableData {
  TaskSchedule toEntity() => TaskSchedule(
        id: id,
        title: title,
        type: type == 'weekly' ? TaskRecurrence.weekly : TaskRecurrence.dates,
        dates: (datesCsv == null || datesCsv!.isEmpty)
            ? const []
            : datesCsv!.split(',').map(_parse).toList(),
        weekdays: maskToWeekdays(weekdaysMask),
        startDate: startDate,
        active: active,
        color: color,
      );
}

extension TaskScheduleEntityMapper on TaskSchedule {
  TaskScheduleTableCompanion toInsertCompanion() =>
      TaskScheduleTableCompanion.insert(
        title: title,
        type: type == TaskRecurrence.weekly ? 'weekly' : 'dates',
        startDate: _dayOnly(startDate),
        createdAt: DateTime.now(),
        datesCsv: Value(
            dates.isEmpty ? null : dates.map((d) => _fmt(_dayOnly(d))).join(',')),
        weekdaysMask: Value(weekdaysToMask(weekdays)),
        color: Value(color),
        active: Value(active),
      );
}
