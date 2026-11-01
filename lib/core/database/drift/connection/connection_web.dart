import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Web: dữ liệu lưu trong trình duyệt (OPFS hoặc IndexedDB, drift tự chọn).
/// `sqlite3.wasm` và `drift_worker.js` phải khớp phiên bản `sqlite3`/`drift`
/// trong pubspec.lock — nâng cấp package thì tải lại 2 file này vào `web/`.
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'ft_calender',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}
