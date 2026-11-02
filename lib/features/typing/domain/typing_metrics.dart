import 'package:equatable/equatable.dart';

/// Trạng thái của từng ký tự trong đề bài (dùng để tô màu đề).
enum TypingCharState {
  /// Chưa gõ tới.
  pending,

  /// Đã gõ và khớp đề.
  correct,

  /// Đã gõ nhưng sai.
  wrong,
}

/// Số liệu của một lần gõ (tính lại được từ đề + chuỗi đã gõ + thời gian).
class TypingMetrics extends Equatable {
  final int typedChars;
  final int correctChars;
  final int incorrectChars;

  /// Số từ gõ đúng trọn vẹn (so theo ranh giới khoảng trắng của đề).
  final int correctWords;

  /// Từ/phút tính trên ký tự ĐÚNG (1 từ = 5 ký tự) — số liệu chính.
  final double wpm;

  /// Từ/phút tính trên mọi ký tự đã gõ (chưa trừ lỗi).
  final double rawWpm;

  /// 0..1 = ký tự đúng / ký tự đã gõ.
  final double accuracy;

  const TypingMetrics({
    this.typedChars = 0,
    this.correctChars = 0,
    this.incorrectChars = 0,
    this.correctWords = 0,
    this.wpm = 0,
    this.rawWpm = 0,
    this.accuracy = 0,
  });

  /// Từ/giây — cùng số liệu với [wpm], chỉ đổi đơn vị.
  double get wps => wpm / 60;

  @override
  List<Object?> get props => [
        typedChars,
        correctChars,
        incorrectChars,
        correctWords,
        wpm,
        rawWpm,
        accuracy,
      ];
}

/// So [typed] với [target] theo từng ký tự (so theo rune nên chữ có dấu tiếng
/// Việt và emoji đều tính là 1 ký tự).
///
/// Trả về đúng `target.runes.length` phần tử; ký tự gõ dư ra ngoài đề không
/// xuất hiện ở đây (nhưng vẫn bị tính là sai trong [computeTypingMetrics]).
List<TypingCharState> typingCharStates(String target, String typed) {
  final t = target.runes.toList();
  final u = typed.runes.toList();
  return [
    for (var i = 0; i < t.length; i++)
      if (i >= u.length)
        TypingCharState.pending
      else if (u[i] == t[i])
        TypingCharState.correct
      else
        TypingCharState.wrong,
  ];
}

/// Tính số liệu cho chuỗi [typed] so với đề [target] trong [elapsed].
///
/// Quy ước chuẩn của bài test gõ phím: 1 "từ" = 5 ký tự, WPM tính trên ký tự
/// gõ đúng. Ký tự gõ dư quá độ dài đề đều tính là sai.
/// Hàm thuần (không phụ thuộc Flutter/Drift) → dễ unit test.
TypingMetrics computeTypingMetrics({
  required String target,
  required String typed,
  required Duration elapsed,
}) {
  final t = target.runes.toList();
  final u = typed.runes.toList();

  final shared = u.length < t.length ? u.length : t.length;
  var correct = 0;
  for (var i = 0; i < shared; i++) {
    if (u[i] == t[i]) correct++;
  }

  final typedChars = u.length;
  final minutes = elapsed.inMicroseconds / Duration.microsecondsPerMinute;

  return TypingMetrics(
    typedChars: typedChars,
    correctChars: correct,
    incorrectChars: typedChars - correct,
    correctWords: _countCorrectWords(t, u),
    wpm: minutes <= 0 ? 0 : (correct / 5) / minutes,
    rawWpm: minutes <= 0 ? 0 : (typedChars / 5) / minutes,
    accuracy: typedChars == 0 ? 0 : correct / typedChars,
  );
}

const _space = 0x20;

/// Đếm số từ của đề mà người dùng đã gõ đúng TRỌN VẸN (đủ mọi ký tự của từ).
int _countCorrectWords(List<int> target, List<int> typed) {
  var count = 0;
  var i = 0;
  while (i < target.length) {
    if (target[i] == _space) {
      i++;
      continue;
    }
    final start = i;
    while (i < target.length && target[i] != _space) {
      i++;
    }
    if (typed.length < i) break; // chưa gõ hết từ này → dừng
    var ok = true;
    for (var k = start; k < i; k++) {
      if (typed[k] != target[k]) {
        ok = false;
        break;
      }
    }
    if (ok) count++;
  }
  return count;
}
