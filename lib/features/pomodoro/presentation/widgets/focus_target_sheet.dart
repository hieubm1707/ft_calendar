import 'package:flutter/material.dart';

import '../../../../core/theme/index.dart';
import '../../../tasks/domain/index.dart';

/// Việc được chọn để tập trung.
class FocusTarget {
  final String label;
  final int? taskScheduleId;

  const FocusTarget({required this.label, this.taskScheduleId});
}

/// Chọn việc cần tập trung từ task hôm nay (tag chọn ngay trên trang Focus).
/// Trả về [FocusTarget], hoặc `FocusTarget(label: '')` nếu người dùng xoá chọn.
Future<FocusTarget?> showFocusTargetSheet(
  BuildContext context, {
  required List<TaskInstance> todayTasks,
}) {
  return showModalBottomSheet<FocusTarget>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _FocusTargetSheet(todayTasks: todayTasks),
  );
}

class _FocusTargetSheet extends StatelessWidget {
  final List<TaskInstance> todayTasks;

  const _FocusTargetSheet({required this.todayTasks});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final pending = todayTasks.where((t) => !t.done).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Công việc hôm nay',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (pending.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('Hôm nay chưa có công việc nào cần làm.',
                  style: TextStyle(color: colors.textMuted)),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pending.length,
                itemBuilder: (context, i) {
                  final t = pending[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.flag, color: Color(t.color), size: 20),
                    title: Text(t.title),
                    onTap: () => Navigator.pop(
                      context,
                      FocusTarget(label: t.title, taskScheduleId: t.scheduleId),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, const FocusTarget(label: '')),
            child: const Text('Xoá lựa chọn'),
          ),
        ],
      ),
    );
  }
}
