import 'package:flutter/material.dart';

import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import 'tracking_format.dart';

/// Kết quả sheet: luật đã sửa/tạo, hoặc [delete] = true khi bấm Xoá.
typedef ReminderRuleSheetResult = ({TrackingReminderRule? rule, bool delete});

/// Bottom sheet tạo/sửa 1 luật nhắc: giờ + điều kiện (< hoặc =) + %.
Future<ReminderRuleSheetResult?> showReminderRuleSheet(
  BuildContext context, {
  TrackingReminderRule? initial,
}) {
  return showModalBottomSheet<ReminderRuleSheetResult>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _ReminderRuleSheet(initial: initial),
  );
}

class _ReminderRuleSheet extends StatefulWidget {
  final TrackingReminderRule? initial;

  const _ReminderRuleSheet({this.initial});

  @override
  State<_ReminderRuleSheet> createState() => _ReminderRuleSheetState();
}

class _ReminderRuleSheetState extends State<_ReminderRuleSheet> {
  late int _minutes;
  late ReminderComparison _comparison;
  late int _percent;
  String? _error;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final r = widget.initial;
    _minutes = r?.minutes ?? 19 * 60;
    _comparison = r?.comparison ?? ReminderComparison.lessThan;
    _percent = r?.percent ?? 50;
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _minutes ~/ 60, minute: _minutes % 60),
    );
    if (t != null) setState(() => _minutes = t.hour * 60 + t.minute);
  }

  void _save() {
    if (_comparison == ReminderComparison.lessThan && _percent == 0) {
      setState(() => _error = 'Hoàn thành < 0% không bao giờ xảy ra');
      return;
    }
    Navigator.of(context).pop((
      rule: TrackingReminderRule(
        minutes: _minutes,
        comparison: _comparison,
        percent: _percent,
        enabled: widget.initial?.enabled ?? true,
      ),
      delete: false,
    ));
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
              _isEdit ? 'Sửa nhắc nhở' : 'Nhắc nhở mới',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Center(
              child: InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  child: Text(
                    fmtMinutes(_minutes),
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: colors.accent,
                      fontFamily: AppFonts.tabular,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                'Chạm để đổi giờ',
                style: TextStyle(fontSize: 12, color: colors.textMuted),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Nhắc nếu tỉ lệ mục tiêu đã hoàn thành trong ngày',
              style: TextStyle(color: colors.textSecondary),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SegmentedButton<ReminderComparison>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: ReminderComparison.lessThan,
                      label: Text('<  nhỏ hơn'),
                    ),
                    ButtonSegment(
                      value: ReminderComparison.equals,
                      label: Text('=  bằng'),
                    ),
                  ],
                  selected: {_comparison},
                  onSelectionChanged: (s) => setState(() {
                    _comparison = s.first;
                    _error = null;
                  }),
                ),
                const Spacer(),
                Text(
                  '$_percent%',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            Slider(
              value: _percent.toDouble(),
              max: 100,
              divisions: 20,
              label: '$_percent%',
              onChanged: (v) => setState(() {
                _percent = v.round();
                _error = null;
              }),
            ),
            Text(
              'Lúc ${fmtMinutes(_minutes)}, nếu hoàn thành '
              '${comparisonSymbol(_comparison)} $_percent% thì nhắc.',
              style: TextStyle(fontSize: 13, color: colors.textMuted),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: colors.danger)),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                if (_isEdit) ...[
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: colors.danger),
                    onPressed: () =>
                        Navigator.of(context).pop((rule: null, delete: true)),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Xoá'),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('Lưu'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
