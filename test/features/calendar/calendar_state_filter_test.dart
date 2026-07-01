import 'package:example_app/core/domain/index.dart';
import 'package:example_app/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Kiểm thử logic lọc theo màu của CalendarState.eventsOf (tính năng "lọc theo màu").
void main() {
  final day = DateTime(2026, 7, 1);
  Event ev(int color) => Event(
        id: color,
        title: 'e$color',
        startTime: day,
        endTime: day,
        color: color,
      );

  final state = CalendarState(
    status: CalendarStatus.success,
    eventsByDay: {
      DateTime(2026, 7, 1): [ev(0xFFEF5350), ev(0xFFAB47BC), ev(0xFF42A5F5)],
    },
  );

  test('activeColors rỗng → hiện tất cả', () {
    expect(state.eventsOf(day).length, 3);
  });

  test('lọc 1 màu → chỉ sự kiện màu đó', () {
    final filtered = state.copyWith(activeColors: {0xFFAB47BC});
    final result = filtered.eventsOf(day);
    expect(result.length, 1);
    expect(result.single.color, 0xFFAB47BC);
  });

  test('lọc nhiều màu → gồm đúng các màu đã chọn', () {
    final filtered = state.copyWith(activeColors: {0xFFEF5350, 0xFF42A5F5});
    expect(filtered.eventsOf(day).map((e) => e.color).toSet(),
        {0xFFEF5350, 0xFF42A5F5});
  });
}
