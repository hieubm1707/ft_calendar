import 'package:flutter/material.dart';

import '../../../../core/domain/index.dart';
import 'event_colors.dart';

/// Mở bottom sheet thêm/sửa sự kiện.
/// - Thêm: truyền [initialDate], trả về Event mới (chưa có id).
/// - Sửa: truyền [event], trả về Event đã cập nhật (giữ nguyên id).
/// Trả về null nếu huỷ.
Future<Event?> showAddEventSheet(
  BuildContext context, {
  DateTime? initialDate,
  Event? event,
}) {
  return showModalBottomSheet<Event>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _AddEventSheet(
      initialDate: initialDate ?? event?.startTime ?? DateTime.now(),
      event: event,
    ),
  );
}

class _AddEventSheet extends StatefulWidget {
  final DateTime initialDate;
  final Event? event;

  const _AddEventSheet({required this.initialDate, this.event});

  @override
  State<_AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends State<_AddEventSheet> {
  late final _titleController =
      TextEditingController(text: widget.event?.title ?? '');
  late DateTime _date = widget.initialDate;
  late int _color = widget.event?.color ?? kEventColors.first;

  bool get _isEditing => widget.event != null;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(_date.year - 2),
      lastDate: DateTime(_date.year + 5),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    final existing = widget.event;
    if (existing != null) {
      // Sửa: giữ id, giữ giờ bắt đầu cũ, đổi sang ngày mới đã chọn.
      final start = DateTime(_date.year, _date.month, _date.day,
          existing.startTime.hour, existing.startTime.minute);
      final duration = existing.endTime.difference(existing.startTime);
      Navigator.of(context).pop(existing.copyWith(
        title: title,
        startTime: start,
        endTime: start.add(duration),
        color: _color,
      ));
    } else {
      final start = DateTime(_date.year, _date.month, _date.day, 9);
      Navigator.of(context).pop(Event(
        title: title,
        startTime: start,
        endTime: start.add(const Duration(hours: 1)),
        color: _color,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_isEditing ? 'Sửa sự kiện' : 'Sự kiện mới',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Tiêu đề',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickDate,
            child: Row(
              children: [
                const Icon(Icons.event, size: 20, color: Color(0xFF8E8E93)),
                const SizedBox(width: 8),
                Text(
                  '${_date.day}/${_date.month}/${_date.year}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Màu', style: TextStyle(color: Color(0xFF8E8E93))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: kEventColors.map((c) {
              final selected = c == _color;
              return GestureDetector(
                onTap: () => setState(() => _color = c),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(c),
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(color: Colors.black87, width: 2)
                        : null,
                  ),
                  child: selected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _save,
              child: const Text('Lưu'),
            ),
          ),
        ],
      ),
    );
  }
}
