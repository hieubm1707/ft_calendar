import 'package:flutter/material.dart';
import '../../../../core/di/index.dart';
import '../../domain/entities/remote_device.dart';
import '../../domain/repositories/remote_repository.dart';
import 'add_remote_flow_dialog.dart';
import 'device_detail_remote_page.dart';

class RemoteControlPage extends StatefulWidget {
  const RemoteControlPage({super.key});

  @override
  State<RemoteControlPage> createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends State<RemoteControlPage> {
  final RemoteRepository _remoteRepository = getIt<RemoteRepository>();

  void _openAddRemoteDialog() {
    // 1. Popup Chọn Loại Thiết Bị
    showDialog(
      context: context,
      builder: (dialogContext) => SelectDeviceTypeDialog(
        onTypeSelected: (type) {
          // 2. BottomSheet Cuộn Chọn Hãng Thương Hiệu
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (sheetContext) => SelectBrandBottomSheet(
              type: type,
              onBrandSelected: (brand) {
                // 3. Dialog Phát Thử Tín Hiệu Hồng Ngoại & Lưu Tên
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (testDialogContext) => TestIrSignalDialog(
                    type: type,
                    brand: brand,
                    onDeviceSaved: (name, deviceType) async {
                      await _remoteRepository.addDevice(
                          name: name, type: deviceType);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }


  void _deleteDevice(RemoteDevice device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text('Xoá Remote', style: TextStyle(color: Color(0xFF2C2F3E), fontWeight: FontWeight.bold)),
        content: Text(
          'Bạn có chắc chắn muốn xoá "${device.name}" khỏi danh sách?',
          style: const TextStyle(color: Color(0xFF5A5C69)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy', style: TextStyle(color: Color(0xFF8E8E93))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              elevation: 0,
            ),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await _remoteRepository.deleteDevice(device.id);
              navigator.pop();
            },
            child: const Text('Xoá', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2), // Light theme background đồng bộ
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings_remote, color: Color(0xFFFF5252)),
            SizedBox(width: 8),
            Text(
              'Danh Sách Remote',
              style: TextStyle(
                color: Color(0xFF2C2F3E),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFFFF5252), size: 28),
            onPressed: _openAddRemoteDialog,
            tooltip: 'Thêm Remote Mới',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<RemoteDevice>>(
        stream: _remoteRepository.watchAllDevices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF5252)),
            );
          }

          final devices = snapshot.data ?? [];

          if (devices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.settings_remote_outlined,
                      size: 64,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Chưa có Remote nào được kết nối',
                    style: TextStyle(
                      color: Color(0xFF2C2F3E),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bấm nút bên dưới để thêm TV, Máy lạnh hoặc Quạt',
                    style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5252),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 1,
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Thêm Remote Mới',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: _openAddRemoteDialog,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return _buildDeviceCard(device);
            },
          );
        },
      ),
    );
  }

  Widget _buildDeviceCard(RemoteDevice device) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFF4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getDeviceColor(device.type).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(_getDeviceIconData(device.type),
              color: _getDeviceColor(device.type), size: 28),
        ),
        title: Text(
          device.name,
          style: const TextStyle(
            color: Color(0xFF2C2F3E),

            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Loại: ${device.type.displayName}',
          style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFC7C7CC)),
              onPressed: () => _deleteDevice(device),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFC7C7CC)),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DeviceDetailRemotePage(device: device),
            ),
          );
        },
      ),
    );
  }


  IconData _getDeviceIconData(RemoteType type) {
    switch (type) {
      case RemoteType.tv:
        return Icons.tv;
      case RemoteType.airConditioner:
        return Icons.ac_unit;
      case RemoteType.fan:
        return Icons.toys;
    }
  }

  Color _getDeviceColor(RemoteType type) {
    switch (type) {
      case RemoteType.tv:
        return const Color(0xFFFF5252);
      case RemoteType.airConditioner:
        return const Color(0xFF448AFF);
      case RemoteType.fan:
        return const Color(0xFF69F0AE);
    }
  }
}
