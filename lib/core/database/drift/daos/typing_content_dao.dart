import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/typing_content_table.dart';

part 'typing_content_dao.g.dart';

/// Truy vấn Drift cho gói nội dung gõ phím do người dùng import.
@DriftAccessor(tables: [TypingContentPackTable])
class TypingContentDao extends DatabaseAccessor<AppDatabase>
    with _$TypingContentDaoMixin {
  TypingContentDao(super.db);

  /// Gói của một ngôn ngữ, mới thêm đứng trước.
  Future<List<TypingContentPackTableData>> getPacks(String language) {
    return (select(typingContentPackTable)
          ..where((t) => t.language.equals(language))
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .get();
  }

  Future<int> insertPack(TypingContentPackTableCompanion pack) {
    return into(typingContentPackTable).insert(pack);
  }

  Future<void> deletePack(int id) async {
    await (delete(typingContentPackTable)..where((t) => t.id.equals(id))).go();
  }
}
