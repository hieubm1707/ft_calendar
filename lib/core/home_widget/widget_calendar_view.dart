import 'package:flutter/material.dart';

import '../domain/index.dart';

/// 3 cỡ widget: day = 1 ngày (agenda), week = 1 tuần, month = 1 tháng.
enum WidgetMode { day, week, month }

/// UI lịch dựng bằng Dart để render ra ảnh cho native widget (home/lock screen).
/// Hiển thị TÊN sự kiện giống trong app.
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
  static const _weekdaysFull = [
    'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật',
  ];
  static const _monthNames = [
    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
    'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
  ];

  static const _bg = Color(0xE6121212);
  static const _white = Color(0xFFFFFFFF);
  static const _faint = Color(0x99FFFFFF);
  static const _accent = Color(0xFF00B3A6);

  DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime get _startOfWeek {
    final d = _dayOnly(today);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  int get _maxChips => mode == WidgetMode.month ? 2 : 3;

  Map<DateTime, List<Event>> get _byDay {
    final map = <DateTime, List<Event>>{};
    for (final e in events) {
      (map[_dayOnly(e.startTime)] ??= []).add(e);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: mode == WidgetMode.day ? _buildDay() : _buildGrid(),
        ),
      ),
    );
  }

  // ---- Day (Small): agenda hôm nay ----
  Widget _buildDay() {
    final list = [...events]..sort((a, b) => a.startTime.compareTo(b.startTime));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_weekdaysFull[today.weekday - 1]}, ${today.day}',
          style: const TextStyle(
              color: _white, fontSize: 15, fontWeight: FontWeight.w700),
        ),
        Text(
          '${_monthNames[today.month - 1]} ${today.year}',
          style: const TextStyle(color: _faint, fontSize: 11),
        ),
        const SizedBox(height: 8),
        if (list.isEmpty)
          const Expanded(
            child: Center(
              child: Text('Không có sự kiện',
                  style: TextStyle(color: _faint, fontSize: 12)),
            ),
          )
        else
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list.take(5).map(_agendaRow).toList(),
            ),
          ),
      ],
    );
  }

  Widget _agendaRow(Event e) {
    final base = Color(e.color);
    final hhmm =
        '${e.startTime.hour.toString().padLeft(2, '0')}:${e.startTime.minute.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 26,
            margin: const EdgeInsets.only(right: 6, top: 1),
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: _white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                Text(e.isAllDay ? 'Cả ngày' : hhmm,
                    style: const TextStyle(color: _faint, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- Week / Month: lưới ----
  Widget _buildGrid() {
    final cells = _gridCells();
    final byDay = _byDay;

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
                      maxChips: _maxChips,
                    ),
            );
          }),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${_monthNames[today.month - 1]} ${today.year}',
            style: const TextStyle(
                color: _white, fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Row(
          children: List.generate(
            7,
            (i) => Expanded(
              child: Text(_weekdays[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: i == today.weekday - 1 ? _accent : _faint,
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ),
        const SizedBox(height: 3),
        ...rows,
      ],
    );
  }

  List<DateTime?> _gridCells() {
    if (mode == WidgetMode.week) {
      return List.generate(7, (i) => _startOfWeek.add(Duration(days: i)));
    }
    // month
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

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final List<Event> events;
  final int maxChips;

  const _DayCell({
    required this.date,
    required this.isToday,
    required this.events,
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
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: isToday
                  ? const BoxDecoration(
                      color: WidgetCalendarView._accent, shape: BoxShape.circle)
                  : null,
              child: Text('${date.day}',
                  style: TextStyle(
                      color: isToday ? Colors.white : const Color(0xFFEDEDED),
                      fontSize: 11,
                      fontWeight:
                          isToday ? FontWeight.w700 : FontWeight.w500)),
            ),
          ),
          const SizedBox(height: 1),
          ...chips.map((e) => _EventChip(event: e)),
          if (extra > 0)
            Padding(
              padding: const EdgeInsets.only(left: 2, top: 1),
              child: Text('+$extra',
                  style: const TextStyle(fontSize: 7, color: Color(0x99FFFFFF))),
            ),
        ],
      ),
    );
  }
}

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
      child: Text(event.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 8,
              height: 1.15,
              fontWeight: FontWeight.w500)),
    );
  }
}
