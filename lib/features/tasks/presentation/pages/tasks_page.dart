import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text('Công việc',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1C1C1E))),
            ),
            Expanded(
              child: BlocConsumer<TaskCubit, TaskState>(
                listenWhen: (p, c) => c.status == TaskStatus.failure,
                listener: (context, state) => ScaffoldMessenger.of(context)
                    .showSnackBar(
                        SnackBar(content: Text(state.errorMessage ?? 'Lỗi'))),
                builder: (context, state) {
                  final days = state.sortedDays;
                  if (state.status == TaskStatus.success && days.isEmpty) {
                    return const Center(
                      child: Text('Chưa có công việc.\nNhấn + để thêm.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF8E8E93))),
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
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF00B3A6))),
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
          backgroundColor: Colors.black,
          shape: const CircleBorder(),
          onPressed: () => _add(context),
          child: const Icon(Icons.add, color: Colors.white),
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
    return Dismissible(
      key: ValueKey('${task.scheduleId}-${task.date.toIso8601String()}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
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
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: ListTile(
          leading: GestureDetector(
            onTap: onToggle,
            child: Icon(
              task.done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.done ? color : const Color(0xFFBDBDBD),
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,
              color: task.done ? const Color(0xFF9E9E9E) : null,
            ),
          ),
          trailing: task.isRecurring
              ? const Icon(Icons.repeat, size: 18, color: Color(0xFF8E8E93))
              : null,
          onTap: onToggle,
        ),
      ),
    );
  }
}
