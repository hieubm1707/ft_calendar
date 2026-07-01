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
  late TimeOfDay _startTime = widget.event != null
      ? TimeOfDay.fromDateTime(widget.event!.startTime)
      : const TimeOfDay(hour: 9, minute: 0);
  late TimeOfDay _endTime = widget.event != null
      ? TimeOfDay.fromDateTime(widget.event!.endTime)
      : const TimeOfDay(hour: 10, minute: 0);

  bool get _isEditing => widget.event != null;

  static int _mins(TimeOfDay t) => t.hour * 60 + t.minute;

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

  Future<void> _pickStartTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: _startTime);
    if (picked == null) return;
    setState(() {
      _startTime = picked;
      // Giữ giờ kết thúc luôn sau giờ bắt đầu.
      if (_mins(_endTime) <= _mins(_startTime)) {
        _endTime = TimeOfDay(
          hour: (picked.hour + 1) % 24,
          minute: picked.minute,
        );
      }
    });
  }

  Future<void> _pickEndTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: _endTime);
    if (picked != null) setState(() => _endTime = picked);
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    final start = DateTime(_date.year, _date.month, _date.day, _startTime.hour,
        _startTime.minute);
    var end = DateTime(
        _date.year, _date.month, _date.day, _endTime.hour, _endTime.minute);
    // Chốt: giờ kết thúc phải sau giờ bắt đầu.
    if (!end.isAfter(start)) end = start.add(const Duration(hours: 1));

    final existing = widget.event;
    Navigator.of(context).pop(
      existing != null
          ? existing.copyWith(
              title: title, startTime: start, endTime: end, color: _color)
          : Event(
              title: title, startTime: start, endTime: end, color: _color),
    );
  }

  static String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

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
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.schedule, size: 20, color: Color(0xFF8E8E93)),
              const SizedBox(width: 8),
              _TimeChip(label: 'Bắt đầu', time: _fmt(_startTime), onTap: _pickStartTime),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('–', style: TextStyle(color: Color(0xFF8E8E93))),
              ),
              _TimeChip(label: 'Kết thúc', time: _fmt(_endTime), onTap: _pickEndTime),
            ],
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

/// Ô chọn giờ nhỏ: nhãn (Bắt đầu/Kết thúc) + giờ, bấm để mở time picker.
class _TimeChip extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;

  const _TimeChip({required this.label, required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE9E4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Color(0xFF8E8E93))),
            Text(time,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
