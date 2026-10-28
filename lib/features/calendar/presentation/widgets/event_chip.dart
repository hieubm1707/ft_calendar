import 'package:flutter/material.dart';

import '../../../../core/domain/index.dart';
import 'event_colors.dart';

/// Nhãn sự kiện nhỏ trong ô ngày — nền nhạt + viền trái theo màu sự kiện.
class EventChip extends StatelessWidget {
  final Event event;

  const EventChip({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final base = Color(event.color);
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.fromLTRB(3, 1, 2, 1),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(3),
        border: Border(left: BorderSide(color: base, width: 2)),
      ),
      child: Text(
        event.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 8,
          height: 1.1,
          fontWeight: FontWeight.w500,
          color: readableOn(base, Theme.of(context).brightness),
        ),
      ),
    );
  }
}
