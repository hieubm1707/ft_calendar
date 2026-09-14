import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/hardware/ir_service.dart';
import '../../domain/entities/remote_device.dart';


class DeviceDetailRemotePage extends StatefulWidget {
  final RemoteDevice device;

  const DeviceDetailRemotePage({super.key, required this.device});

  @override
  State<DeviceDetailRemotePage> createState() => _DeviceDetailRemotePageState();
}

class _DeviceDetailRemotePageState extends State<DeviceDetailRemotePage> {
  bool _isPowerOn = true;
  bool _isTransmitting = false;
  String _lastSignal = 'READY';
  String _hexCode = '0x00000000';
  int _volume = 15;
  int _channel = 1;
  int _temp = 24; // Dành cho máy lạnh
  int _fanSpeed = 1; // Dành cho quạt

  void _sendSignal(String command, String code) async {
    if (!_isPowerOn && command != 'POWER') return;

    HapticFeedback.lightImpact();
    setState(() {
      _isTransmitting = true;
      _lastSignal = command;
      _hexCode = code;
    });

    // Phát xung hồng ngoại thật ra mắt phát IR của điện thoại
    await IrService.transmitHex(code);

    if (mounted) {
      setState(() {
        _isTransmitting = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2), // Light theme đồng bộ
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2F3E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getDeviceIcon(widget.device.type),
            const SizedBox(width: 8),
            Text(
              widget.device.name,
              style: const TextStyle(
                color: Color(0xFF2C2F3E),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Status Bar & IR Indicator (Light Mode)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEFEFF4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isTransmitting
                          ? const Color(0xFFFF2A55)
                          : const Color(0xFFFFEBEE),
                      boxShadow: _isTransmitting
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFF2A55).withValues(alpha: 0.6),
                                blurRadius: 12,
                                spreadRadius: 4,
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isTransmitting ? Colors.white : const Color(0xFFFF5252),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isPowerOn ? 'STATUS: ONLINE' : 'STATUS: OFF',
                              style: TextStyle(
                                color: _isPowerOn
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFC62828),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              _getStatusDetail(),
                              style: const TextStyle(
                                color: Color(0xFF8E8E93),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'CMD: $_lastSignal',
                          style: const TextStyle(
                            color: Color(0xFF2C2F3E),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Courier',
                          ),
                        ),
                        Text(
                          'HEX: $_hexCode',
                          style: const TextStyle(
                            color: Color(0xFFE65100),
                            fontSize: 12,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Specific Remote Body Controls (Light Mode)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFFEFEFF4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: _buildRemoteBodyForType(widget.device.type),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }


  Widget _getDeviceIcon(RemoteType type) {
    switch (type) {
      case RemoteType.tv:
        return const Icon(Icons.tv, color: Color(0xFFFF5252));
      case RemoteType.airConditioner:
        return const Icon(Icons.ac_unit, color: Color(0xFF448AFF));
      case RemoteType.fan:
        return const Icon(Icons.toys, color: Color(0xFF69F0AE));
    }
  }

  String _getStatusDetail() {
    switch (widget.device.type) {
      case RemoteType.tv:
        return 'CH: $_channel | VOL: $_volume';
      case RemoteType.airConditioner:
        return 'TEMP: $_temp°C';
      case RemoteType.fan:
        return 'SPEED: Level $_fanSpeed';
    }
  }

  Widget _buildRemoteBodyForType(RemoteType type) {
    switch (type) {
      case RemoteType.tv:
        return _buildTVControls();
      case RemoteType.airConditioner:
        return _buildAirConditionerControls();
      case RemoteType.fan:
        return _buildFanControls();
    }
  }

  // --- TV CONTROLS ---
  Widget _buildTVControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRoundButton(
              icon: Icons.power_settings_new,
              color: const Color(0xFFE53935),
              iconColor: Colors.white,
              onPressed: () {
                setState(() => _isPowerOn = !_isPowerOn);
                _sendSignal(_isPowerOn ? 'POWER ON' : 'POWER OFF', '0x20DF10EF');
              },
            ),
            _buildRoundButton(
              icon: Icons.volume_off,
              color: const Color(0xFFF0F0F3),
              iconColor: const Color(0xFF5A5C69),
              onPressed: () => _sendSignal('MUTE', '0x20DF90AF'),
            ),
            _buildRoundButton(
              icon: Icons.input,
              color: const Color(0xFFF0F0F3),
              iconColor: const Color(0xFF5A5C69),
              onPressed: () => _sendSignal('INPUT', '0x20DFF00F'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildDPad(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRockerControl(
              label: 'VOL',
              onUp: () {
                setState(() => _volume < 100 ? _volume++ : null);
                _sendSignal('VOL +', '0x20DF40BF');
              },
              onDown: () {
                setState(() => _volume > 0 ? _volume-- : null);
                _sendSignal('VOL -', '0x20DFC03F');
              },
            ),
            Column(
              children: [
                _buildSmallButton(
                  icon: Icons.home,
                  label: 'HOME',
                  onTap: () => _sendSignal('HOME', '0x20DF32CD'),
                ),
                const SizedBox(height: 12),
                _buildSmallButton(
                  icon: Icons.arrow_back,
                  label: 'BACK',
                  onTap: () => _sendSignal('BACK', '0x20DF14EB'),
                ),
              ],
            ),
            _buildRockerControl(
              label: 'CH',
              onUp: () {
                setState(() => _channel++);
                _sendSignal('CH +', '0x20DF00FF');
              },
              onDown: () {
                setState(() => _channel > 1 ? _channel-- : null);
                _sendSignal('CH -', '0x20DF807F');
              },
            ),
          ],
        ),
      ],
    );
  }

  // --- AIR CONDITIONER CONTROLS ---
  Widget _buildAirConditionerControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoundButton(
              icon: Icons.power_settings_new,
              color: const Color(0xFFE53935),
              iconColor: Colors.white,
              onPressed: () {
                setState(() => _isPowerOn = !_isPowerOn);
                _sendSignal(_isPowerOn ? 'AC POWER ON' : 'AC POWER OFF', '0xAC1000FE');
              },
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Temperature Dial / Display (Light Mode)
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF9F9FB),
            border: Border.all(color: const Color(0xFF448AFF), width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF448AFF).withValues(alpha: 0.15),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_temp°C',
                style: const TextStyle(
                  color: Color(0xFF2C2F3E),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Nhiệt độ',
                  style: TextStyle(color: Color(0xFF8E8E93), fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 28),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE3F2FD),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1E88E5)),
              label: const Text('Giảm Temp', style: TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.bold)),
              onPressed: () {
                setState(() => _temp > 16 ? _temp-- : null);
                _sendSignal('TEMP DOWN', '0xAC108811');
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEBEE),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              icon: const Icon(Icons.keyboard_arrow_up, color: Color(0xFFE53935)),
              label: const Text('Tăng Temp', style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold)),
              onPressed: () {
                setState(() => _temp < 30 ? _temp++ : null);
                _sendSignal('TEMP UP', '0xAC108822');
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSmallButton(
              icon: Icons.air,
              label: 'SWING',
              onTap: () => _sendSignal('SWING', '0xAC107799'),
            ),
            _buildSmallButton(
              icon: Icons.speed,
              label: 'FAN SPEED',
              onTap: () => _sendSignal('FAN SPEED', '0xAC105544'),
            ),
            _buildSmallButton(
              icon: Icons.timer,
              label: 'TIMER',
              onTap: () => _sendSignal('TIMER 1H', '0xAC103322'),
            ),
          ],
        ),
      ],
    );
  }

  // --- FAN CONTROLS ---
  Widget _buildFanControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoundButton(
              icon: Icons.power_settings_new,
              color: const Color(0xFFE53935),
              iconColor: Colors.white,
              onPressed: () {
                setState(() => _isPowerOn = !_isPowerOn);
                _sendSignal(_isPowerOn ? 'FAN POWER ON' : 'FAN POWER OFF', '0xFA001122');
              },
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'Tốc Độ Gió',
          style: TextStyle(color: Color(0xFF2C2F3E), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [1, 2, 3].map((speed) {
            final isSelected = _fanSpeed == speed;
            return InkWell(
              onTap: () {
                setState(() => _fanSpeed = speed);
                _sendSignal('FAN SPEED $speed', '0xFA00000$speed');
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF00C853) : const Color(0xFFF0F0F3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$speed',
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF2C2F3E),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSmallButton(
              icon: Icons.sync,
              label: 'XOAY / SWING',
              onTap: () => _sendSignal('FAN SWING', '0xFA004455'),
            ),
            _buildSmallButton(
              icon: Icons.timer,
              label: 'HẸN GIỜ',
              onTap: () => _sendSignal('FAN TIMER', '0xFA006677'),
            ),
          ],
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildRoundButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }

  Widget _buildDPad() {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F3),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE0E0E6)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 4,
            child: IconButton(
              icon: const Icon(Icons.arrow_drop_up, color: Color(0xFF2C2F3E), size: 36),
              onPressed: () => _sendSignal('NAV UP', '0x20DF02FD'),
            ),
          ),
          Positioned(
            bottom: 4,
            child: IconButton(
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2C2F3E), size: 36),
              onPressed: () => _sendSignal('NAV DOWN', '0x20DF827D'),
            ),
          ),
          Positioned(
            left: 4,
            child: IconButton(
              icon: const Icon(Icons.arrow_left, color: Color(0xFF2C2F3E), size: 36),
              onPressed: () => _sendSignal('NAV LEFT', '0x20DFE01F'),
            ),
          ),
          Positioned(
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.arrow_right, color: Color(0xFF2C2F3E), size: 36),
              onPressed: () => _sendSignal('NAV RIGHT', '0x20DF609F'),
            ),
          ),
          InkWell(
            onTap: () => _sendSignal('OK', '0x20DF22DD'),
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD1D1D6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text('OK',
                    style: TextStyle(
                        color: Color(0xFF2C2F3E),
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRockerControl({
    required String label,
    required VoidCallback onUp,
    required VoidCallback onDown,
  }) {
    return Container(
      width: 50,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFE0E0E6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onUp,
            child: const SizedBox(
              width: 50,
              height: 36,
              child: Icon(Icons.add, color: Color(0xFF2C2F3E), size: 18),
            ),
          ),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
          InkWell(
            onTap: onDown,
            child: const SizedBox(
              width: 50,
              height: 36,
              child: Icon(Icons.remove, color: Color(0xFF2C2F3E), size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E6)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF2C2F3E), size: 18),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 8, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

