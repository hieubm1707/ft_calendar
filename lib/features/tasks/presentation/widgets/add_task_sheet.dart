import 'package:flutter/material.dart';

import '../../domain/index.dart';

const kTaskColors = <int>[
  0xFF00B3A6, 0xFFEF5350, 0xFFAB47BC, 0xFF5C6BC0,
  0xFF42A5F5, 0xFF66BB6A, 0xFFFFA726, 0xFFEC407A,
];
const _weekdayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

enum _Mode { one, many, weekly }

/// Mở bottom sheet tạo task. Trả về TaskSchedule hoặc null nếu huỷ.
Future<TaskSchedule?> showAddTaskSheet(BuildContext context) {
  return showModalBottomSheet<TaskSchedule>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _AddTaskSheet(),
  );
}

class _AddTaskSheet extends StatefulWidget {
  const _AddTaskSheet();

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _titleController = TextEditingController();
  _Mode _mode = _Mode.one;
  DateTime _oneDate = _today();
  final List<DateTime> _manyDates = [];
  final Set<int> _weekdays = {};
  DateTime _weeklyStart = _today();
  int _color = kTaskColors.first;
  final _descController = TextEditingController();
  TimeOfDay? _time; // giờ tuỳ chọn

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<DateTime?> _pickDate(DateTime initial) => showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(initial.year - 1),
        lastDate: DateTime(initial.year + 3),
      );

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final desc = _descController.text.trim();
    final description = desc.isEmpty ? null : desc;
    final timeMinutes =
        _time == null ? null : _time!.hour * 60 + _time!.minute;

    TaskSchedule? schedule;
    switch (_mode) {
      case _Mode.one:
        schedule = TaskSchedule(
          title: title,
          type: TaskRecurrence.dates,
          dates: [_oneDate],
          startDate: _oneDate,
          color: _color,
          description: description,
          timeMinutes: timeMinutes,
        );
      case _Mode.many:
        if (_manyDates.isEmpty) return;
        final sorted = [..._manyDates]..sort();
        schedule = TaskSchedule(
          title: title,
          type: TaskRecurrence.dates,
          dates: sorted,
          startDate: sorted.first,
          color: _color,
          description: description,
          timeMinutes: timeMinutes,
        );
      case _Mode.weekly:
        if (_weekdays.isEmpty) return;
        schedule = TaskSchedule(
          title: title,
          type: TaskRecurrence.weekly,
          weekdays: _weekdays,
          startDate: _weeklyStart,
          color: _color,
          description: description,
          timeMinutes: timeMinutes,
        );
    }
    Navigator.of(context).pop(schedule);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Công việc mới',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Tên công việc',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 3,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: 'Mô tả (tuỳ chọn)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<_Mode>(
              segments: const [
                ButtonSegment(value: _Mode.one, label: Text('Một ngày')),
                ButtonSegment(value: _Mode.many, label: Text('Nhiều ngày')),
                ButtonSegment(value: _Mode.weekly, label: Text('Hàng tuần')),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
              showSelectedIcon: false,
            ),
            const SizedBox(height: 16),
            _modeSection(),
            const SizedBox(height: 12),
            // Giờ tuỳ chọn
            Row(
              children: [
                const Icon(Icons.schedule, size: 20, color: Color(0xFF8E8E93)),
                const SizedBox(width: 8),
                if (_time == null)
                  ActionChip(
                    label: const Text('Thêm giờ'),
                    onPressed: () async {
                      final t = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 9, minute: 0));
                      if (t != null) setState(() => _time = t);
                    },
                  )
                else ...[
                  InkWell(
                    onTap: () async {
                      final t = await showTimePicker(
                          context: context, initialTime: _time!);
                      if (t != null) setState(() => _time = t);
                    },
                    child: Text(_fmtTime(_time!),
                        style: const TextStyle(fontSize: 15)),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => setState(() => _time = null),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.flag, size: 16, color: Color(0xFF8E8E93)),
                SizedBox(width: 6),
                Text('Cờ ưu tiên', style: TextStyle(color: Color(0xFF8E8E93))),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: kTaskColors.map((c) {
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
              child: FilledButton(onPressed: _save, child: const Text('Lưu')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeSection() {
    switch (_mode) {
      case _Mode.one:
        return InkWell(
          onTap: () async {
            final d = await _pickDate(_oneDate);
            if (d != null) setState(() => _oneDate = DateTime(d.year, d.month, d.day));
          },
          child: Row(
            children: [
              const Icon(Icons.event, size: 20, color: Color(0xFF8E8E93)),
              const SizedBox(width: 8),
              Text(_fmt(_oneDate), style: const TextStyle(fontSize: 15)),
            ],
          ),
        );
      case _Mode.many:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final d in _manyDates)
                  Chip(
                    label: Text(_fmt(d)),
                    onDeleted: () => setState(() => _manyDates.remove(d)),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm ngày'),
                  onPressed: () async {
                    final d = await _pickDate(_today());
                    if (d == null) return;
                    final day = DateTime(d.year, d.month, d.day);
                    if (!_manyDates.contains(day)) {
                      setState(() => _manyDates.add(day));
                    }
                  },
                ),
              ],
            ),
          ],
        );
      case _Mode.weekly:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: List.generate(7, (i) {
                final wd = i + 1; // 1..7
                final on = _weekdays.contains(wd);
                return FilterChip(
                  label: Text(_weekdayLabels[i]),
                  selected: on,
                  onSelected: (_) => setState(() =>
                      on ? _weekdays.remove(wd) : _weekdays.add(wd)),
                );
              }),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                final d = await _pickDate(_weeklyStart);
                if (d != null) {
                  setState(() => _weeklyStart = DateTime(d.year, d.month, d.day));
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.event, size: 20, color: Color(0xFF8E8E93)),
                  const SizedBox(width: 8),
                  Text('Bắt đầu ${_fmt(_weeklyStart)}',
                      style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        );
    }
  }
}
