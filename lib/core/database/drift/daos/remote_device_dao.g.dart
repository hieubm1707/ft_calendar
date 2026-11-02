// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_device_dao.dart';

// ignore_for_file: type=lint
mixin _$RemoteDeviceDaoMixin on DatabaseAccessor<AppDatabase> {
  $RemoteDeviceTableTable get remoteDeviceTable =>
      attachedDatabase.remoteDeviceTable;
  RemoteDeviceDaoManager get managers => RemoteDeviceDaoManager(this);
}

class RemoteDeviceDaoManager {
  final _$RemoteDeviceDaoMixin _db;
  RemoteDeviceDaoManager(this._db);
  $$RemoteDeviceTableTableTableManager get remoteDeviceTable =>
      $$RemoteDeviceTableTableTableManager(
        _db.attachedDatabase,
        _db.remoteDeviceTable,
      );
}
