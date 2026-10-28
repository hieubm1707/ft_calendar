import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import '../cubit/task_cubit.dart';
import '../widgets/add_task_sheet.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TaskCubit>()..load(),
      child: const _TasksView(),
    );
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView();

  static const _weekdaysFull = [
    'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật',
  ];

  String _dayLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = d.difference(today).inDays;
    if (diff == 0) return 'Hôm nay';
    if (diff == 1) return 'Ngày mai';
    return '${_weekdaysFull[d.weekday - 1]}, ${d.day}/${d.month}';
  }

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<TaskCubit>();
    final schedule = await showAddTaskSheet(context);
    if (schedule != null) await cubit.addSchedule(schedule);
  }

  Future<void> _confirmRemove(BuildContext context, TaskInstance t) async {
    final cubit = context.read<TaskCubit>();
    final recurring = t.isRecurring;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(recurring ? 'Huỷ lịch lặp?' : 'Xoá công việc?'),
        content: Text(recurring
            ? '"${t.title}" sẽ không được tạo tự động nữa.'
            : '"${t.title}" sẽ bị xoá.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(recurring ? 'Huỷ lặp' : 'Xoá')),
        ],
      ),
    );
    if (ok == true) {
      // weekly → huỷ lặp (soft); dates → xoá hẳn (hard).
      await cubit.removeSchedule(t.scheduleId, hard: !recurring);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Công việc',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocConsumer<TaskCubit, TaskState>(
                listenWhen: (p, c) => c.status == TaskStatus.failure,
                listener: (context, state) => ScaffoldMessenger.of(context)
                    .showSnackBar(
                        SnackBar(content: Text(state.errorMessage ?? 'Lỗi'))),
                builder: (context, state) {
                  final days = state.sortedDays;
                  if (state.status == TaskStatus.success && days.isEmpty) {
                    return Center(
                      child: Text('Chưa có công việc.\nNhấn + để thêm.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.textMuted)),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    itemCount: days.length,
                    itemBuilder: (context, i) {
                      final day = days[i];
                      final items = state.instancesByDay[day]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 14, 8, 4),
                            child: Text(_dayLabel(day),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: colors.accent)),
                          ),
                          ...items.map((t) => _TaskRow(
                                task: t,
                                onToggle: () =>
                                    context.read<TaskCubit>().toggleDone(t),
                                onRemove: () => _confirmRemove(context, t),
                              )),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => _add(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final TaskInstance task;
  final VoidCallback onToggle;
  final Future<void> Function() onRemove;

  const _TaskRow({
    required this.task,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(task.color);
    final colors = context.colors;
    return Dismissible(
      key: ValueKey('${task.scheduleId}-${task.date.toIso8601String()}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: colors.danger,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        await onRemove();
        return false; // cubit reload sẽ cập nhật list
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: ListTile(
          leading: GestureDetector(
            onTap: onToggle,
            child: Icon(
              task.done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.done ? color : colors.textDisabled,
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,
              color: task.done ? colors.textMuted : null,
            ),
          ),
          subtitle: _subtitle(colors),
          isThreeLine: _hasDescription && task.timeMinutes != null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cờ ưu tiên (màu người dùng chọn)
              Icon(Icons.flag, size: 18, color: color),
              if (task.isRecurring) ...[
                const SizedBox(width: 6),
                Icon(Icons.repeat, size: 18, color: colors.textMuted),
              ],
            ],
          ),
          onTap: onToggle,
        ),
      ),
    );
  }

  bool get _hasDescription =>
      task.description != null && task.description!.trim().isNotEmpty;

  String? get _timeLabel {
    final m = task.timeMinutes;
    if (m == null) return null;
    final h = (m ~/ 60).toString().padLeft(2, '0');
    final mm = (m % 60).toString().padLeft(2, '0');
    return '$h:$mm';
  }

  Widget? _subtitle(AppColors colors) {
    final time = _timeLabel;
    if (time == null && !_hasDescription) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (time != null)
          Text(time,
              style: TextStyle(
                  fontSize: 12,
                  color: colors.accent,
                  fontWeight: FontWeight.w600)),
        if (_hasDescription)
          Text(task.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: colors.textMuted)),
      ],
    );
  }
}
