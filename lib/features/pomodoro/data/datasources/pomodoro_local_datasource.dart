import 'package:injectable/injectable.dart';

import '../../../../core/database/drift/index.dart';
import '../../../../core/error/index.dart';

/// Truy cập DB cục bộ (Drift) cho pomodoro. Chỗ DUY NHẤT biết về Drift.
abstract class PomodoroLocalDataSource {
  Future<void> insertSession(PomodoroSessionTableCompanion session);
  Future<List<PomodoroSessionTableData>> getSessions({
    required DateTime from,
    required DateTime to,
  });
  Future<void> deleteSession(int id);
}

@LazySingleton(as: PomodoroLocalDataSource)
class PomodoroDriftDataSource implements PomodoroLocalDataSource {
  final PomodoroDao _dao;

  PomodoroDriftDataSource(this._dao);

  @override
  Future<void> insertSession(PomodoroSessionTableCompanion session) async {
    try {
      await _dao.insertSession(session);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<PomodoroSessionTableData>> getSessions({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      return await _dao.getSessions(from: from, to: to);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> deleteSession(int id) async {
    try {
      await _dao.deleteSession(id);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
