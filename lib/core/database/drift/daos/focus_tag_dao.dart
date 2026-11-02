import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/focus_tag_table.dart';

part 'focus_tag_dao.g.dart';

/// Truy vấn Drift cho tag tập trung. Chỉ SQL, không nghiệp vụ.
@DriftAccessor(tables: [FocusTagTable])
class FocusTagDao extends DatabaseAccessor<AppDatabase>
    with _$FocusTagDaoMixin {
  FocusTagDao(super.db);

  Future<List<FocusTagTableData>> getTags() {
    return (select(focusTagTable)
          ..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .get();
  }

  Future<int> insertTag(FocusTagTableCompanion tag) {
    return into(focusTagTable).insert(tag);
  }

  Future<void> updateTag(int id, FocusTagTableCompanion tag) async {
    await (update(focusTagTable)..where((t) => t.id.equals(id))).write(tag);
  }

  Future<void> deleteTag(int id) async {
    await (delete(focusTagTable)..where((t) => t.id.equals(id))).go();
  }
}
