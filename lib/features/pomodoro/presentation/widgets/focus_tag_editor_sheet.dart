import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/index.dart';

/// Kết quả của sheet: [saved] = tag cần lưu, [deletedId] = tag cần xoá.
class FocusTagEditResult {
  final FocusTag? saved;
  final int? deletedId;

  const FocusTagEditResult.save(FocusTag tag)
      : saved = tag,
        deletedId = null;

  const FocusTagEditResult.delete(int id)
      : saved = null,
        deletedId = id;
}

/// Thêm mới ([tag] null) hoặc sửa tag tập trung (tên, số phút, màu, emoji).
Future<FocusTagEditResult?> showFocusTagEditor(
  BuildContext context, {
  FocusTag? tag,
}) {
  return showModalBottomSheet<FocusTagEditResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _FocusTagEditorSheet(tag: tag),
  );
}

const _kAccent = Color(0xFF00B3A6);
const _kMinutePresets = [5, 10, 15, 20, 25, 30, 45, 60, 90];
const _kColors = [
  0xFF00B3A6,
  0xFF4C8DFF,
  0xFFFFA726,
  0xFF66BB6A,
  0xFFAB47BC,
  0xFFEF5350,
  0xFF26C6DA,
  0xFF8D6E63,
];
const _kEmojis = [
  '💼', '📖', '🏃', '🎯', '📚', '💻',
  '✍️', '🧘', '🎧', '🎨', '🍳', '💡',
];

class _FocusTagEditorSheet extends StatefulWidget {
  final FocusTag? tag;

  const _FocusTagEditorSheet({this.tag});

  @override
  State<_FocusTagEditorSheet> createState() => _FocusTagEditorSheetState();
}

class _FocusTagEditorSheetState extends State<_FocusTagEditorSheet> {
  late final TextEditingController _title =
      TextEditingController(text: widget.tag?.title ?? '');
  late final TextEditingController _minutes =
      TextEditingController(text: '${widget.tag?.minutes ?? 25}');

  late int _color = widget.tag?.color ?? _kColors.first;
  late String? _emoji = widget.tag?.emoji;

  bool get _isEditing => widget.tag?.id != null;

  @override
  void dispose() {
    _title.dispose();
    _minutes.dispose();
    super.dispose();
  }

  int get _parsedMinutes => int.tryParse(_minutes.text.trim()) ?? 0;

  void _submit() {
    final title = _title.text.trim();
    final minutes = _parsedMinutes;
    if (title.isEmpty || minutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Nhập tên tag và số phút lớn hơn 0.')));
      return;
    }
    final base = widget.tag ?? const FocusTag(title: '', minutes: 25);
    Navigator.pop(
      context,
      FocusTagEditResult.save(base.copyWith(
        title: title,
        minutes: minutes,
        color: _color,
        emoji: _emoji,
      )),
    );
  }

  Future<void> _confirmDelete() async {
    final id = widget.tag?.id;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá tag?'),
        content: Text(
            'Xoá "${widget.tag!.title}". Các phiên đã ghi nhận vẫn giữ nguyên.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Xoá')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    Navigator.pop(context, FocusTagEditResult.delete(id));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isEditing ? 'Sửa tag' : 'Tag mới',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: _decoration('Tên tag (ví dụ: Work)'),
            ),
            const SizedBox(height: 14),
            const _Label('Số phút mỗi phiên'),
            const SizedBox(height: 6),
            TextField(
              controller: _minutes,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              decoration: _decoration('25'),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final m in _kMinutePresets)
                  ChoiceChip(
                    label: Text('${m}p'),
                    selected: _parsedMinutes == m,
                    selectedColor: _kAccent.withValues(alpha: 0.18),
                    onSelected: (_) => setState(() {
                      _minutes.text = '$m';
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const _Label('Biểu tượng'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _EmojiOption(
                  emoji: null,
                  selected: _emoji == null,
                  onTap: () => setState(() => _emoji = null),
                ),
                for (final e in _kEmojis)
                  _EmojiOption(
                    emoji: e,
                    selected: _emoji == e,
                    onTap: () => setState(() => _emoji = e),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const _Label('Màu'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 10,
              children: [
                for (final c in _kColors)
                  GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _color == c
                              ? const Color(0xFF1C1C1E)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Color(_color),
                  shape: const StadiumBorder(),
                ),
                onPressed: _submit,
                child: const Text('Lưu',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            if (_isEditing)
              Center(
                child: TextButton.icon(
                  onPressed: _confirmDelete,
                  icon: const Icon(Icons.delete_outline,
                      size: 18, color: Color(0xFFEF5350)),
                  label: const Text('Xoá tag',
                      style: TextStyle(color: Color(0xFFEF5350))),
                ),
              ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF8E8E93)));
}

class _EmojiOption extends StatelessWidget {
  final String? emoji;
  final bool selected;
  final VoidCallback onTap;

  const _EmojiOption(
      {required this.emoji, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _kAccent.withValues(alpha: 0.15) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _kAccent : Colors.transparent,
          ),
        ),
        child: emoji == null
            ? const Icon(Icons.block, size: 16, color: Color(0xFF8E8E93))
            : Text(emoji!, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
