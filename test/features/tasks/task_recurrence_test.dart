import 'package:example_app/features/tasks/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Tuần chứa: Thứ Hai 2026-06-29 .. Chủ Nhật 2026-07-05.
  final from = DateTime(2026, 6, 29);
  final to = DateTime(2026, 7, 12);

  TaskSchedule weekly(Set<int> wd, {DateTime? start, bool active = true}) =>
      TaskSchedule(
        id: 1,
        title: 'Viết blog',
        type: TaskRecurrence.weekly,
        weekdays: wd,
        startDate: start ?? DateTime(2026, 6, 1),
        active: active,
      );

  test('dates: đúng các ngày cụ thể trong khoảng', () {
    final s = TaskSchedule(
      id: 5,
      title: 'Họp',
      type: TaskRecurrence.dates,
      dates: [DateTime(2026, 7, 1), DateTime(2026, 7, 3), DateTime(2026, 8, 1)],
      startDate: DateTime(2026, 7, 1),
    );
    final r = expandTaskInstances(
        schedules: [s], doneKeys: {}, from: from, to: to);
    expect(r.map((e) => e.date).toList(),
        [DateTime(2026, 7, 1), DateTime(2026, 7, 3)]); // 8/1 ngoài khoảng
  });

  test('weekly: đúng thứ Hai trong khoảng (29/6 và 6/7)', () {
    final r = expandTaskInstances(
        schedules: [weekly({DateTime.monday})],
        doneKeys: {},
        from: from,
        to: to);
    expect(r.map((e) => e.date).toList(),
        [DateTime(2026, 6, 29), DateTime(2026, 7, 6)]);
    expect(r.every((e) => e.isRecurring), true);
  });

  test('weekly: tôn trọng startDate (bỏ trước mốc)', () {
    final r = expandTaskInstances(
        schedules: [weekly({DateTime.monday}, start: DateTime(2026, 7, 1))],
        doneKeys: {},
        from: from,
        to: to);
    expect(r.map((e) => e.date).toList(), [DateTime(2026, 7, 6)]);
  });

  test('weekly: active=false không sinh instance', () {
    final r = expandTaskInstances(
        schedules: [weekly({DateTime.monday}, active: false)],
        doneKeys: {},
        from: from,
        to: to);
    expect(r, isEmpty);
  });

  test('done map đúng theo doneKey', () {
    final key = taskDoneKey(1, DateTime(2026, 6, 29));
    final r = expandTaskInstances(
        schedules: [weekly({DateTime.monday})],
        doneKeys: {key},
        from: from,
        to: to);
    expect(r.firstWhere((e) => e.date == DateTime(2026, 6, 29)).done, true);
    expect(r.firstWhere((e) => e.date == DateTime(2026, 7, 6)).done, false);
  });
}
