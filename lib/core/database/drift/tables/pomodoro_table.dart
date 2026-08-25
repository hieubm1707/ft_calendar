import 'package:drift/drift.dart';

/// Một phiên tập trung (focus) đã thực hiện. Chỉ lưu phiên FOCUS —
/// thời gian nghỉ không tính vào report.
/// Data class: `PomodoroSessionTableData`, companion: `PomodoroSessionTableCompanion`.
class PomodoroSessionTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();

  /// Số giây thực sự đã tập trung (không tính lúc pause bị dừng sớm).
  IntColumn get focusSeconds => integer()();

  /// Độ dài phiên đã đặt (giây) — để biết phiên có chạy hết hay không.
  IntColumn get plannedSeconds => integer()();

  /// true = chạy hết phiên, false = dừng giữa chừng.
  BoolColumn get completed => boolean().withDefault(const Constant(true))();

  /// Việc đang tập trung (tên task hoặc nhãn tự nhập).
  TextColumn get label => text().nullable()();

  /// Task liên kết (nếu chọn từ tab Công việc).
  IntColumn get taskScheduleId => integer().nullable()();

  /// Tag tập trung đã chọn (nếu chọn từ danh sách tag) — dùng cho focus trend.
  IntColumn get focusTagId => integer().nullable()();
}
