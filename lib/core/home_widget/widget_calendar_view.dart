import 'package:flutter/material.dart';

import '../domain/index.dart';

/// 3 chế độ = 3 cỡ widget.
enum WidgetMode { week, twoWeeks, month }

/// UI lịch dựng bằng Dart để render ra ảnh cho native widget (home/lock screen).
/// Hiển thị TÊN sự kiện (chip màu) giống trong app, không chỉ chấm.
class WidgetCalendarView extends StatelessWidget {
  final WidgetMode mode;
  final DateTime today;
  final List<Event> events;
  final Size size;

  const WidgetCalendarView({
    super.key,
    required this.mode,
    required this.today,
    required this.events,
    required this.size,
  });

  static const _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  static const _monthNames = [
    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
    'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
  ];

  /// Số chip tối đa mỗi ngày theo mode (tuần rộng chỗ hơn tháng).
  int get _maxChips => switch (mode) {
        WidgetMode.week => 5,
        WidgetMode.twoWeeks => 3,
        WidgetMode.month => 2,
      };

  DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime get _startOfWeek {
    final d = _dayOnly(today);
    return d.subtract(Duration(days: d.weekday - 1)); // về thứ Hai
  }

  List<DateTime?> _cells() {
    switch (mode) {
      case WidgetMode.week:
        return List.generate(7, (i) => _startOfWeek.add(Duration(days: i)));
      case WidgetMode.twoWeeks:
        return List.generate(14, (i) => _startOfWeek.add(Duration(days: i)));
      case WidgetMode.month:
        final first = DateTime(today.year, today.month, 1);
        final leading = first.weekday - 1;
        final days = DateUtils.getDaysInMonth(today.year, today.month);
        final total = leading + days;
        final rows = (total / 7).ceil();
        return List.generate(rows * 7, (i) {
          final dayNum = i - leading + 1;
          if (dayNum < 1 || dayNum > days) return null;
          return DateTime(today.year, today.month, dayNum);
        });
    }
  }

  Map<DateTime, List<Event>> get _byDay {
    final map = <DateTime, List<Event>>{};
    for (final e in events) {
      (map[_dayOnly(e.startTime)] ??= []).add(e);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final cells = _cells();
    final byDay = _byDay;
    const faint = Color(0x99FFFFFF);
    const accent = Color(0xFF00B3A6);

    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 7) {
      rows.add(Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(7, (c) {
            final date = i + c < cells.length ? cells[i + c] : null;
            return Expanded(
              child: date == null
                  ? const SizedBox()
                  : _DayCell(
                      date: date,
                      isToday: _dayOnly(date) == _dayOnly(today),
                      events: byDay[_dayOnly(date)] ?? const [],
                      accent: accent,
                      maxChips: _maxChips,
                    ),
            );
          }),
        ),
      ));
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xE6121212),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_monthNames[today.month - 1]} ${today.year}',
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: List.generate(
                  7,
                  (i) => Expanded(
                    child: Text(
                      _weekdays[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: i == today.weekday - 1 ? accent : faint,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              ...rows,
            ],
          ),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final List<Event> events;
  final Color accent;
  final int maxChips;

  const _DayCell({
    required this.date,
    required this.isToday,
    required this.events,
    required this.accent,
    required this.maxChips,
  });

  @override
  Widget build(BuildContext context) {
    final chips = events.take(maxChips).toList();
    final extra = events.length - chips.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Số ngày (hôm nay: chấm tròn accent)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: isToday
                  ? BoxDecoration(color: accent, shape: BoxShape.circle)
                  : null,
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: isToday ? Colors.white : const Color(0xFFEDEDED),
                  fontSize: 11,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          ...chips.map((e) => _EventChip(event: e)),
          if (extra > 0)
            Padding(
              padding: const EdgeInsets.only(left: 2, top: 1),
              child: Text(
                '+$extra',
                style: const TextStyle(fontSize: 7, color: Color(0x99FFFFFF)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Chip tên sự kiện: nền tinh màu + viền trái + chữ trắng (giống EventChip app).
class _EventChip extends StatelessWidget {
  final Event event;

  const _EventChip({required this.event});

  @override
  Widget build(BuildContext context) {
    final base = Color(event.color);
    return Container(
      margin: const EdgeInsets.only(bottom: 1.5),
      padding: const EdgeInsets.fromLTRB(3, 1, 2, 1),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(3),
        border: Border(left: BorderSide(color: base, width: 2)),
      ),
      child: Text(
        event.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 8,
          height: 1.15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
