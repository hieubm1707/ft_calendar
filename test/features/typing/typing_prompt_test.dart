import 'dart:math';

import 'package:example_app/features/typing/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const bank = TypingContentBank(
    language: TypingLanguage.vietnamese,
    words: ['mua', 'nang', 'gio'],
    paragraphs: ['Một đoạn văn để luyện gõ.'],
  );

  test('wordCountForDuration tăng theo thời lượng và luôn đủ dùng', () {
    expect(wordCountForDuration(15), greaterThanOrEqualTo(20));
    expect(wordCountForDuration(120),
        greaterThan(wordCountForDuration(60)));
  });

  test('buildWordsPrompt sinh đúng số từ, lặp lại khi kho từ nhỏ', () {
    final prompt =
        buildWordsPrompt(bank.words, count: 10, random: Random(1));

    expect(prompt.split(' ').length, 10);
    expect(prompt.split(' ').toSet().difference(bank.words.toSet()), isEmpty);
  });

  test('buildWordsPrompt với kho từ rỗng trả về chuỗi rỗng', () {
    expect(buildWordsPrompt(const [], count: 10), '');
  });

  test('chế độ đoạn văn lấy đúng một đoạn có sẵn', () {
    final prompt = buildPrompt(
      bank: bank,
      mode: TypingMode.paragraph,
      durationSeconds: 60,
      random: Random(1),
    );

    expect(bank.paragraphs, contains(prompt));
  });

  test('chưa có đoạn văn thì tự lùi về từ ngẫu nhiên', () {
    const wordsOnly = TypingContentBank(
      language: TypingLanguage.english,
      words: ['the', 'and'],
    );

    final prompt = buildPrompt(
      bank: wordsOnly,
      mode: TypingMode.paragraph,
      durationSeconds: 15,
      random: Random(1),
    );

    expect(prompt, isNotEmpty);
    expect(prompt.split(' ').length, wordCountForDuration(15));
  });

  test('merge gộp nội dung và bỏ trùng', () {
    final merged = bank.merge(const TypingContentBank(
      language: TypingLanguage.vietnamese,
      words: ['mua', 'may'],
    ));

    expect(merged.words, ['mua', 'nang', 'gio', 'may']);
    expect(merged.paragraphs, bank.paragraphs);
  });
}
