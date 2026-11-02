import 'package:example_app/features/typing/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';

TypingResult _result(
  DateTime takenAt, {
  double wpm = 40,
  double accuracy = 0.95,
  TypingLanguage language = TypingLanguage.english,
  int elapsedSeconds = 60,
}) {
  return TypingResult(
    takenAt: takenAt,
    language: language,
    mode: TypingMode.words,
    durationSeconds: 60,
    elapsedSeconds: elapsedSeconds,
    typedChars: 200,
    correctChars: 190,
    incorrectChars: 10,
    correctWords: 38,
    wpm: wpm,
    accuracy: accuracy,
  );
}

void main() {
  group('summarizeTyping', () {
    test('mọi ngày trong khoảng đều có mặt, kể cả ngày không làm bài', () {
      final report = summarizeTyping(
        results: [_result(DateTime(2026, 9, 2, 10))],
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 9, 4),
      );

      expect(report.days.length, 4);
      expect(report.days.first.tests, 0);
      expect(report.days[1].tests, 1);
      expect(report.dayCount, 4);
      expect(report.activeDays, 1);
    });

    test('bỏ qua kết quả ngoài khoảng', () {
      final report = summarizeTyping(
        results: [
          _result(DateTime(2026, 8, 30, 9)),
          _result(DateTime(2026, 9, 2, 9)),
          _result(DateTime(2026, 9, 9, 9)),
        ],
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 9, 3),
      );

      expect(report.totalTests, 1);
    });

    test('tổng hợp WPM tốt nhất / trung bình / độ chính xác', () {
      final report = summarizeTyping(
        results: [
          _result(DateTime(2026, 9, 2, 9), wpm: 30, accuracy: 0.9),
          _result(DateTime(2026, 9, 2, 10), wpm: 50, accuracy: 1),
        ],
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 9, 3),
      );

      expect(report.totalTests, 2);
      expect(report.bestWpm, 50);
      expect(report.averageWpm, closeTo(40, 0.001));
      expect(report.averageAccuracy, closeTo(0.95, 0.001));
      expect(report.totalSeconds, 120);
      expect(report.days[1].bestWpm, 50);
      expect(report.days[1].averageWpm, closeTo(40, 0.001));
    });

    test('gom theo ngôn ngữ, nhiều bài nhất đứng trước', () {
      final report = summarizeTyping(
        results: [
          _result(DateTime(2026, 9, 2, 9), language: TypingLanguage.english),
          _result(DateTime(2026, 9, 2, 10),
              language: TypingLanguage.vietnamese, wpm: 20),
          _result(DateTime(2026, 9, 2, 11),
              language: TypingLanguage.vietnamese, wpm: 60),
        ],
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 9, 3),
      );

      expect(report.languages.first.language, TypingLanguage.vietnamese);
      expect(report.languages.first.tests, 2);
      expect(report.languages.first.bestWpm, 60);
      expect(report.languages.first.averageWpm, closeTo(40, 0.001));
    });

    test('chuỗi ngày liên tiếp: ngày cuối chưa luyện không phá chuỗi', () {
      final report = summarizeTyping(
        results: [
          _result(DateTime(2026, 9, 2, 9)),
          _result(DateTime(2026, 9, 3, 9)),
        ],
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 9, 4),
      );

      expect(report.streakDays, 2);
    });

    test('khoảng rỗng cho report toàn 0, không chia cho 0', () {
      final report = summarizeTyping(
        results: const [],
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 9, 3),
      );

      expect(report.totalTests, 0);
      expect(report.averageWpm, 0);
      expect(report.averageAccuracy, 0);
      expect(report.bestWpm, 0);
      expect(report.streakDays, 0);
    });
  });

  group('bucketTypingDays', () {
    test('khoảng dài gom theo tháng, WPM trung bình theo trọng số số bài', () {
      final report = summarizeTyping(
        results: [
          _result(DateTime(2026, 1, 5, 9), wpm: 30),
          _result(DateTime(2026, 1, 20, 9), wpm: 50),
          _result(DateTime(2026, 2, 10, 9), wpm: 80),
        ],
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 3, 31),
      );

      expect(autoTypingBucketUnit(report.dayCount), TypingBucketUnit.month);

      final buckets =
          bucketTypingDays(report.days, TypingBucketUnit.month);

      expect(buckets.length, 3); // tháng 3 không có bài vẫn giữ cột
      expect(buckets.first.start, DateTime(2026, 1));
      expect(buckets.first.tests, 2);
      expect(buckets.first.bestWpm, 50);
      expect(buckets.first.averageWpm, closeTo(40, 0.001));
      expect(buckets[1].bestWpm, 80);
      expect(buckets.last.tests, 0);
    });

    test('khoảng ngắn giữ nguyên từng ngày', () {
      final report = summarizeTyping(
        results: [_result(DateTime(2026, 9, 2, 9))],
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 9, 5),
      );

      expect(autoTypingBucketUnit(report.dayCount), TypingBucketUnit.day);
      expect(bucketTypingDays(report.days, TypingBucketUnit.day).length, 5);
    });
  });
}
