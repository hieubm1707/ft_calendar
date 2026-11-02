import 'package:equatable/equatable.dart';

import 'typing_language.dart';
import 'typing_mode.dart';

/// Kết quả một lần làm bài test gõ phím (thuần Dart).
class TypingResult extends Equatable {
  final int? id;

  /// Ngày giờ kết thúc bài test.
  final DateTime takenAt;

  final TypingLanguage language;
  final TypingMode mode;

  /// Độ dài bài test đã chọn (giây).
  final int durationSeconds;

  /// Số giây thực sự đã gõ.
  final int elapsedSeconds;

  final int typedChars;
  final int correctChars;
  final int incorrectChars;

  /// Số từ gõ đúng trọn vẹn.
  final int correctWords;

  /// Từ/phút (1 từ = 5 ký tự đúng) và độ chính xác 0..1.
  final double wpm;
  final double accuracy;

  const TypingResult({
    this.id,
    required this.takenAt,
    required this.language,
    required this.mode,
    required this.durationSeconds,
    required this.elapsedSeconds,
    required this.typedChars,
    required this.correctChars,
    required this.incorrectChars,
    required this.correctWords,
    required this.wpm,
    required this.accuracy,
  });

  /// Từ/giây — cùng số liệu với [wpm], chỉ đổi đơn vị.
  double get wps => wpm / 60;

  @override
  List<Object?> get props => [
        id,
        takenAt,
        language,
        mode,
        durationSeconds,
        elapsedSeconds,
        typedChars,
        correctChars,
        incorrectChars,
        correctWords,
        wpm,
        accuracy,
      ];
}
