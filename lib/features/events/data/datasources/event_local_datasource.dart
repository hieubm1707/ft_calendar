import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/drift/app_database.dart';
import '../../../../core/database/drift/daos/event_dao.dart';
import '../../../../core/error/exceptions.dart';

/// Lớp truy cập DB cục bộ (Drift). Đây là chỗ DUY NHẤT biết về Drift.
/// Đổi sang DB khác sau này = viết implementation khác của interface này.
abstract class EventLocalDataSource {
  Future<List<EventTableData>> getScheduledEvents({DateTime? from, DateTime? to});
  Future<EventTableData> createEvent(EventTableCompanion event);
  Future<void> deleteEvent(int id);
}

@LazySingleton(as: EventLocalDataSource)
class EventDriftDataSource implements EventLocalDataSource {
  final EventDao _dao;

  EventDriftDataSource(this._dao);

  @override
  Future<List<EventTableData>> getScheduledEvents({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      return await _dao.getScheduledEvents(from: from, to: to);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<EventTableData> createEvent(EventTableCompanion event) async {
    try {
      return await _dao.createEvent(event);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> deleteEvent(int id) async {
    try {
      await _dao.deleteEvent(id);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
