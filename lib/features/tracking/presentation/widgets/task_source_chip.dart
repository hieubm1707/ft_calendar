import 'package:flutter/material.dart';

import '../../../../core/theme/index.dart';

/// Nhãn nhỏ cho mục tiêu đến từ task hằng tuần bên Tasks.
class TaskSourceChip extends StatelessWidget {
  const TaskSourceChip({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Từ Tasks',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}
