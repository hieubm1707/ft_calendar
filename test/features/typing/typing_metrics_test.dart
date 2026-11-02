import 'package:example_app/features/typing/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('computeTypingMetrics', () {
    test('gõ đúng hết: WPM = ký tự / 5 / phút, chính xác 100%', () {
      // 50 ký tự đúng trong 30 giây → 10 "từ" trong 0.5 phút → 20 WPM.
      final target = 'a' * 50;
      final m = computeTypingMetrics(
        target: target,
        typed: target,
        elapsed: const Duration(seconds: 30),
      );

      expect(m.typedChars, 50);
      expect(m.correctChars, 50);
      expect(m.incorrectChars, 0);
      expect(m.wpm, closeTo(20, 0.001));
      expect(m.rawWpm, closeTo(20, 0.001));
      expect(m.accuracy, 1);
      expect(m.wps, closeTo(20 / 60, 0.0001));
    });

    test('ký tự sai không tính vào WPM nhưng vẫn tính vào WPM thô', () {
      final m = computeTypingMetrics(
        target: 'abcdefghij',
        typed: 'abcdeXXXXX',
        elapsed: const Duration(seconds: 60),
      );

      expect(m.correctChars, 5);
      expect(m.incorrectChars, 5);
      expect(m.wpm, closeTo(1, 0.001)); // 5/5 ký tự trong 1 phút
      expect(m.rawWpm, closeTo(2, 0.001));
      expect(m.accuracy, closeTo(0.5, 0.001));
    });

    test('gõ dư quá độ dài đề đều tính là sai', () {
      final m = computeTypingMetrics(
        target: 'abc',
        typed: 'abcdef',
        elapsed: const Duration(seconds: 60),
      );

      expect(m.correctChars, 3);
      expect(m.incorrectChars, 3);
      expect(m.typedChars, 6);
    });

    test('chưa gõ gì thì mọi số liệu bằng 0, không chia cho 0', () {
      final m = computeTypingMetrics(
        target: 'abc',
        typed: '',
        elapsed: Duration.zero,
      );

      expect(m.wpm, 0);
      expect(m.accuracy, 0);
      expect(m.correctWords, 0);
    });

    test('chữ tiếng Việt có dấu tính là 1 ký tự', () {
      const target = 'ước mơ';
      final m = computeTypingMetrics(
        target: target,
        typed: target,
        elapsed: const Duration(seconds: 60),
      );

      expect(m.typedChars, target.runes.length);
      expect(m.correctChars, target.runes.length);
      expect(m.accuracy, 1);
    });

    test('đếm từ đúng trọn vẹn, từ đang gõ dở không tính', () {
      final m = computeTypingMetrics(
        target: 'mua nang gio may',
        typed: 'mua nang gi',
        elapsed: const Duration(seconds: 60),
      );

      expect(m.correctWords, 2); // 'mua', 'nang'; 'gi' còn dở
    });

    test('từ sai 1 ký tự thì cả từ không được tính', () {
      final m = computeTypingMetrics(
        target: 'mua nang gio',
        typed: 'mua nxng gio',
        elapsed: const Duration(seconds: 60),
      );

      expect(m.correctWords, 2); // 'mua' và 'gio'
    });
  });

  group('typingCharStates', () {
    test('phân loại đúng / sai / chưa gõ theo từng ký tự', () {
      final states = typingCharStates('abcd', 'aXc');

      expect(states, [
        TypingCharState.correct,
        TypingCharState.wrong,
        TypingCharState.correct,
        TypingCharState.pending,
      ]);
    });

    test('luôn trả về đúng số ký tự của đề, kể cả khi gõ dư', () {
      expect(typingCharStates('ab', 'abcdef').length, 2);
    });
  });
}
