import 'package:injectable/injectable.dart';

import '../../../../core/database/drift/index.dart';
import '../../../../core/error/index.dart';

/// Truy cập DB cục bộ (Drift) cho kết quả gõ phím. Chỗ DUY NHẤT biết về Drift.
abstract class TypingLocalDataSource {
  Future<void> insertResult(TypingResultTableCompanion result);
  Future<List<TypingResultTableData>> getResults({
    required DateTime from,
    required DateTime to,
  });
  Future<void> deleteResult(int id);
}

@LazySingleton(as: TypingLocalDataSource)
class TypingDriftDataSource implements TypingLocalDataSource {
  final TypingDao _dao;

  TypingDriftDataSource(this._dao);

  @override
  Future<void> insertResult(TypingResultTableCompanion result) async {
    try {
      await _dao.insertResult(result);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<TypingResultTableData>> getResults({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      return await _dao.getResults(from: from, to: to);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<void> deleteResult(int id) async {
    try {
      await _dao.deleteResult(id);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
