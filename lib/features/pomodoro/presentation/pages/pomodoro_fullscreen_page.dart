import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/desktop/index.dart';
import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
import '../cubit/pomodoro_cubit.dart';
import '../widgets/whale_swimmer.dart';

const _kSideGutter = 16.0;

/// Đồng hồ tập trung toàn màn hình: nền gradient theo giao diện Sáng/Tối đang
/// chọn, chỉ còn thời gian + thanh tiến độ ngang.
///
/// Luôn xoay ngang (thoát ra thì về dọc), ẩn thanh trạng thái/điều hướng, giữ
/// màn hình sáng, macOS thì phóng cửa sổ ra toàn màn hình. Nút điều khiển gom
/// lên góc trên bên phải để số đếm chiếm gần hết màn hình; khi đồng hồ đang
/// chạy chúng tự ẩn sau vài giây — chạm vào màn hình để hiện lại. Cubit vẫn là
/// singleton nên thoát ra không ảnh hưởng phiên đang chạy. Cá voi 52Hz chỉ bơi ở
/// trang này, đè lên đồng hồ nhưng không chặn thao tác chạm.
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
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();
    getIt<DesktopWindowService>().setFullScreen(true);
    if (context.read<PomodoroCubit>().state.isRunning) _scheduleHide();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
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
    final colors = context.colors;
    // Route tự dựng (PageRouteBuilder) không qua PageTransitionsTheme → tự gắn
    // nền gradient; Scaffold trong suốt theo theme.
    return AppBackground(
      child: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: BlocConsumer<PomodoroCubit, PomodoroState>(
                  // Chạy → hẹn giờ ẩn nút; dừng/tạm dừng/hết giờ → hiện nút ngay.
                  listenWhen: (p, c) => p.runStatus != c.runStatus,
                  listener: (context, state) =>
                      _showControls(autoHide: state.isRunning),
                  builder: (context, state) {
                    final color = state.isFocus
                        ? colors.accent
                        : colors.breakTime;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            _kSideGutter,
                            4,
                            4,
                            0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _PhaseLabel(state: state, color: color),
                              ),
                              _Fade(
                                visible: _controlsVisible,
                                child: _Controls(state: state, color: color),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) => Center(
                              child: _Clock(
                                state: state,
                                color: color,
                                width: constraints.maxWidth - 2 * _kSideGutter,
                                // Chừa chỗ cho thanh tiến độ bên dưới.
                                maxTimerHeight: math.max(
                                  0,
                                  constraints.maxHeight - _Clock.chromeHeight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const WhaleSwimmer(),
            ],
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

/// Nhãn góc trên bên trái: tên tag đang chọn (hoặc tên giai đoạn) + chấm vòng.
/// Luôn hiện, không ẩn theo nút điều khiển.
class _PhaseLabel extends StatelessWidget {
  final PomodoroState state;
  final Color color;

  const _PhaseLabel({required this.state, required this.color});

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
    return Row(
      children: [
        Flexible(
          child: Text(
            emoji == null ? title : '$emoji  $title',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 12),
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

  /// Chiều cao phần dưới số đếm: khoảng cách + thanh tiến độ + lề dưới.
  static const chromeHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Số đếm lấp đầy màn hình: vẽ chữ thật to rồi thu lại cho vừa cạnh
          // chạm trước (thường là chiều cao vì màn hình luôn nằm ngang).
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
              maxHeight: maxTimerHeight,
            ),
            child: FittedBox(
              child: Text(
                state.remainingLabel,
                style: TextStyle(
                  fontSize: 1000,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                  fontFamily: AppFonts.tabular,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _LineProgress(progress: state.progress, color: color),
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

/// Cụm nút góc trên bên phải: Dừng · Chạy/Tạm dừng · Bỏ qua · Thoát.
class _Controls extends StatelessWidget {
  final PomodoroState state;
  final Color color;

  const _Controls({required this.state, required this.color});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PomodoroCubit>();
    final colors = context.colors;
    final canStop = !state.isIdle || state.elapsedSeconds > 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Dừng',
          iconSize: 28,
          color: colors.textPrimary,
          disabledColor: colors.textDisabled,
          onPressed: canStop ? cubit.stop : null,
          icon: const Icon(Icons.stop_rounded),
        ),
        const SizedBox(width: 4),
        IconButton.filled(
          tooltip: state.isRunning
              ? 'Tạm dừng'
              : (state.runStatus == PomodoroRunStatus.paused
                    ? 'Tiếp tục'
                    : 'Bắt đầu'),
          iconSize: 28,
          style: IconButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          onPressed: state.isRunning ? cubit.pause : cubit.start,
          icon: Icon(
            state.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          tooltip: 'Bỏ qua',
          iconSize: 28,
          color: colors.textPrimary,
          onPressed: cubit.skip,
          icon: const Icon(Icons.skip_next_rounded),
        ),
        const SizedBox(width: 12),
        IconButton(
          tooltip: 'Thoát toàn màn hình',
          iconSize: 28,
          color: colors.textMuted,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.fullscreen_exit),
        ),
      ],
    );
  }
}
