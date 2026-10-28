import 'package:flutter/material.dart';

import '../../../../core/theme/index.dart';

/// Hàng nhãn thứ (Mon..Sun). Thứ trùng "hôm nay" được tô màu nhấn.
class WeekdayHeader extends StatelessWidget {
  final int todayWeekday; // 1 = Mon .. 7 = Sun

  const WeekdayHeader({super.key, required this.todayWeekday});

  static const _labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final colors = context.colors;
    return Row(
      children: List.generate(7, (i) {
        final isToday = (i + 1) == todayWeekday;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              _labels[i],
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isToday ? accent : colors.textMuted,
              ),
            ),
          ),
        );
      }),
    );
  }
}
