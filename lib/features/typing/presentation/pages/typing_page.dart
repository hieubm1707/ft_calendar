import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
import '../../domain/index.dart';
import '../cubit/typing_cubit.dart';
import '../widgets/typing_prompt_view.dart';
import '../widgets/typing_theme.dart';
import 'typing_content_page.dart';
import 'typing_history_page.dart';

/// Trang "Typing": bài test gõ phím theo thời gian, 2 ngôn ngữ Anh/Việt.
/// Hết giờ (hoặc gõ hết đề) là chốt WPM và lưu kết quả kèm ngày giờ.
class TypingPage extends StatelessWidget {
  const TypingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TypingCubit>()..init(),
      child: const _TypingView(),
    );
  }
}

class _TypingView extends StatefulWidget {
  const _TypingView();

  @override
  State<_TypingView> createState() => _TypingViewState();
}

class _TypingViewState extends State<_TypingView> {
  final _input = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _restart(BuildContext context) {
    context.read<TypingCubit>().restart();
    _input.clear();
    _focus.requestFocus();
  }

  void _openHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TypingHistoryPage()),
    );
  }

  /// Mở kho nội dung; import/xoá xong thì nạp lại kho và sinh đề mới.
  Future<void> _openContent(BuildContext context) async {
    final cubit = context.read<TypingCubit>();
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TypingContentPage(language: cubit.state.language),
      ),
    );
    if (changed == true) await cubit.reloadContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTypingBackground,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<TypingCubit, TypingState>(
          listenWhen: (p, c) =>
              c.errorMessage != null && p.errorMessage != c.errorMessage,
          listener: (context, state) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!))),
          builder: (context, state) {
            // Đề mới (đổi cài đặt / làm lại) thì ô nhập phải trống theo.
            if (state.typed.isEmpty && _input.text.isNotEmpty) _input.clear();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(
                    onContent: () => _openContent(context),
                    onHistory: () => _openHistory(context),
                  ),
                  const SizedBox(height: 12),
                  _Settings(state: state),
                  const SizedBox(height: 16),
                  _LiveStats(state: state),
                  const SizedBox(height: 14),
                  if (state.loadingContent)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.prompt.isEmpty)
                    _EmptyBank(onImport: () => _openContent(context))
                  else ...[
                    TypingPromptView(
                      prompt: state.prompt,
                      typed: state.typed,
                    ),
                    const SizedBox(height: 12),
                    _InputBox(
                      controller: _input,
                      focusNode: _focus,
                      state: state,
                      onChanged: (text) =>
                          context.read<TypingCubit>().onTyped(text),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _restart(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: kTypingAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.refresh),
                          label: Text(state.isFinished ? 'Làm lại' : 'Đề khác'),
                        ),
                      ),
                    ],
                  ),
                  if (state.isFinished) ...[
                    const SizedBox(height: 16),
                    _ResultCard(state: state),
                  ],
                  if (state.todayResults.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _TodayStrip(state: state),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onContent;
  final VoidCallback onHistory;

  const _Header({required this.onContent, required this.onHistory});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text('Gõ phím',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: kTypingInk)),
        ),
        IconButton(
          tooltip: 'Kho nội dung',
          onPressed: onContent,
          icon: const Icon(Icons.library_add_outlined, color: kTypingInk),
        ),
        IconButton(
          tooltip: 'Lịch sử',
          onPressed: onHistory,
          icon: const Icon(Icons.bar_chart_rounded, color: kTypingInk),
        ),
      ],
    );
  }
}

/// Ngôn ngữ + chế độ nội dung + thời lượng. Khoá lại khi bài đang chạy.
class _Settings extends StatelessWidget {
  final TypingState state;

  const _Settings({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TypingCubit>();
    final enabled = state.canChangeSettings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final l in TypingLanguage.values)
              ChoiceChip(
                label: Text(l.label),
                selected: state.language == l,
                selectedColor: kTypingAccent.withValues(alpha: 0.18),
                onSelected: enabled ? (_) => cubit.setLanguage(l) : null,
              ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final m in TypingMode.values)
              ChoiceChip(
                label: Text(m.label),
                selected: state.mode == m,
                selectedColor: kTypingAccent.withValues(alpha: 0.18),
                onSelected: enabled ? (_) => cubit.setMode(m) : null,
              ),
            for (final s in TypingCubit.durationPresets)
              ChoiceChip(
                label: Text('${s}s'),
                selected: state.durationSeconds == s,
                selectedColor: kTypingAccent.withValues(alpha: 0.18),
                onSelected: enabled ? (_) => cubit.setDuration(s) : null,
              ),
          ],
        ),
      ],
    );
  }
}

/// Đồng hồ đếm ngược + WPM/độ chính xác đang chạy.
class _LiveStats extends StatelessWidget {
  final TypingState state;

  const _LiveStats({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Metric(
              value: state.remainingLabel,
              caption: 'Còn lại',
              big: true,
            ),
          ),
          Expanded(
            child: _Metric(
              value: state.metrics.wpm.toStringAsFixed(0),
              caption: 'WPM',
              big: true,
            ),
          ),
          Expanded(
            child: _Metric(
              value: '${(state.metrics.accuracy * 100).round()}%',
              caption: 'Chính xác',
            ),
          ),
          Expanded(
            child: _Metric(
              value: '${state.metrics.correctWords}',
              caption: 'Từ đúng',
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String value;
  final String caption;
  final bool big;

  const _Metric({required this.value, required this.caption, this.big = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            maxLines: 1,
            style: TextStyle(
                fontSize: big ? 24 : 20,
                fontWeight: FontWeight.w800,
                color: kTypingInk,
                fontFeatures: const [FontFeature.tabularFigures()])),
        Text(caption,
            style: const TextStyle(fontSize: 11, color: kTypingMuted)),
      ],
    );
  }
}

/// Ô nhập thật — cần TextField để bộ gõ tiếng Việt (telex/VNI) hoạt động.
class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TypingState state;
  final ValueChanged<String> onChanged;

  const _InputBox({
    required this.controller,
    required this.focusNode,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      enabled: !state.isFinished,
      autofocus: false,
      maxLines: 3,
      minLines: 3,
      // Tắt gợi ý/tự sửa để không bị máy sửa hộ, làm sai số liệu.
      autocorrect: false,
      enableSuggestions: false,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(fontSize: 17, height: 1.5, color: kTypingInk),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: state.isFinished
            ? 'Hết bài — bấm "Làm lại" để gõ tiếp'
            : 'Gõ vào đây, ký tự đầu tiên bắt đầu tính giờ…',
        hintStyle: const TextStyle(color: kTypingMuted, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// Kho rỗng: chỉ thẳng tới chỗ import thay vì bắt người dùng tự mò.
class _EmptyBank extends StatelessWidget {
  final VoidCallback onImport;

  const _EmptyBank({required this.onImport});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text('Chưa có nội dung để gõ.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kTypingMuted)),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onImport,
            style: FilledButton.styleFrom(backgroundColor: kTypingAccent),
            icon: const Icon(Icons.library_add_outlined, size: 18),
            label: const Text('Thêm nội dung'),
          ),
        ],
      ),
    );
  }
}

/// Bảng kết quả sau khi chốt bài.
class _ResultCard extends StatelessWidget {
  final TypingState state;

  const _ResultCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final m = state.metrics;
    final isBest = m.wpm > 0 && m.wpm >= state.todayBestWpm;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kTypingAccent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(m.wpm.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: kTypingAccent,
                      height: 1)),
              const Padding(
                padding: EdgeInsets.only(left: 6, bottom: 6),
                child: Text('WPM',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kTypingMuted)),
              ),
              const Spacer(),
              if (isBest)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kTypingAccent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Tốt nhất hôm nay 🎉',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: kTypingAccent)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text('${m.wps.toStringAsFixed(2)} từ/giây'
              ' · thô ${m.rawWpm.toStringAsFixed(0)} WPM',
              style: const TextStyle(fontSize: 12, color: kTypingMuted)),
          const Divider(height: 24),
          Wrap(
            spacing: 18,
            runSpacing: 10,
            children: [
              _ResultChip(
                  label: 'Chính xác',
                  value: '${(m.accuracy * 100).toStringAsFixed(1)}%'),
              _ResultChip(label: 'Ký tự đúng', value: '${m.correctChars}'),
              _ResultChip(label: 'Ký tự sai', value: '${m.incorrectChars}'),
              _ResultChip(label: 'Từ đúng', value: '${m.correctWords}'),
              _ResultChip(
                  label: 'Ngôn ngữ',
                  value: '${state.language.label} · ${state.mode.label}'),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Kết quả đã được lưu kèm ngày giờ.',
              style: TextStyle(fontSize: 11, color: kTypingMuted)),
        ],
      ),
    );
  }
}

class _ResultChip extends StatelessWidget {
  final String label;
  final String value;

  const _ResultChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: kTypingInk)),
        Text(label,
            style: const TextStyle(fontSize: 11, color: kTypingMuted)),
      ],
    );
  }
}

/// Dải kết quả của hôm nay ngay dưới bài test.
class _TodayStrip extends StatelessWidget {
  final TypingState state;

  const _TodayStrip({required this.state});

  @override
  Widget build(BuildContext context) {
    final results = state.todayResults;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(
            'Hôm nay · ${results.length} bài · tốt nhất '
            '${state.todayBestWpm.toStringAsFixed(0)} WPM',
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: kTypingInk),
          ),
        ),
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: results.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final r = results[i];
              return Container(
                width: 104,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${r.wpm.toStringAsFixed(0)} WPM',
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: kTypingInk)),
                    Text('${(r.accuracy * 100).round()}% · ${r.language.code}',
                        style: const TextStyle(
                            fontSize: 11, color: kTypingMuted)),
                    const Spacer(),
                    Text(formatClock(r.takenAt),
                        style: const TextStyle(
                            fontSize: 11, color: kTypingMuted)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
