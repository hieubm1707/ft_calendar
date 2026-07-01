import 'package:flutter/material.dart';

import '../../../../core/domain/index.dart';
import '../../../../core/utils/index.dart';
import 'event_chip.dart';

/// Một ô ngày: số ngày (dương) + số âm lịch nhỏ + tối đa vài nhãn sự kiện.
class DayCell extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final List<Event> events;
  final VoidCallback? onTap;

  const DayCell({
    super.key,
    required this.day,
    required this.isToday,
    required this.events,
    this.onTap,
  });

  static const _maxChips = 3;

  @override
  Widget build(BuildContext context) {
    final lunar = solarToLunar(day);
    // Ngày mùng 1 âm lịch hiển thị "1/<tháng>" để dễ nhận biết.
    final lunarLabel = lunar.day == 1 ? '${lunar.day}/${lunar.month}' : '${lunar.day}';
    final accent = Theme.of(context).colorScheme.primary;

    final chips = events.take(_maxChips).toList();
    final extra = events.length - chips.length;

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 74),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isToday)
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Text(
                    '${day.day}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                const SizedBox(width: 3),
                Text(
                  lunarLabel,
                  style: const TextStyle(fontSize: 9, color: Color(0xFFB0B0B5)),
                ),
              ],
            ),
            const SizedBox(height: 2),
            ...chips.map((e) => EventChip(event: e)),
            if (extra > 0)
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  '+$extra',
                  style: const TextStyle(fontSize: 8, color: Color(0xFF8E8E93)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
