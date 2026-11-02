import 'package:drift/drift.dart';

/// Một lần làm bài test gõ phím đã hoàn thành.
/// [takenAt] là ngày giờ kết thúc bài — lịch sử xem lại theo đúng mốc này.
/// Data class: `TypingResultTableData`, companion: `TypingResultTableCompanion`.
class TypingResultTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Thời điểm kết thúc bài test.
  DateTimeColumn get takenAt => dateTime()();

  /// Mã ngôn ngữ đã gõ: 'en' | 'vi'.
  TextColumn get language => text().withLength(min: 2, max: 8)();

  /// Nguồn nội dung: 'words' (từ ngẫu nhiên) | 'paragraph' (đoạn văn).
  TextColumn get mode => text().withLength(min: 1, max: 16)();

  /// Độ dài bài test đã chọn (giây).
  IntColumn get durationSeconds => integer()();

  /// Số giây thực sự đã gõ (gõ xong đề sớm thì nhỏ hơn [durationSeconds]).
  IntColumn get elapsedSeconds => integer()();

  IntColumn get typedChars => integer()();
  IntColumn get correctChars => integer()();
  IntColumn get incorrectChars => integer()();

  /// Số từ gõ đúng trọn vẹn (khác với "từ" 5 ký tự dùng để tính WPM).
  IntColumn get correctWords => integer()();

  /// Tốc độ gõ (từ/phút; 1 từ = 5 ký tự ĐÚNG) và độ chính xác 0..1.
  RealColumn get wpm => real()();
  RealColumn get accuracy => real()();
}
