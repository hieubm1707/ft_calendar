import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/hardware/ir_service.dart';
import '../../domain/entities/remote_brand_data.dart';
import '../../domain/entities/remote_device.dart';

/// 1. Dialog chọn Loại thiết bị (TV, Máy lạnh, Quạt) - Light Mode
class SelectDeviceTypeDialog extends StatelessWidget {
  final Function(RemoteType type) onTypeSelected;

  const SelectDeviceTypeDialog({super.key, required this.onTypeSelected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chọn Loại Thiết Bị',
                  style: TextStyle(
                    color: Color(0xFF2C2F3E),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF8E8E93)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(color: Color(0xFFEFEFF4)),
            const SizedBox(height: 12),
            _buildTypeTile(
              context: context,
              type: RemoteType.tv,
              icon: Icons.tv,
              color: const Color(0xFFFF5252),
            ),
            const SizedBox(height: 10),
            _buildTypeTile(
              context: context,
              type: RemoteType.airConditioner,
              icon: Icons.ac_unit,
              color: const Color(0xFF448AFF),
            ),
            const SizedBox(height: 10),
            _buildTypeTile(
              context: context,
              type: RemoteType.fan,
              icon: Icons.toys,
              color: const Color(0xFF00C853),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeTile({
    required BuildContext context,
    required RemoteType type,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTypeSelected(type);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9FB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFEFF4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.displayName,
                    style: const TextStyle(
                      color: Color(0xFF2C2F3E),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Xem danh sách hãng / Quét OEM',
                    style: TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFC7C7CC)),
          ],
        ),
      ),
    );
  }
}

/// 2. Modal BottomSheet cuộn chọn Thương Hiệu (Brand) - Light Mode
class SelectBrandBottomSheet extends StatelessWidget {
  final RemoteType type;
  final Function(BrandInfo brand) onBrandSelected;

  const SelectBrandBottomSheet({
    super.key,
    required this.type,
    required this.onBrandSelected,
  });

  @override
  Widget build(BuildContext context) {
    final brands = RemoteBrandData.brandsByType[type.code] ?? [];

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D1D6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chọn Thương Hiệu ${type.displayName}',
                      style: const TextStyle(
                        color: Color(0xFF2C2F3E),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF8E8E93)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFEFEFF4)),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    final isAutoScan = brand.hexCode == 'AUTO_SCAN';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          onBrandSelected(brand);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isAutoScan
                                ? const Color(0xFFF3E5F5)
                                : const Color(0xFFF9F9FB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isAutoScan
                                  ? const Color(0xFFCE93D8)
                                  : const Color(0xFFEFEFF4),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    brand.name,
                                    style: TextStyle(
                                      color: isAutoScan
                                          ? const Color(0xFF7B1FA2)
                                          : const Color(0xFF2C2F3E),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Giao thức: ${brand.protocol}',
                                    style: const TextStyle(
                                        color: Color(0xFF8E8E93), fontSize: 12),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                ),
                                child: Text(
                                  isAutoScan ? 'AUTOSCAN' : brand.hexCode,
                                  style: TextStyle(
                                    color: isAutoScan
                                        ? const Color(0xFF8E24AA)
                                        : const Color(0xFFF57C00),
                                    fontFamily: 'Courier',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 3. Dialog Thử nghiệm tín hiệu IR & Đặt tên - Light Mode
class TestIrSignalDialog extends StatefulWidget {
  final RemoteType type;
  final BrandInfo brand;
  final Function(String name, RemoteType type) onDeviceSaved;

  const TestIrSignalDialog({
    super.key,
    required this.type,
    required this.brand,
    required this.onDeviceSaved,
  });

  @override
  State<TestIrSignalDialog> createState() => _TestIrSignalDialogState();
}

class _TestIrSignalDialogState extends State<TestIrSignalDialog> {
  int _step = 1;
  late bool _isAutoScanMode;
  int _scanIndex = 0;
  bool _isTransmitting = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isAutoScanMode = widget.brand.hexCode == 'AUTO_SCAN';
    _nameController.text = _isAutoScanMode
        ? 'Quạt OEM'
        : '${widget.brand.name} ${widget.type.displayName}';
  }

  String get _currentHexCode {
    if (_isAutoScanMode) {
      return RemoteBrandData.genericAutoScanCodes[_scanIndex];
    }
    return widget.brand.hexCode;
  }

  void _testPowerSignal() async {
    HapticFeedback.heavyImpact();
    setState(() {
      _isTransmitting = true;
    });

    await IrService.transmitHex(_currentHexCode);

    if (mounted) {
      setState(() {
        _isTransmitting = false;
      });
    }
  }

  void _nextScanCode() {
    if (_scanIndex < RemoteBrandData.genericAutoScanCodes.length - 1) {
      setState(() {
        _scanIndex++;
        _nameController.text = 'Quạt OEM (#${_scanIndex + 1})';
      });
      _testPowerSignal();
    } else {
      setState(() {
        _step = 3;
      });
    }
  }

  void _submitDevice() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    widget.onDeviceSaved(name, widget.type);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _step == 1
                        ? (_isAutoScanMode ? 'Quét 20 Mã Tự Động' : 'Kiểm Tra Mã IR')
                        : (_step == 2 ? 'Đặt Tên Remote' : 'Không Thấy Mã Khớp'),
                    style: const TextStyle(
                      color: Color(0xFF2C2F3E),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF8E8E93)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFEFEFF4)),
              const SizedBox(height: 12),

              if (_step == 1) ...[
                if (_isAutoScanMode) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'QUÉT MÃ MẪU (${_scanIndex + 1}/20)',
                      style: const TextStyle(
                        color: Color(0xFF7B1FA2),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  _isAutoScanMode
                      ? 'Hướng mắt IR về ${widget.type.displayName} và bấm nút phát thử mã #${_scanIndex + 1}:'
                      : 'Thử phát mã hồng ngoại $_currentHexCode (${widget.brand.name}) tới thiết bị:',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF5A5C69), fontSize: 14),
                ),
                const SizedBox(height: 20),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isTransmitting
                        ? const Color(0xFFFF2A55)
                        : const Color(0xFFFFEBEE),
                    boxShadow: _isTransmitting
                        ? [
                            BoxShadow(
                              color: const Color(0xFFFF2A55).withValues(alpha: 0.6),
                              blurRadius: 18,
                              spreadRadius: 6,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.sensors,
                      color: _isTransmitting ? Colors.white : const Color(0xFFFF5252),
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                InkWell(
                  onTap: _testPowerSignal,
                  borderRadius: BorderRadius.circular(44),
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE53935).withValues(alpha: 0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.power_settings_new,
                        color: Colors.white, size: 44),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mã phát IR: $_currentHexCode',
                  style: const TextStyle(color: Color(0xFFE65100), fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Thiết bị của bạn có phản hồi (bật/tắt) không?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF2C2F3E),
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD1D1D6)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          if (_isAutoScanMode) {
                            _nextScanCode();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          _isAutoScanMode
                              ? 'Mã kế tiếp (${_scanIndex + 1}/20)'
                              : 'Không phản hồi',
                          style: const TextStyle(color: Color(0xFF5A5C69)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            _step = 2;
                          });
                        },
                        child: const Text('Có, thành công',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],

              if (_step == 2) ...[
                const Text(
                  'Khớp mã hồng ngoại thành công! Nhập tên ghi nhớ:',
                  style: TextStyle(color: Color(0xFF5A5C69), fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  style: const TextStyle(color: Color(0xFF2C2F3E)),
                  decoration: InputDecoration(
                    labelText: 'Tên thiết bị',
                    labelStyle: const TextStyle(color: Color(0xFF8E8E93)),
                    filled: true,
                    fillColor: const Color(0xFFF9F9FB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEFEFF4)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEFEFF4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF5252)),
                    ),
                    prefixIcon: const Icon(Icons.edit, color: Color(0xFFFF5252)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5252),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitDevice,
                    child: const Text(
                      'Lưu Remote',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],

              if (_step == 3) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sentiment_dissatisfied,
                      color: Color(0xFFE53935), size: 48),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Đã thử hết 20 mẫu mã phổ thông',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2C2F3E),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Rất tiếc thiết bị của bạn chưa nằm trong tập 20 mã quét phổ thông này.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E8E93),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Đóng',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
