import 'package:flutter/material.dart';

import '../../../../core/domain/index.dart';
import '../../../../core/theme/index.dart';
import 'day_cell.dart';
import 'weekday_header.dart';

/// Một tháng: tên tháng + hàng thứ + lưới tuần (Mon→Sun).
class MonthView extends StatelessWidget {
  final DateTime month; // ngày 1 của tháng
  final DateTime today;
  final List<Event> Function(DateTime day) eventsOf;
  final void Function(DateTime day)? onTapDay;

  const MonthView({
    super.key,
    required this.month,
    required this.today,
    required this.eventsOf,
    this.onTapDay,
  });

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  bool _isToday(DateTime d) =>
      d.year == today.year && d.month == today.month && d.day == today.day;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leading = DateTime(month.year, month.month, 1).weekday - 1; // Mon=0
    final totalCells = leading + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 2),
          child: Text(
            _monthNames[month.month - 1],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ),
        WeekdayHeader(todayWeekday: today.weekday),
        for (var r = 0; r < rows; r++)
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.divider)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(7, (c) {
                final dayNum = r * 7 + c - leading + 1;
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const Expanded(child: SizedBox());
                }
                final date = DateTime(month.year, month.month, dayNum);
                return Expanded(
                  child: DayCell(
                    day: date,
                    isToday: _isToday(date),
                    events: eventsOf(date),
                    onTap: onTapDay == null ? null : () => onTapDay!(date),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
