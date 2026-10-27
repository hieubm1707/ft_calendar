import 'dart:io' show Platform, exit;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:window_manager/window_manager.dart';

/// Điều khiển cửa sổ desktop (macOS): kích thước, luôn-trên-cùng, chế độ mini,
/// ẩn/hiện thay vì thoát khi bấm nút đóng (app sống tiếp ở menu bar).
///
/// Mọi thao tác đều no-op trên iOS/Android → tầng UI gọi thoải mái, không cần
/// rải `Platform.isMacOS` khắp nơi.
@lazySingleton
class DesktopWindowService with WindowListener {
  /// Kích thước cửa sổ thường và cửa sổ mini (đồng hồ nổi).
  static const Size normalSize = Size(520, 780);
  static const Size miniSize = Size(280, 330);

  /// Chỉ macOS: iOS/Android không có khái niệm cửa sổ.
  bool get isSupported => !kIsWeb && Platform.isMacOS;

  /// Đang ở chế độ mini (cửa sổ nhỏ chỉ hiện đồng hồ) hay không.
  ValueListenable<bool> get miniMode => _miniMode;
  final ValueNotifier<bool> _miniMode = ValueNotifier(false);

  /// Cửa sổ có đang ghim trên cùng hay không.
  ValueListenable<bool> get alwaysOnTop => _alwaysOnTop;
  final ValueNotifier<bool> _alwaysOnTop = ValueNotifier(false);

  /// Gọi trước `runApp` (window_manager yêu cầu vậy).
  Future<void> init() async {
    if (!isSupported) return;
    await windowManager.ensureInitialized();
    windowManager.addListener(this);
    await windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: normalSize,
        minimumSize: Size(360, 480),
        title: 'FT Calendar',
        center: true,
      ),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );
    // Bấm nút đóng → ẩn cửa sổ, đồng hồ vẫn chạy và hiện ở menu bar.
    await windowManager.setPreventClose(true);
  }

  /// Bật/tắt cửa sổ nổi nhỏ (chỉ đồng hồ) — tự ghim trên cùng khi bật.
  Future<void> setMiniMode(bool enabled) async {
    if (!isSupported || _miniMode.value == enabled) return;
    _miniMode.value = enabled;
    await windowManager.setSize(enabled ? miniSize : normalSize, animate: true);
    await setAlwaysOnTop(enabled);
    await showWindow();
  }

  Future<void> toggleMiniMode() => setMiniMode(!_miniMode.value);

  Future<void> setAlwaysOnTop(bool enabled) async {
    if (!isSupported || _alwaysOnTop.value == enabled) return;
    _alwaysOnTop.value = enabled;
    await windowManager.setAlwaysOnTop(enabled);
  }

  Future<void> toggleAlwaysOnTop() => setAlwaysOnTop(!_alwaysOnTop.value);

  /// Phóng cửa sổ ra toàn màn hình (đồng hồ tập trung toàn màn hình).
  Future<void> setFullScreen(bool enabled) async {
    if (!isSupported) return;
    await windowManager.setFullScreen(enabled);
  }

  Future<void> showWindow() async {
    if (!isSupported) return;
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> hideWindow() async {
    if (!isSupported) return;
    await windowManager.hide();
  }

  /// Thoát hẳn app (menu "Thoát" ở menu bar).
  Future<void> quit() async {
    if (!isSupported) return;
    await windowManager.setPreventClose(false);
    await windowManager.destroy();
    exit(0);
  }

  @override
  void onWindowClose() {
    hideWindow();
  }
}
