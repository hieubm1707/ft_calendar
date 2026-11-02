import 'dart:math';

import 'entities/typing_content.dart';
import 'entities/typing_mode.dart';

/// Tốc độ trần dùng để ước lượng đề dài bao nhiêu là đủ (từ/phút).
const _kAssumedMaxWpm = 140;

/// Số từ cần sinh cho bài test dài [durationSeconds] giây — dư một chút để
/// người gõ nhanh không bị hết đề giữa chừng.
int wordCountForDuration(int durationSeconds) {
  final needed = (durationSeconds / 60 * _kAssumedMaxWpm).round();
  return needed.clamp(20, 800);
}

/// Sinh đề "từ ngẫu nhiên": rút [count] từ trong [words] (có lặp lại nếu kho
/// từ nhỏ hơn), nối bằng khoảng trắng. Truyền [random] để test tái lập được.
String buildWordsPrompt(
  List<String> words, {
  required int count,
  Random? random,
}) {
  final pool = words.where((w) => w.trim().isNotEmpty).toList();
  if (pool.isEmpty || count <= 0) return '';
  final rnd = random ?? Random();
  return List.generate(count, (_) => pool[rnd.nextInt(pool.length)].trim())
      .join(' ');
}

/// Chọn ngẫu nhiên một đoạn văn. Trả về chuỗi rỗng nếu kho trống.
String pickParagraph(List<String> paragraphs, {Random? random}) {
  final pool = paragraphs.where((p) => p.trim().isNotEmpty).toList();
  if (pool.isEmpty) return '';
  return pool[(random ?? Random()).nextInt(pool.length)].trim();
}

/// Sinh đề bài cho [mode] từ [bank]. Chế độ "đoạn văn" mà kho chưa có đoạn nào
/// thì tự lùi về "từ ngẫu nhiên" để bài test vẫn chạy được.
String buildPrompt({
  required TypingContentBank bank,
  required TypingMode mode,
  required int durationSeconds,
  Random? random,
}) {
  if (mode == TypingMode.paragraph) {
    final paragraph = pickParagraph(bank.paragraphs, random: random);
    if (paragraph.isNotEmpty) return paragraph;
  }
  return buildWordsPrompt(
    bank.words,
    count: wordCountForDuration(durationSeconds),
    random: random,
  );
}
