import 'package:flutter/material.dart';

import '../../domain/index.dart';
import 'typing_theme.dart';

const _kFontSize = 19.0;
const _kLineSpacing = 1.6;

/// Số dòng hiển thị cùng lúc.
const _kVisibleLines = 3;

/// Đề bài đã tô màu: ký tự gõ đúng đậm màu mực, gõ sai nền đỏ, chưa gõ tới thì
/// mờ.
///
/// Ô cuộn **theo từng dòng**: gõ trong một dòng thì đề đứng yên, gõ xong dòng
/// đó mới trượt lên đúng 1 dòng. Vị trí dòng lấy từ `TextPainter` đo trên đúng
/// bề rộng + kiểu chữ đang vẽ, nên khớp với chỗ chữ thực sự xuống dòng.
class TypingPromptView extends StatefulWidget {
  final String prompt;
  final String typed;

  const TypingPromptView({
    super.key,
    required this.prompt,
    required this.typed,
  });

  @override
  State<TypingPromptView> createState() => _TypingPromptViewState();
}

class _TypingPromptViewState extends State<TypingPromptView> {
  final _controller = ScrollController();

  static const _textStyle = TextStyle(
    fontSize: _kFontSize,
    height: _kLineSpacing,
    fontWeight: FontWeight.w500,
  );

  /// Kết quả đo của đề hiện tại — chỉ đo lại khi đổi đề hoặc đổi bề rộng,
  /// không đo lại mỗi lần gõ.
  TextPainter? _painter;
  String _measuredPrompt = '';
  double _measuredWidth = 0;

  /// Dòng đang gõ ở lần dựng trước — chỉ cuộn khi số này đổi.
  int _line = 0;

  double get _lineHeight => _kFontSize * _kLineSpacing;

  @override
  void dispose() {
    _painter?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _measure(String prompt, double width) {
    if (_painter != null && prompt == _measuredPrompt && width == _measuredWidth) {
      return;
    }
    _painter?.dispose();
    _painter = TextPainter(
      text: TextSpan(text: prompt, style: _textStyle),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);
    _measuredPrompt = prompt;
    _measuredWidth = width;
  }

  /// Chỉ số dòng chứa ký tự sắp gõ.
  int _caretLine() {
    final painter = _painter;
    if (painter == null || widget.prompt.isEmpty) return 0;
    final offset = _utf16Offset(widget.prompt, widget.typed.runes.length);
    final dy = painter
        .getOffsetForCaret(TextPosition(offset: offset), Rect.zero)
        .dy;
    return (dy / _lineHeight).round();
  }

  /// Đưa dòng đang gõ lên đầu ô — mỗi lần trượt đúng một dòng.
  void _scrollToLine(int line) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      final max = _controller.position.maxScrollExtent;
      if (max <= 0) return;
      _controller.animateTo(
        (line * _lineHeight).clamp(0.0, max),
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final states = typingCharStates(widget.prompt, widget.typed);
    final chars = widget.prompt.runes.toList();
    final typedCount = widget.typed.runes.length;

    return Container(
      height: _kVisibleLines * _lineHeight + 28,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          _measure(widget.prompt, constraints.maxWidth);
          final line = _caretLine();
          if (line != _line) {
            _line = line;
            _scrollToLine(line);
          }

          return SingleChildScrollView(
            controller: _controller,
            // Người dùng đang gõ, không cho kéo tay làm lệch dòng.
            physics: const NeverScrollableScrollPhysics(),
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
          );
        },
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
    // Con trỏ: tô nền nhạt ký tự sắp gõ để biết mình đang ở đâu.
    return caret
        ? base.copyWith(backgroundColor: kTypingAccent.withValues(alpha: 0.18))
        : base;
  }
}

/// Đổi số ký tự (đếm theo rune) thành offset UTF-16 mà `TextPosition` cần.
/// Chữ tiếng Việt nằm trong BMP nên thường bằng nhau, nhưng emoji thì không.
int _utf16Offset(String text, int runeCount) {
  if (runeCount <= 0) return 0;
  var counted = 0;
  var offset = 0;
  for (final rune in text.runes) {
    if (counted >= runeCount) break;
    offset += rune > 0xFFFF ? 2 : 1;
    counted++;
  }
  return offset;
}
