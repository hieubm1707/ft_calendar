import 'entities/task_instance.dart';
import 'entities/task_schedule.dart';

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Khoá hoàn thành (scheduleId + ngày) để tra nhanh trạng thái done.
String taskDoneKey(int scheduleId, DateTime date) {
  final d = _dayOnly(date);
  return '$scheduleId|${d.year}-${d.month}-${d.day}';
}

/// Sinh các TaskInstance trong [from, to] từ danh sách lịch task.
/// Logic thuần (không phụ thuộc Drift/Flutter) → dễ unit test.
List<TaskInstance> expandTaskInstances({
  required List<TaskSchedule> schedules,
  required Set<String> doneKeys,
  required DateTime from,
  required DateTime to,
}) {
  final start = _dayOnly(from);
  final end = _dayOnly(to);
  final out = <TaskInstance>[];

  for (final s in schedules) {
    final id = s.id;
    if (id == null) continue;

    if (s.type == TaskRecurrence.dates) {
      for (final raw in s.dates) {
        final d = _dayOnly(raw);
        if (d.isBefore(start) || d.isAfter(end)) continue;
        out.add(_instance(s, id, d, doneKeys));
      }
    } else {
      // weekly
      if (!s.active) continue;
      final anchor = _dayOnly(s.startDate);
      var d = start.isBefore(anchor) ? anchor : start;
      while (!d.isAfter(end)) {
        if (s.weekdays.contains(d.weekday)) {
          out.add(_instance(s, id, d, doneKeys));
        }
        d = d.add(const Duration(days: 1));
      }
    }
  }

  out.sort((a, b) => a.date.compareTo(b.date));
  return out;
}

TaskInstance _instance(
    TaskSchedule s, int id, DateTime day, Set<String> doneKeys) {
  return TaskInstance(
    scheduleId: id,
    date: day,
    title: s.title,
    color: s.color,
    done: doneKeys.contains(taskDoneKey(id, day)),
    isRecurring: s.isRecurring,
  );
}
