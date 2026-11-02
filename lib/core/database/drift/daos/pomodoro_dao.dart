import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/pomodoro_table.dart';

part 'pomodoro_dao.g.dart';

/// Truy vấn Drift cho phiên pomodoro. Chỉ SQL, không nghiệp vụ.
@DriftAccessor(tables: [PomodoroSessionTable])
class PomodoroDao extends DatabaseAccessor<AppDatabase>
    with _$PomodoroDaoMixin {
  PomodoroDao(super.db);

  Future<int> insertSession(PomodoroSessionTableCompanion session) {
    return into(pomodoroSessionTable).insert(session);
  }

  /// Phiên có [startedAt] trong [from, to), mới nhất trước.
  Future<List<PomodoroSessionTableData>> getSessions({
    required DateTime from,
    required DateTime to,
  }) {
    return (select(pomodoroSessionTable)
          ..where((t) =>
              t.startedAt.isBiggerOrEqualValue(from) &
              t.startedAt.isSmallerThanValue(to))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<void> deleteSession(int id) async {
    await (delete(pomodoroSessionTable)..where((t) => t.id.equals(id))).go();
  }
}
