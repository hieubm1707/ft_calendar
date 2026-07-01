import 'package:drift/drift.dart';

/// Bảng lưu sự kiện. Data class sinh ra: `EventTableData`, companion: `EventTableCompanion`.
class EventTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  BoolColumn get isAllDay => boolean().withDefault(const Constant(false))();
}
