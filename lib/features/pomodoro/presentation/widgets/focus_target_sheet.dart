import 'package:flutter/material.dart';

import '../../../tasks/domain/index.dart';

/// Việc được chọn để tập trung.
class FocusTarget {
  final String label;
  final int? taskScheduleId;

  const FocusTarget({required this.label, this.taskScheduleId});
}

/// Chọn việc cần tập trung: lấy từ task hôm nay hoặc tự nhập.
/// Trả về [FocusTarget], hoặc `FocusTarget(label: '')` nếu người dùng xoá chọn.
Future<FocusTarget?> showFocusTargetSheet(
  BuildContext context, {
  required List<TaskInstance> todayTasks,
}) {
  return showModalBottomSheet<FocusTarget>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _FocusTargetSheet(todayTasks: todayTasks),
  );
}

class _FocusTargetSheet extends StatefulWidget {
  final List<TaskInstance> todayTasks;

  const _FocusTargetSheet({required this.todayTasks});

  @override
  State<_FocusTargetSheet> createState() => _FocusTargetSheetState();
}

class _FocusTargetSheetState extends State<_FocusTargetSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitTyped() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    Navigator.pop(context, FocusTarget(label: text));
  }

  @override
  Widget build(BuildContext context) {
    final pending = widget.todayTasks.where((t) => !t.done).toList();
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tập trung vào việc gì?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitTyped(),
            decoration: InputDecoration(
              hintText: 'Nhập việc cần làm…',
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.check, color: Color(0xFF00B3A6)),
                onPressed: _submitTyped,
              ),
            ),
          ),
          if (pending.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text('Công việc hôm nay',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8E8E93))),
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pending.length,
                itemBuilder: (context, i) {
                  final t = pending[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.flag, color: Color(t.color), size: 20),
                    title: Text(t.title),
                    onTap: () => Navigator.pop(
                      context,
                      FocusTarget(
                          label: t.title, taskScheduleId: t.scheduleId),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 8),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, const FocusTarget(label: '')),
            child: const Text('Xoá lựa chọn'),
          ),
        ],
      ),
    );
  }
}
