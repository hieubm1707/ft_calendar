import 'package:drift/drift.dart';

/// Lịch task: 'dates' (1 hoặc nhiều ngày cụ thể) hoặc 'weekly' (lặp theo thứ).
/// Data class: `TaskScheduleTableData`, companion: `TaskScheduleTableCompanion`.
class TaskScheduleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get type => text()(); // 'dates' | 'weekly'
  TextColumn get datesCsv => text().nullable()(); // ISO yyyy-MM-dd, nối bằng ','
  IntColumn get weekdaysMask => integer().withDefault(const Constant(0))();
  DateTimeColumn get startDate => dateTime()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get color => integer().withDefault(const Constant(0xFF00B3A6))();
  DateTimeColumn get createdAt => dateTime()();

  /// Mô tả (tuỳ chọn).
  TextColumn get note => text().nullable()();

  /// Giờ trong ngày (phút từ 0h) — tuỳ chọn, null = không đặt giờ.
  IntColumn get minutesOfDay => integer().nullable()();
}

/// Trạng thái hoàn thành theo từng ngày (áp cho cả instance lặp).
class TaskCompletionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get scheduleId => integer()();
  DateTimeColumn get date => dateTime()(); // ngày đã chuẩn hoá (bỏ giờ)
  BoolColumn get done => boolean().withDefault(const Constant(false))();
}
