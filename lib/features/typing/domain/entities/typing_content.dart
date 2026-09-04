import 'package:equatable/equatable.dart';

import 'typing_language.dart';

/// Kho nội dung để sinh đề bài của MỘT ngôn ngữ — gộp từ mọi file JSON
/// trong `assets/typing/<code>/`. Thêm từ/đoạn văn mới = thả thêm file JSON,
/// không phải sửa code.
class TypingContentBank extends Equatable {
  final TypingLanguage language;

  /// Từ đơn để sinh đề "từ ngẫu nhiên".
  final List<String> words;

  /// Đoạn văn hoàn chỉnh cho chế độ "đoạn văn".
  final List<String> paragraphs;

  const TypingContentBank({
    required this.language,
    this.words = const [],
    this.paragraphs = const [],
  });

  bool get isEmpty => words.isEmpty && paragraphs.isEmpty;

  /// Gộp thêm một file nội dung khác (bỏ trùng, giữ nguyên thứ tự xuất hiện).
  TypingContentBank merge(TypingContentBank other) {
    return TypingContentBank(
      language: language,
      words: {...words, ...other.words}.toList(),
      paragraphs: {...paragraphs, ...other.paragraphs}.toList(),
    );
  }

  @override
  List<Object?> get props => [language, words, paragraphs];
}
