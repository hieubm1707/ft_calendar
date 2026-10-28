import 'package:flutter/material.dart';

import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import 'tracking_format.dart';

DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

/// Bottom sheet tạo mới / sửa mục tiêu. Trả về mục tiêu đã nhập, null nếu huỷ.
Future<TrackingGoal?> showTrackingGoalSheet(
  BuildContext context, {
  TrackingGoal? initial,
}) {
  return showModalBottomSheet<TrackingGoal>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _TrackingGoalSheet(initial: initial),
  );
}

class _TrackingGoalSheet extends StatefulWidget {
  final TrackingGoal? initial;

  const _TrackingGoalSheet({this.initial});

  @override
  State<_TrackingGoalSheet> createState() => _TrackingGoalSheetState();
}

class _TrackingGoalSheetState extends State<_TrackingGoalSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late int _color;
  late TrackingFrequency _frequency;
  late Set<int> _weekdays;
  late List<int> _reminders;
  late DateTime _startDate;
  DateTime? _endDate;
  String? _error;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final g = widget.initial;
    _nameController = TextEditingController(text: g?.name);
    _descController = TextEditingController(text: g?.description);
    _color = g?.color ?? TrackingGoal.defaultColor;
    _frequency = g?.frequency ?? TrackingFrequency.daily;
    _weekdays = {...?g?.weekdays};
    _reminders = [...?g?.reminders];
    _startDate = g?.startDate ?? _today();
    _endDate = g?.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDate(DateTime initial, {DateTime? first}) async {
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first ?? DateTime(2020),
      lastDate: DateTime(2100),
    );
    return d == null ? null : DateTime(d.year, d.month, d.day);
  }

  Future<void> _addReminder() async {
    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (t == null) return;
    final m = t.hour * 60 + t.minute;
    if (_reminders.contains(m)) return;
    setState(() => _reminders = [..._reminders, m]..sort());
  }

  void _save() {
    final name = _nameController.text.trim();
    final weekly = _frequency == TrackingFrequency.weekdays;
    final error = name.isEmpty
        ? 'Nhập tên mục tiêu'
        : weekly && _weekdays.isEmpty
        ? 'Chọn ít nhất 1 thứ trong tuần'
        : _endDate != null && _endDate!.isBefore(_startDate)
        ? 'Ngày kết thúc phải sau ngày bắt đầu'
        : null;
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    final desc = _descController.text.trim();
    Navigator.of(context).pop(
      TrackingGoal(
        id: widget.initial?.id,
        name: name,
        description: desc.isEmpty ? null : desc,
        color: _color,
        frequency: _frequency,
        weekdays: weekly ? _weekdays : const {},
        startDate: _startDate,
        endDate: _endDate,
        reminders: _reminders,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEdit ? 'Sửa mục tiêu' : 'Mục tiêu mới',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              autofocus: !_isEdit,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Tên mục tiêu',
                border: OutlineInputBorder(),
                isDense: true,
              ),
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
            const SizedBox(height: 18),
            _Label(icon: Icons.palette_outlined, text: 'Màu'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                for (final c in kTrackingColors)
                  GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: c == _color
                            ? Border.all(color: colors.textPrimary, width: 2)
                            : null,
                      ),
                      child: c == _color
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            _Label(icon: Icons.repeat, text: 'Tần suất'),
            const SizedBox(height: 8),
            SegmentedButton<TrackingFrequency>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: TrackingFrequency.daily,
                  label: Text('Hằng ngày'),
                ),
                ButtonSegment(
                  value: TrackingFrequency.weekdays,
                  label: Text('Chọn thứ'),
                ),
              ],
              selected: {_frequency},
              onSelectionChanged: (s) => setState(() => _frequency = s.first),
            ),
            if (_frequency == TrackingFrequency.weekdays) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (var w = 1; w <= 7; w++)
                    FilterChip(
                      label: Text(kWeekdayShort[w - 1]),
                      selected: _weekdays.contains(w),
                      onSelected: (on) => setState(
                        () => on ? _weekdays.add(w) : _weekdays.remove(w),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            _Label(icon: Icons.notifications_none, text: 'Nhắc nhở'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in _reminders)
                  Chip(
                    label: Text(fmtMinutes(m)),
                    onDeleted: () =>
                        setState(() => _reminders = [..._reminders]..remove(m)),
                  ),
                if (_reminders.length < TrackingGoal.maxReminders)
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 18),
                    label: const Text('Thêm giờ nhắc'),
                    onPressed: _addReminder,
                  ),
              ],
            ),
            const SizedBox(height: 18),
            _Label(icon: Icons.event, text: 'Thời gian'),
            const SizedBox(height: 4),
            _DateRow(
              label: 'Bắt đầu',
              value: fmtDate(_startDate),
              onTap: () async {
                final d = await _pickDate(_startDate);
                if (d != null) setState(() => _startDate = d);
              },
            ),
            _DateRow(
              label: 'Kết thúc',
              value: _endDate == null ? 'Không giới hạn' : fmtDate(_endDate!),
              muted: _endDate == null,
              onTap: () async {
                final d = await _pickDate(
                  _endDate ?? _startDate,
                  first: _startDate,
                );
                if (d != null) setState(() => _endDate = d);
              },
              onClear: _endDate == null
                  ? null
                  : () => setState(() => _endDate = null),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: colors.danger)),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _save, child: const Text('Lưu')),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Label({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.textMuted),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: colors.textMuted)),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final String value;
  final bool muted;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.muted = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Text(label, style: TextStyle(color: colors.textSecondary)),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: muted ? colors.textMuted : colors.textPrimary,
                ),
              ),
            ),
            if (onClear != null)
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close, size: 18),
                onPressed: onClear,
              )
            else
              Icon(Icons.chevron_right, color: colors.textMuted),
          ],
        ),
      ),
    );
  }
}
