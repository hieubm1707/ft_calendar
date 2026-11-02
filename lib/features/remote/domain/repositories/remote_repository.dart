import '../../domain/entities/remote_device.dart';

abstract class RemoteRepository {
  Stream<List<RemoteDevice>> watchAllDevices();
  Future<void> addDevice({required String name, required RemoteType type});
  Future<void> deleteDevice(int id);
}
