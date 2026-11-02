import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tray_manager/tray_manager.dart';

import '../../../../core/desktop/index.dart';
import '../cubit/pomodoro_cubit.dart';

/// Đưa đồng hồ pomodoro lên menu bar macOS: luôn thấy thời gian còn lại và
/// điều khiển được (bắt đầu / tạm dừng / dừng / bỏ qua) kể cả khi ẩn cửa sổ.
@lazySingleton
class PomodoroTrayController with TrayListener {
  final PomodoroCubit _cubit;
  final DesktopWindowService _window;

  PomodoroTrayController(this._cubit, this._window);

  static const _iconPath = 'assets/tray/tray_icon.png';

  StreamSubscription<PomodoroState>? _sub;

  /// Chữ và menu đang hiển thị — chỉ gọi native khi thật sự đổi.
  String? _shownTitle;
  String? _shownMenuKey;

  /// Menu bar chỉ có trên macOS.
  bool get _supported => !kIsWeb && Platform.isMacOS;

  /// Gọi sau frame đầu (setIcon cần đọc asset qua rootBundle).
  Future<void> start() async {
    if (!_supported) return;
    trayManager.addListener(this);
    await trayManager.setIcon(_iconPath, isTemplate: true);
    await _render(_cubit.state);
    _sub = _cubit.stream.listen(_render);
    _window.miniMode.addListener(_onWindowFlagChanged);
  }

  Future<void> dispose() async {
    if (!_supported) return;
    _window.miniMode.removeListener(_onWindowFlagChanged);
    await _sub?.cancel();
    _sub = null;
    trayManager.removeListener(this);
    await trayManager.destroy();
  }

  void _onWindowFlagChanged() => _render(_cubit.state);

  // ── Vẽ menu bar ────────────────────────────────────────────────────────

  Future<void> _render(PomodoroState state) async {
    final title = _titleFor(state);
    if (title != _shownTitle) {
      _shownTitle = title;
      await trayManager.setTitle(title);
      await trayManager.setToolTip(_toolTipFor(state));
    }

    // Menu chỉ dựng lại khi phần "cấu trúc" đổi — không dựng lại mỗi giây.
    final menuKey = '${state.phase}|${state.runStatus}|${state.label}'
        '|${_window.miniMode.value}';
    if (menuKey == _shownMenuKey) return;
    _shownMenuKey = menuKey;
    await trayManager.setContextMenu(_buildMenu(state));
  }

  /// Đang chạy/tạm dừng thì hiện mm:ss; rảnh thì để trống cho gọn menu bar.
  String _titleFor(PomodoroState state) {
    if (state.isIdle) return '';
    final prefix = state.isRunning ? '' : '⏸ ';
    return '$prefix${state.remainingLabel}';
  }

  String _toolTipFor(PomodoroState state) {
    final phase = _phaseLabel(state.phase);
    final target = state.label;
    return target == null ? phase : '$phase · $target';
  }

  Menu _buildMenu(PomodoroState state) {
    final header = _toolTipFor(state);
    return Menu(
      items: [
        MenuItem(label: header, disabled: true),
        MenuItem.separator(),
        if (state.isRunning)
          MenuItem(label: 'Tạm dừng', onClick: (_) => _cubit.pause())
        else
          MenuItem(
            label: state.isIdle ? 'Bắt đầu' : 'Tiếp tục',
            onClick: (_) => _cubit.start(),
          ),
        MenuItem(
          label: 'Dừng',
          disabled: state.isIdle,
          onClick: (_) => _cubit.stop(),
        ),
        MenuItem(label: 'Bỏ qua giai đoạn', onClick: (_) => _cubit.skip()),
        MenuItem.separator(),
        MenuItem.checkbox(
          label: 'Cửa sổ nổi nhỏ',
          checked: _window.miniMode.value,
          onClick: (_) => _window.toggleMiniMode(),
        ),
        MenuItem(label: 'Hiện cửa sổ', onClick: (_) => _window.showWindow()),
        MenuItem.separator(),
        MenuItem(label: 'Thoát', onClick: (_) => _window.quit()),
      ],
    );
  }

  String _phaseLabel(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.focus:
        return 'Tập trung';
      case PomodoroPhase.shortBreak:
        return 'Nghỉ ngắn';
      case PomodoroPhase.longBreak:
        return 'Nghỉ dài';
    }
  }

  // ── TrayListener ───────────────────────────────────────────────────────

  @override
  void onTrayIconMouseDown() => trayManager.popUpContextMenu();

  @override
  void onTrayIconRightMouseDown() => trayManager.popUpContextMenu();
}
