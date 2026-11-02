import 'package:flutter/services.dart';

class IrService {
  static const MethodChannel _channel =
      MethodChannel('com.example.example_app/ir_emitter');

  /// Kiểm tra phần cứng xem thiết bị có mắt phát hồng ngoại (IR Blaster) hay không
  static Future<bool> hasIrEmitter() async {
    try {
      final bool hasIr = await _channel.invokeMethod('hasIrEmitter');
      return hasIr;
    } catch (_) {
      return false;
    }
  }

  /// Phát mã tín hiệu Hồng ngoại thực tế tới phần cứng
  static Future<bool> transmitHex(String hexCode, {int frequency = 38000}) async {
    try {
      final bool success = await _channel.invokeMethod('transmitHex', {
        'hexCode': hexCode,
        'frequency': frequency,
      });
      return success;
    } catch (e) {
      return false;
    }
  }
}
