import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/index.dart';
import '../cubit/pomodoro_cubit.dart';
import 'focus_tag_editor_sheet.dart';
import 'focus_target_sheet.dart';

/// Danh sách tag để chọn việc cần tập trung. Mở bằng cách bấm vào nhãn giữa
/// đồng hồ — trang Focus không hiển thị sẵn danh sách này cho đỡ rối.
///
/// Nhận [cubit] tường minh vì sheet nằm trên route khác, không đọc được
/// provider của trang.
Future<void> showFocusTagSheet(
  BuildContext context, {
  required PomodoroCubit cubit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: const _FocusTagSheet(),
    ),
  );
}

class _FocusTagSheet extends StatelessWidget {
  const _FocusTagSheet();

  Future<void> _openEditor(BuildContext context, {FocusTag? tag}) async {
    final cubit = context.read<PomodoroCubit>();
    final result = await showFocusTagEditor(context, tag: tag);
    if (result == null) return;
    if (result.deletedId != null) {
      await cubit.deleteTag(result.deletedId!);
      return;
    }
    await cubit.saveTag(result.saved!);
  }

  /// Mục tiêu lấy từ task hôm nay (không gắn tag).
  Future<void> _pickTask(BuildContext context, PomodoroState state) async {
    final cubit = context.read<PomodoroCubit>();
    final navigator = Navigator.of(context);
    final target =
        await showFocusTargetSheet(context, todayTasks: state.todayTasks);
    if (target == null) return;
    cubit.setTarget(
        label: target.label, taskScheduleId: target.taskScheduleId);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PomodoroCubit>();
    return BlocBuilder<PomodoroCubit, PomodoroState>(
      builder: (context, state) {
        final hasTarget = state.label != null && state.label!.isNotEmpty;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Tập trung vào',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  if (hasTarget)
                    TextButton(
                      onPressed: () {
                        cubit.setTarget(label: null);
                        Navigator.pop(context);
                      },
                      child: const Text('Bỏ chọn'),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tag in state.tags)
                        _TagChip(
                          tag: tag,
                          selected:
                              tag.id != null && tag.id == state.focusTagId,
                          onTap: () {
                            cubit.selectTag(tag);
                            Navigator.pop(context);
                          },
                          onEdit: () => _openEditor(context, tag: tag),
                        ),
                      _AddTagChip(onTap: () => _openEditor(context)),
                    ],
                  ),
                ),
              ),
              if (state.todayTasks.any((t) => !t.done))
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => _pickTask(context, state),
                    icon: const Icon(Icons.checklist_rtl, size: 18),
                    label: const Text('Chọn từ công việc hôm nay'),
                  ),
                ),
              // Nhãn lấy từ task hôm nay (không phải tag) — cho biết đang làm gì.
              if (state.focusTagId == null && hasTarget) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 16, color: Color(0xFF8E8E93)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(state.label!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 6),
              const Text('Chạm giữ hoặc bấm bút chì trên tag để sửa.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93))),
            ],
          ),
        );
      },
    );
  }
}

class _TagChip extends StatelessWidget {
  final FocusTag tag;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _TagChip({
    required this.tag,
    required this.selected,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(tag.color);
    return GestureDetector(
      onLongPress: onEdit,
      child: Material(
        color: selected ? color.withValues(alpha: 0.16) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? color : const Color(0xFFE5E5EA),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tag.emoji != null) ...[
                  Text(tag.emoji!, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                ],
                Text(
                  tag.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? color : const Color(0xFF1C1C1E),
                  ),
                ),
                const SizedBox(width: 6),
                Text('${tag.minutes}p',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? color.withValues(alpha: 0.8)
                            : const Color(0xFF8E8E93))),
                IconButton(
                  tooltip: 'Sửa tag',
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 30, minHeight: 30),
                  iconSize: 15,
                  onPressed: onEdit,
                  icon: Icon(Icons.edit_outlined,
                      color: selected ? color : const Color(0xFFBDBDBD)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddTagChip extends StatelessWidget {
  final VoidCallback onTap;

  const _AddTagChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFBDBDBD)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 16, color: Color(0xFF8E8E93)),
              SizedBox(width: 4),
              Text('Tag mới',
                  style: TextStyle(fontSize: 14, color: Color(0xFF8E8E93))),
            ],
          ),
        ),
      ),
    );
  }
}
