import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import '../cubit/typing_content_cubit.dart';
import '../widgets/typing_theme.dart';

/// Kho nội dung gõ phím: xem đang có bao nhiêu từ/đoạn văn, import thêm bằng
/// file JSON/CSV hoặc dán tay, xoá gói đã thêm.
///
/// Trả về `true` khi đóng nếu kho có thay đổi, để trang gõ phím nạp lại đề.
class TypingContentPage extends StatelessWidget {
  final TypingLanguage language;

  const TypingContentPage({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TypingContentCubit>()..load(language: language),
      child: const _ContentView(),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView();

  /// Định dạng nhận được. Nhận cả `.txt` để dán/xuất từ chỗ khác cho tiện.
  /// ⚠️ iOS/macOS chọn file theo **UTI**, không theo đuôi file — thiếu
  /// `uniformTypeIdentifiers` thì `openFile` ném lỗi ngay trên iOS.
  static const _typeGroup = XTypeGroup(
    label: 'Nội dung gõ phím',
    extensions: ['json', 'csv', 'txt'],
    uniformTypeIdentifiers: [
      'public.json',
      'public.comma-separated-values-text',
      'public.plain-text',
    ],
  );

  Future<void> _pickFile(BuildContext context) async {
    final cubit = context.read<TypingContentCubit>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final file = await openFile(acceptedTypeGroups: const [_typeGroup]);
      if (file == null) return;
      // Đọc dạng bytes rồi tự decode UTF-8 để chữ có dấu không bị hỏng.
      final source = utf8.decode(await file.readAsBytes());
      await cubit.import(name: file.name, source: source);
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text('Không đọc được file: $e')));
    }
  }

  Future<void> _pasteContent(BuildContext context) async {
    final cubit = context.read<TypingContentCubit>();
    final result = await showModalBottomSheet<({String name, String source})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _PasteSheet(),
    );
    if (result == null) return;
    await cubit.import(name: result.name, source: result.source);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocConsumer<TypingContentCubit, TypingContentState>(
      listenWhen: (p, c) =>
          (c.message != null && p.message != c.message) ||
          (c.errorMessage != null && p.errorMessage != c.errorMessage),
      listener: (context, state) {
        final text = state.errorMessage ?? state.message;
        if (text == null) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(text)));
      },
      builder: (context, state) {
        final cubit = context.read<TypingContentCubit>();
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) Navigator.of(context).pop(cubit.changed);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: colors.background,
              elevation: 0,
              title: Text('Kho nội dung',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: colors.textPrimary)),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    for (final l in TypingLanguage.values)
                      ChoiceChip(
                        label: Text(l.label),
                        selected: state.language == l,
                        selectedColor: colors.typing.withValues(alpha: 0.18),
                        onSelected: (_) => cubit.changeLanguage(l),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                _BankSummary(state: state),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _pickFile(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.typing,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.folder_open, size: 18),
                        label: const Text('Chọn file'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pasteContent(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.typing,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.content_paste, size: 18),
                        label: const Text('Dán nội dung'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const _FormatHint(),
                const SizedBox(height: 20),
                Text('Gói đã thêm (${state.packs.length})',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary)),
                const SizedBox(height: 8),
                if (state.packs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Chưa thêm gói nào.\n'
                      'Bài test đang dùng nội dung có sẵn của app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.textMuted),
                    ),
                  )
                else
                  ...state.packs.map((p) => _PackTile(
                        pack: p,
                        onDelete: () => _confirmDelete(context, p),
                      )),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, TypingContentPack pack) async {
    final cubit = context.read<TypingContentCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xoá gói nội dung?'),
        content: Text('"${pack.name}" sẽ bị gỡ khỏi kho từ.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Huỷ')),
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Xoá')),
        ],
      ),
    );
    if (ok == true && pack.id != null) await cubit.remove(pack.id!);
  }
}

/// Tổng kho đang dùng cho bài test = có sẵn + đã import.
class _BankSummary extends StatelessWidget {
  final TypingContentState state;

  const _BankSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bank = state.bank;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(
              value: '${bank.words.length}',
              caption: 'từ',
              extra: state.importedWords > 0
                  ? '+${state.importedWords} đã thêm'
                  : null,
            ),
          ),
          Expanded(
            child: _Stat(
              value: '${bank.paragraphs.length}',
              caption: 'đoạn văn',
              extra: state.importedParagraphs > 0
                  ? '+${state.importedParagraphs} đã thêm'
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String caption;
  final String? extra;

  const _Stat({required this.value, required this.caption, this.extra});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        Text(caption,
            style: TextStyle(fontSize: 12, color: colors.textMuted)),
        if (extra != null)
          Text(extra!,
              style: TextStyle(
                  fontSize: 11,
                  color: colors.typing,
                  fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _FormatHint extends StatelessWidget {
  const _FormatHint();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      'Nhận file .json, .csv, .txt.\n'
      '• JSON: {"words": [...], "paragraphs": [...]}\n'
      '• Văn bản/CSV: mỗi dòng một câu = đoạn văn; dòng ngăn bằng dấu phẩy'
      ' (the, and, people) = danh sách từ.',
      style: TextStyle(fontSize: 11, color: colors.textMuted, height: 1.5),
    );
  }
}

class _PackTile extends StatelessWidget {
  final TypingContentPack pack;
  final VoidCallback onDelete;

  const _PackTile({required this.pack, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final d = pack.addedAt;
    return Card(
      elevation: 0,
      color: colors.surface,
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        leading: Icon(Icons.inventory_2_outlined, color: colors.typing),
        title: Text(pack.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${pack.words.length} từ · ${pack.paragraphs.length} đoạn'
          ' · ${formatDayShort(d)} ${formatClock(d)}',
          style: TextStyle(fontSize: 12, color: colors.textMuted),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline,
              size: 20, color: colors.textDisabled),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

/// Dán thẳng nội dung khi không tiện chọn file.
class _PasteSheet extends StatefulWidget {
  const _PasteSheet();

  @override
  State<_PasteSheet> createState() => _PasteSheetState();
}

class _PasteSheetState extends State<_PasteSheet> {
  final _name = TextEditingController(text: 'Dán tay');
  final _source = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _source.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Dán nội dung',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary)),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: 'Tên gói',
                filled: true,
                fillColor: colors.surface,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _source,
              minLines: 6,
              maxLines: 10,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Dán JSON, CSV hoặc mỗi dòng một từ / một đoạn văn…',
                filled: true,
                fillColor: colors.surface,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.typing,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Navigator.of(context)
                  .pop((name: _name.text, source: _source.text)),
              child: const Text('Thêm vào kho'),
            ),
          ],
        ),
      ),
    );
  }
}
