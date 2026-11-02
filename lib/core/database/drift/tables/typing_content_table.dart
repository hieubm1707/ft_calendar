import 'package:drift/drift.dart';

/// Một "gói nội dung" người dùng tự import (file JSON/CSV hoặc dán tay).
/// Nội dung có sẵn trong `assets/typing/` KHÔNG nằm ở đây — bảng này chỉ chứa
/// phần người dùng thêm vào, để gộp thêm lên trên kho có sẵn.
/// Data class: `TypingContentPackTableData`, companion: `TypingContentPackTableCompanion`.
class TypingContentPackTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Tên gói để nhận ra trong danh sách (thường là tên file).
  TextColumn get name => text().withLength(min: 1, max: 120)();

  /// Mã ngôn ngữ gói này thuộc về: 'en' | 'vi'.
  TextColumn get language => text().withLength(min: 2, max: 8)();

  /// Danh sách từ, lưu dạng chuỗi JSON (mảng chuỗi).
  TextColumn get wordsJson => text().withDefault(const Constant('[]'))();

  /// Danh sách đoạn văn, lưu dạng chuỗi JSON (mảng chuỗi).
  TextColumn get paragraphsJson => text().withDefault(const Constant('[]'))();

  DateTimeColumn get addedAt => dateTime()();
}
