import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/index.dart';
import '../cubit/pomodoro_cubit.dart';
import 'focus_tag_editor_sheet.dart';

/// Danh sách tag để chọn việc cần tập trung (thay cho ô nhập tay).
/// Chạm = chọn tag (và lấy luôn số phút của tag); chạm giữ hoặc bấm bút chì
/// trên tag đang chọn = sửa; chip "＋" = thêm tag mới.
class FocusTagPicker extends StatelessWidget {
  final PomodoroState state;

  const FocusTagPicker({super.key, required this.state});

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

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PomodoroCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Tập trung vào',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8E8E93))),
            ),
            if (state.label != null && state.label!.isNotEmpty)
              TextButton(
                onPressed: () => cubit.setTarget(label: null),
                child: const Text('Bỏ chọn'),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in state.tags)
              _TagChip(
                tag: tag,
                selected: tag.id != null && tag.id == state.focusTagId,
                onTap: () => cubit.selectTag(tag),
                onEdit: () => _openEditor(context, tag: tag),
              ),
            _AddTagChip(onTap: () => _openEditor(context)),
          ],
        ),
        // Nhãn từ task hôm nay (không phải tag) vẫn hiển thị để biết đang làm gì.
        if (state.focusTagId == null &&
            state.label != null &&
            state.label!.isNotEmpty) ...[
          const SizedBox(height: 10),
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
      ],
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
            padding: EdgeInsets.fromLTRB(12, 8, selected ? 4 : 12, 8),
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
                if (selected)
                  IconButton(
                    tooltip: 'Sửa tag',
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 30, minHeight: 30),
                    iconSize: 15,
                    onPressed: onEdit,
                    icon: Icon(Icons.edit_outlined, color: color),
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
            border: Border.all(
              color: const Color(0xFFBDBDBD),
              style: BorderStyle.solid,
            ),
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
