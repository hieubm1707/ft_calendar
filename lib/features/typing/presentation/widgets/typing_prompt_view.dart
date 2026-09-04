import 'package:flutter/material.dart';

import '../../domain/index.dart';
import 'typing_theme.dart';

/// Đề bài đã tô màu: ký tự gõ đúng đậm màu mực, gõ sai nền đỏ, chưa gõ tới thì
/// mờ. Ô cuộn theo tiến độ gõ để phần đang gõ luôn nằm trong tầm mắt.
class TypingPromptView extends StatefulWidget {
  final String prompt;
  final String typed;

  /// Tiến độ 0..1 dùng để cuộn (đề dài hơn ô hiển thị).
  final double progress;

  const TypingPromptView({
    super.key,
    required this.prompt,
    required this.typed,
    required this.progress,
  });

  @override
  State<TypingPromptView> createState() => _TypingPromptViewState();
}

class _TypingPromptViewState extends State<TypingPromptView> {
  final _controller = ScrollController();

  static const _height = 150.0;
  static const _textStyle = TextStyle(
    fontSize: 19,
    height: 1.6,
    fontWeight: FontWeight.w500,
  );

  @override
  void didUpdateWidget(covariant TypingPromptView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) _followProgress();
  }

  /// Chữ trong đề dài đều nhau nên ánh xạ tuyến tính tiến độ → vị trí cuộn là
  /// đủ mượt, lại không phải đo layout từng ký tự.
  void _followProgress() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      final max = _controller.position.maxScrollExtent;
      if (max <= 0) return;
      _controller.animateTo(
        (max * widget.progress).clamp(0.0, max),
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final states = typingCharStates(widget.prompt, widget.typed);
    final chars = widget.prompt.runes.toList();
    final typedCount = widget.typed.runes.length;

    return Container(
      height: _height,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        controller: _controller,
        child: Text.rich(
          TextSpan(
            style: _textStyle,
            children: [
              for (var i = 0; i < chars.length; i++)
                TextSpan(
                  text: String.fromCharCode(chars[i]),
                  style: _styleFor(states[i], caret: i == typedCount),
                ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _styleFor(TypingCharState state, {required bool caret}) {
    final base = switch (state) {
      TypingCharState.correct => const TextStyle(color: kTypingInk),
      TypingCharState.wrong => const TextStyle(
          color: kTypingWrong,
          backgroundColor: Color(0x22E53935),
          decoration: TextDecoration.underline,
          decorationColor: kTypingWrong,
        ),
      TypingCharState.pending => const TextStyle(color: Color(0xFFBDBDBD)),
    };
    // Con trỏ: gạch dưới ký tự sắp gõ để biết mình đang ở đâu.
    return caret
        ? base.copyWith(
            backgroundColor: kTypingAccent.withValues(alpha: 0.18),
          )
        : base;
  }
}
