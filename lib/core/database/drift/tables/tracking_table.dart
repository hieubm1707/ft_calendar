import 'package:drift/drift.dart';

/// Mục tiêu theo dõi (habit): lặp hằng ngày hoặc theo các thứ trong tuần.
/// Data class: `TrackingGoalTableData`, companion: `TrackingGoalTableCompanion`.
class TrackingGoalTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();

  /// Mô tả (tuỳ chọn).
  TextColumn get description => text().nullable()();

  /// Màu do người dùng chọn (ARGB).
  IntColumn get color => integer().withDefault(const Constant(0xFF3D6DF2))();

  /// Thứ áp dụng (bit weekday-1, Mon..Sun); 127 = hằng ngày.
  IntColumn get weekdaysMask => integer().withDefault(const Constant(127))();

  DateTimeColumn get startDate => dateTime()(); // ngày chuẩn hoá (bỏ giờ)
  DateTimeColumn get endDate => dateTime().nullable()();

  /// Giờ nhắc (phút từ 0h) nối bằng ',' — null/rỗng = không nhắc.
  TextColumn get remindersCsv => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
}

/// Lượt hoàn thành mục tiêu theo ngày — có dòng = đã hoàn thành.
class TrackingCheckinTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer()();
  DateTimeColumn get date => dateTime()(); // ngày chuẩn hoá (bỏ giờ)
}
