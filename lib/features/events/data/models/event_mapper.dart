import 'package:drift/drift.dart';

import '../../../../core/database/drift/index.dart';
import '../../../../core/domain/index.dart';

/// Cầu nối giữa row của Drift (EventTableData) và entity domain (Event).
extension EventTableDataMapper on EventTableData {
  Event toEntity() => Event(
    id: id,
    title: title,
    description: description,
    startTime: startTime,
    endTime: endTime,
    isAllDay: isAllDay,
  );
}

extension EventEntityMapper on Event {
  EventTableCompanion toCompanion() => EventTableCompanion(
    id: id == null ? const Value.absent() : Value(id!),
    title: Value(title),
    description: Value(description),
    startTime: Value(startTime),
    endTime: Value(endTime),
    isAllDay: Value(isAllDay),
  );
}
