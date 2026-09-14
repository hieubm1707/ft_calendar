import 'package:injectable/injectable.dart';


import '../../../../core/database/drift/index.dart';
import '../../domain/entities/remote_device.dart';
import '../../domain/repositories/remote_repository.dart';


@LazySingleton(as: RemoteRepository)
class RemoteRepositoryImpl implements RemoteRepository {

  final RemoteDeviceDao _remoteDeviceDao;

  RemoteRepositoryImpl(this._remoteDeviceDao);

  @override
  Stream<List<RemoteDevice>> watchAllDevices() {
    return _remoteDeviceDao.watchAllDevices().map((entries) {
      return entries
          .map((e) => RemoteDevice(
                id: e.id,
                name: e.name,
                type: RemoteType.fromCode(e.type),
                createdAt: e.createdAt,
              ))
          .toList();
    });
  }

  @override
  Future<void> addDevice({required String name, required RemoteType type}) async {
    await _remoteDeviceDao.insertDevice(
      RemoteDeviceTableCompanion.insert(
        name: name,
        type: type.code,
      ),
    );
  }

  @override
  Future<void> deleteDevice(int id) async {
    await _remoteDeviceDao.deleteDevice(id);
  }
}
