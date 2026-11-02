import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/remote_device_table.dart';

part 'remote_device_dao.g.dart';

@DriftAccessor(tables: [RemoteDeviceTable])
class RemoteDeviceDao extends DatabaseAccessor<AppDatabase>
    with _$RemoteDeviceDaoMixin {
  RemoteDeviceDao(super.db);

  Future<List<RemoteDeviceEntry>> getAllDevices() =>
      (select(remoteDeviceTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  Stream<List<RemoteDeviceEntry>> watchAllDevices() =>
      (select(remoteDeviceTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  Future<int> insertDevice(RemoteDeviceTableCompanion entry) =>
      into(remoteDeviceTable).insert(entry);

  Future<int> deleteDevice(int id) =>
      (delete(remoteDeviceTable)..where((t) => t.id.equals(id))).go();
}
