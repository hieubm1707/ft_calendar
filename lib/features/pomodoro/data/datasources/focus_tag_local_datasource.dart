import 'package:injectable/injectable.dart';

import '../../../../core/database/drift/index.dart';
import '../../../../core/error/index.dart';

/// Truy cập DB cục bộ (Drift) cho tag tập trung.
abstract class FocusTagLocalDataSource {
  Future<List<FocusTagTableData>> getTags();
  Future<void> insertTag(FocusTagTableCompanion tag);
  Future<void> updateTag(int id, FocusTagTableCompanion tag);
  Future<void> deleteTag(int id);
}

@LazySingleton(as: FocusTagLocalDataSource)
class FocusTagDriftDataSource implements FocusTagLocalDataSource {
  final FocusTagDao _dao;

  FocusTagDriftDataSource(this._dao);

  @override
  Future<List<FocusTagTableData>> getTags() async {
    try {
      return await _dao.getTags();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> insertTag(FocusTagTableCompanion tag) async {
    try {
      await _dao.insertTag(tag);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> updateTag(int id, FocusTagTableCompanion tag) async {
    try {
      await _dao.updateTag(id, tag);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> deleteTag(int id) async {
    try {
      await _dao.deleteTag(id);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
