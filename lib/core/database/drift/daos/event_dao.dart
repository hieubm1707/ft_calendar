import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/event_table.dart';

part 'event_dao.g.dart';

/// Truy vấn Drift cho bảng EventTable. Chỉ chứa SQL, không chứa nghiệp vụ.
@DriftAccessor(tables: [EventTable])
class EventDao extends DatabaseAccessor<AppDatabase> with _$EventDaoMixin {
  EventDao(super.db);

  Future<List<EventTableData>> getScheduledEvents({
    DateTime? from,
    DateTime? to,
  }) {
    final query = select(eventTable)
      ..orderBy([(t) => OrderingTerm.asc(t.startTime)]);
    if (from != null) {
      query.where((t) => t.startTime.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where((t) => t.startTime.isSmallerOrEqualValue(to));
    }
    return query.get();
  }

  Future<EventTableData> createEvent(EventTableCompanion event) {
    return into(eventTable).insertReturning(event);
  }

  Future<bool> updateEvent(EventTableCompanion event) {
    return update(eventTable).replace(event);
  }

  Future<int> deleteEvent(int id) {
    return (delete(eventTable)..where((t) => t.id.equals(id))).go();
  }
}
