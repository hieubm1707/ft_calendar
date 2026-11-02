import 'package:flutter/material.dart';

import '../../../../core/theme/index.dart';

import 'event_colors.dart';

/// Bottom sheet chọn màu để lọc. Trả về tập màu đang bật (rỗng = tất cả).
Future<Set<int>?> showColorFilterSheet(
  BuildContext context, {
  required Set<int> selected,
}) {
  return showModalBottomSheet<Set<int>>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ColorFilterSheet(selected: selected),
  );
}

class _ColorFilterSheet extends StatefulWidget {
  final Set<int> selected;

  const _ColorFilterSheet({required this.selected});

  @override
  State<_ColorFilterSheet> createState() => _ColorFilterSheetState();
}

class _ColorFilterSheetState extends State<_ColorFilterSheet> {
  late final Set<int> _selected = {...widget.selected};

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Lọc theo màu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const Spacer(),
              TextButton(
                onPressed: () => setState(_selected.clear),
                child: const Text('Tất cả'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: kEventColors.map((c) {
              final on = _selected.isEmpty || _selected.contains(c);
              return GestureDetector(
                onTap: () => setState(() {
                  if (_selected.contains(c)) {
                    _selected.remove(c);
                  } else {
                    _selected.add(c);
                  }
                }),
                child: Opacity(
                  opacity: on ? 1 : 0.3,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                      border: _selected.contains(c)
                          ? Border.all(color: colors.textPrimary, width: 2)
                          : null,
                    ),
                    child: _selected.contains(c)
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(_selected),
              child: const Text('Áp dụng'),
            ),
          ),
        ],
      ),
    );
  }
}
