import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/hardware/ir_service.dart';
import '../../../../core/theme/index.dart';
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
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getDeviceIcon(widget.device.type),
            const SizedBox(width: 8),
            Text(
              widget.device.name,
              style: TextStyle(
                color: colors.textPrimary,
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
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
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
                          ? colors.accent
                          : colors.accent.withValues(alpha: 0.12),
                      boxShadow: _isTransmitting
                          ? [
                              BoxShadow(
                                color: colors.accent.withValues(alpha: 0.6),
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
                          color: _isTransmitting ? Colors.white : colors.accent,
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
                                    ? colors.success
                                    : colors.danger,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              _getStatusDetail(),
                              style: TextStyle(
                                color: colors.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'CMD: $_lastSignal',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Courier',
                          ),
                        ),
                        Text(
                          'HEX: $_hexCode',
                          style: TextStyle(
                            color: colors.warning,
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
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: colors.border, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
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
    final colors = context.colors;
    switch (type) {
      case RemoteType.tv:
        return Icon(Icons.tv, color: colors.accent);
      case RemoteType.airConditioner:
        return Icon(Icons.ac_unit, color: colors.info);
      case RemoteType.fan:
        return Icon(Icons.toys, color: colors.success);
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
    final colors = context.colors;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRoundButton(
              icon: Icons.power_settings_new,
              color: colors.danger,
              iconColor: Colors.white,
              onPressed: () {
                setState(() => _isPowerOn = !_isPowerOn);
                _sendSignal(_isPowerOn ? 'POWER ON' : 'POWER OFF', '0x20DF10EF');
              },
            ),
            _buildRoundButton(
              icon: Icons.volume_off,
              color: colors.surfaceAlt,
              iconColor: colors.textSecondary,
              onPressed: () => _sendSignal('MUTE', '0x20DF90AF'),
            ),
            _buildRoundButton(
              icon: Icons.input,
              color: colors.surfaceAlt,
              iconColor: colors.textSecondary,
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
    final colors = context.colors;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoundButton(
              icon: Icons.power_settings_new,
              color: colors.danger,
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
            color: colors.surfaceAlt,
            border: Border.all(color: colors.info, width: 3),
            boxShadow: [
              BoxShadow(
                color: colors.info.withValues(alpha: 0.15),
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
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Nhiệt độ',
                  style: TextStyle(color: colors.textMuted, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 28),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.info.withValues(alpha: 0.12),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              icon: Icon(Icons.keyboard_arrow_down, color: colors.info),
              label: Text('Giảm Temp', style: TextStyle(color: colors.info, fontWeight: FontWeight.bold)),
              onPressed: () {
                setState(() => _temp > 16 ? _temp-- : null);
                _sendSignal('TEMP DOWN', '0xAC108811');
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.danger.withValues(alpha: 0.12),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              icon: Icon(Icons.keyboard_arrow_up, color: colors.danger),
              label: Text('Tăng Temp', style: TextStyle(color: colors.danger, fontWeight: FontWeight.bold)),
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
    final colors = context.colors;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoundButton(
              icon: Icons.power_settings_new,
              color: colors.danger,
              iconColor: Colors.white,
              onPressed: () {
                setState(() => _isPowerOn = !_isPowerOn);
                _sendSignal(_isPowerOn ? 'FAN POWER ON' : 'FAN POWER OFF', '0xFA001122');
              },
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'Tốc Độ Gió',
          style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
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
                  color: isSelected ? colors.success : colors.surfaceAlt,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$speed',
                    style: TextStyle(
                      color: isSelected ? Colors.white : colors.textPrimary,
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
    final colors = context.colors;
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
              color: colors.shadow,
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
    final colors = context.colors;
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        shape: BoxShape.circle,
        border: Border.all(color: colors.border),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 4,
            child: IconButton(
              icon: Icon(Icons.arrow_drop_up, color: colors.textPrimary, size: 36),
              onPressed: () => _sendSignal('NAV UP', '0x20DF02FD'),
            ),
          ),
          Positioned(
            bottom: 4,
            child: IconButton(
              icon: Icon(Icons.arrow_drop_down, color: colors.textPrimary, size: 36),
              onPressed: () => _sendSignal('NAV DOWN', '0x20DF827D'),
            ),
          ),
          Positioned(
            left: 4,
            child: IconButton(
              icon: Icon(Icons.arrow_left, color: colors.textPrimary, size: 36),
              onPressed: () => _sendSignal('NAV LEFT', '0x20DFE01F'),
            ),
          ),
          Positioned(
            right: 4,
            child: IconButton(
              icon: Icon(Icons.arrow_right, color: colors.textPrimary, size: 36),
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
                color: colors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: colors.textDisabled),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text('OK',
                    style: TextStyle(
                        color: colors.textPrimary,
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
    final colors = context.colors;
    return Container(
      width: 50,
      height: 100,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onUp,
            child: SizedBox(
              width: 50,
              height: 36,
              child: Icon(Icons.add, color: colors.textPrimary, size: 18),
            ),
          ),
          Text(label,
              style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
          InkWell(
            onTap: onDown,
            child: SizedBox(
              width: 50,
              height: 36,
              child: Icon(Icons.remove, color: colors.textPrimary, size: 18),
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
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        height: 44,
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colors.textPrimary, size: 18),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(color: colors.textMuted, fontSize: 8, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

