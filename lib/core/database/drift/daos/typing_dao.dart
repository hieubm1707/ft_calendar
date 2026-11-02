import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/typing_table.dart';

part 'typing_dao.g.dart';

/// Truy vấn Drift cho kết quả gõ phím. Chỉ SQL, không nghiệp vụ.
@DriftAccessor(tables: [TypingResultTable])
class TypingDao extends DatabaseAccessor<AppDatabase> with _$TypingDaoMixin {
  TypingDao(super.db);

  Future<int> insertResult(TypingResultTableCompanion result) {
    return into(typingResultTable).insert(result);
  }

  /// Kết quả có [takenAt] trong [from, to), mới nhất trước.
  Future<List<TypingResultTableData>> getResults({
    required DateTime from,
    required DateTime to,
  }) {
    return (select(typingResultTable)
          ..where((t) =>
              t.takenAt.isBiggerOrEqualValue(from) &
              t.takenAt.isSmallerThanValue(to))
          ..orderBy([(t) => OrderingTerm.desc(t.takenAt)]))
        .get();
  }

  Future<void> deleteResult(int id) async {
    await (delete(typingResultTable)..where((t) => t.id.equals(id))).go();
  }
}
