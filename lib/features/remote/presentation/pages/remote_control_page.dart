import 'package:flutter/material.dart';
import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
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
        title: Text('Xoá Remote', style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        content: Text(
          'Bạn có chắc chắn muốn xoá "${device.name}" khỏi danh sách?',
          style: TextStyle(color: context.colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Hủy', style: TextStyle(color: context.colors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.danger,
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
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings_remote, color: colors.accent),
            const SizedBox(width: 8),
            Text(
              'Danh Sách Remote',
              style: TextStyle(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: colors.accent, size: 28),
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
            return Center(
              child: CircularProgressIndicator(color: colors.accent),
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
                      color: colors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.settings_remote_outlined,
                      size: 64,
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Chưa có Remote nào được kết nối',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bấm nút bên dưới để thêm TV, Máy lạnh hoặc Quạt',
                    style: TextStyle(color: colors.textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accent,
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
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
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
          style: TextStyle(
            color: colors.textPrimary,

            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Loại: ${device.type.displayName}',
          style: TextStyle(color: colors.textMuted, fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete_outline, color: colors.textDisabled),
              onPressed: () => _deleteDevice(device),
            ),
            Icon(Icons.chevron_right, color: colors.textDisabled),
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
    final colors = context.colors;
    switch (type) {
      case RemoteType.tv:
        return colors.accent;
      case RemoteType.airConditioner:
        return colors.typing;
      case RemoteType.fan:
        return colors.success;
    }
  }
}
