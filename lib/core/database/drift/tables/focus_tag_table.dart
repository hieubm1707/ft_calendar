import 'package:drift/drift.dart';

/// Tag tập trung: nhãn có sẵn để chọn nhanh (kèm độ dài phiên gợi ý).
/// Người dùng sửa được tên/số phút, thêm tag mới, xoá tag.
/// Data class: `FocusTagTableData`, companion: `FocusTagTableCompanion`.
class FocusTagTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 60)();

  /// Độ dài phiên focus gợi ý (phút).
  IntColumn get minutes => integer()();

  /// Màu hiển thị (ARGB) — dùng cho chip và biểu đồ focus trend.
  IntColumn get color => integer().withDefault(const Constant(0xFF00B3A6))();

  /// Biểu tượng dạng emoji (không dùng IconData để không phá tree-shake icons).
  TextColumn get emoji => text().nullable()();

  /// Thứ tự hiển thị; nhỏ hơn đứng trước.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
