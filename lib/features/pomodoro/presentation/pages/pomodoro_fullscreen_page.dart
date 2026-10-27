import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/desktop/index.dart';
import '../../../../core/di/index.dart';
import '../cubit/pomodoro_cubit.dart';

const _kFocusColor = Color(0xFF00B3A6);
const _kBreakColor = Color(0xFF5C6BC0);
const _kBackground = Color(0xFF101418);
const _kForeground = Color(0xFFF2F2F7);
const _kMuted = Color(0xFF8E8E93);
const _kSideGutter = 16.0;

/// Đồng hồ tập trung toàn màn hình: nền tối, chỉ còn thời gian + thanh tiến độ ngang.
///
/// Ẩn thanh trạng thái/điều hướng, giữ màn hình sáng, macOS thì phóng cửa sổ ra
/// toàn màn hình. Khi đồng hồ đang chạy, nút điều khiển tự ẩn sau vài giây —
/// chạm vào màn hình để hiện lại. Cubit vẫn là singleton nên thoát ra không
/// ảnh hưởng phiên đang chạy.
class PomodoroFullscreenPage extends StatefulWidget {
  const PomodoroFullscreenPage({super.key});

  static Route<void> route() => PageRouteBuilder<void>(
    pageBuilder: (_, _, _) => const PomodoroFullscreenPage(),
    transitionsBuilder: (_, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );

  @override
  State<PomodoroFullscreenPage> createState() => _PomodoroFullscreenPageState();
}

class _PomodoroFullscreenPageState extends State<PomodoroFullscreenPage> {
  static const _autoHideDelay = Duration(seconds: 4);

  bool _controlsVisible = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();
    getIt<DesktopWindowService>().setFullScreen(true);
    if (context.read<PomodoroCubit>().state.isRunning) _scheduleHide();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WakelockPlus.disable();
    getIt<DesktopWindowService>().setFullScreen(false);
    super.dispose();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(_autoHideDelay, () {
      if (mounted) setState(() => _controlsVisible = false);
    });
  }

  void _showControls({required bool autoHide}) {
    _hideTimer?.cancel();
    setState(() => _controlsVisible = true);
    if (autoHide) _scheduleHide();
  }

  void _onTap() {
    if (_controlsVisible) {
      _hideTimer?.cancel();
      setState(() => _controlsVisible = false);
    } else {
      _showControls(autoHide: context.read<PomodoroCubit>().state.isRunning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: SafeArea(
          child: BlocConsumer<PomodoroCubit, PomodoroState>(
            // Chạy → hẹn giờ ẩn nút; dừng/tạm dừng/hết giờ → hiện nút ngay.
            listenWhen: (p, c) => p.runStatus != c.runStatus,
            listener: (context, state) =>
                _showControls(autoHide: state.isRunning),
            builder: (context, state) {
              final color = state.isFocus ? _kFocusColor : _kBreakColor;
              return Column(
                children: [
                  _Fade(
                    visible: _controlsVisible,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        tooltip: 'Thoát toàn màn hình',
                        iconSize: 28,
                        color: _kMuted,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.fullscreen_exit),
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Center(
                        child: _Clock(
                          state: state,
                          color: color,
                          width: constraints.maxWidth - 2 * _kSideGutter,
                          // Chừa chỗ cho nhãn + thanh tiến độ + chấm vòng.
                          maxTimerHeight: math.max(
                            0,
                            constraints.maxHeight - _Clock.chromeHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _Fade(
                    visible: _controlsVisible,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: _Controls(state: state, color: color),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Ẩn/hiện mượt nhưng vẫn giữ chỗ → đồng hồ không nhảy vị trí.
class _Fade extends StatelessWidget {
  final bool visible;
  final Widget child;

  const _Fade({required this.visible, required this.child});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: child,
      ),
    );
  }
}

class _Clock extends StatelessWidget {
  final PomodoroState state;
  final Color color;
  final double width;
  final double maxTimerHeight;

  const _Clock({
    required this.state,
    required this.color,
    required this.width,
    required this.maxTimerHeight,
  });

  /// Tổng chiều cao phần quanh số đếm: nhãn + khoảng cách + thanh + chấm.
  static const chromeHeight = 110.0;

  static String phaseLabel(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.focus:
        return 'Tập trung';
      case PomodoroPhase.shortBreak:
        return 'Nghỉ ngắn';
      case PomodoroPhase.longBreak:
        return 'Nghỉ dài';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTarget = state.label != null && state.label!.isNotEmpty;
    // Đang nghỉ thì tên giai đoạn quan trọng hơn tên việc.
    final showTarget = hasTarget && state.isFocus;
    final emoji = showTarget ? state.selectedTag?.emoji : null;
    final title = showTarget ? state.label! : phaseLabel(state.phase);
    final done = state.completedRounds % state.roundsBeforeLongBreak;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji == null ? title : '$emoji  $title',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          // Số đếm lấp đầy màn hình: vẽ chữ thật to rồi thu lại cho vừa cạnh
          // chạm trước (bề rộng khi dọc, chiều cao khi ngang).
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
              maxHeight: maxTimerHeight,
            ),
            child: FittedBox(
              child: Text(
                state.remainingLabel,
                style: const TextStyle(
                  fontSize: 1000,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: _kForeground,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _LineProgress(progress: state.progress, color: color),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < state.roundsBeforeLongBreak; i++)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < done ? color : color.withValues(alpha: 0.25),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Thanh tiến độ ngang bo tròn (0..1) — thay cho vòng tròn ở chế độ toàn màn hình.
class _LineProgress extends StatelessWidget {
  final double progress;
  final Color color;

  const _LineProgress({required this.progress, required this.color});

  static const _height = 10.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_height / 2),
      child: Container(
        height: _height,
        color: color.withValues(alpha: 0.15),
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          heightFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(_height / 2),
            ),
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  final PomodoroState state;
  final Color color;

  const _Controls({required this.state, required this.color});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PomodoroCubit>();
    final canStop = !state.isIdle || state.elapsedSeconds > 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'Dừng',
          iconSize: 30,
          color: _kForeground,
          disabledColor: _kMuted.withValues(alpha: 0.4),
          onPressed: canStop ? cubit.stop : null,
          icon: const Icon(Icons.stop_circle_outlined),
        ),
        const SizedBox(width: 18),
        SizedBox(
          width: 170,
          height: 56,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: color,
              shape: const StadiumBorder(),
            ),
            onPressed: state.isRunning ? cubit.pause : cubit.start,
            child: Text(
              state.isRunning
                  ? 'Tạm dừng'
                  : (state.runStatus == PomodoroRunStatus.paused
                        ? 'Tiếp tục'
                        : 'Bắt đầu'),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 18),
        IconButton(
          tooltip: 'Bỏ qua',
          iconSize: 30,
          color: _kForeground,
          onPressed: cubit.skip,
          icon: const Icon(Icons.skip_next_outlined),
        ),
      ],
    );
  }
}
