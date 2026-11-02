import 'package:injectable/injectable.dart';

import '../../../../core/database/drift/index.dart';
import '../../../../core/error/index.dart';

/// Truy cập DB cục bộ (Drift) cho gói nội dung người dùng import.
abstract class TypingContentPackDataSource {
  Future<List<TypingContentPackTableData>> getPacks(String language);
  Future<void> insertPack(TypingContentPackTableCompanion pack);
  Future<void> deletePack(int id);
}

@LazySingleton(as: TypingContentPackDataSource)
class TypingContentPackDriftDataSource implements TypingContentPackDataSource {
  final TypingContentDao _dao;

  TypingContentPackDriftDataSource(this._dao);

  @override
  Future<List<TypingContentPackTableData>> getPacks(String language) async {
    try {
      return await _dao.getPacks(language);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> insertPack(TypingContentPackTableCompanion pack) async {
    try {
      await _dao.insertPack(pack);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> deletePack(int id) async {
    try {
      await _dao.deletePack(id);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
