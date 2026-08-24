import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/desktop/index.dart';
import '../../../../core/di/index.dart';
import '../cubit/pomodoro_cubit.dart';
import 'pomodoro_ring.dart';

const _kFocusColor = Color(0xFF00B3A6);
const _kBreakColor = Color(0xFF5C6BC0);
const _kBackground = Color(0xFFFDF7F2);

/// Cửa sổ nổi nhỏ trên macOS: chỉ đồng hồ + 3 nút điều khiển, ghim trên cùng
/// để luôn thấy thời gian còn lại khi đang làm việc ở app khác.
class PomodoroMiniView extends StatelessWidget {
  const PomodoroMiniView({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: BlocBuilder<PomodoroCubit, PomodoroState>(
        builder: (context, state) {
          final cubit = context.read<PomodoroCubit>();
          final color = state.isFocus ? _kFocusColor : _kBreakColor;
          return Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  tooltip: 'Trở lại cửa sổ đầy đủ',
                  iconSize: 20,
                  onPressed: () =>
                      getIt<DesktopWindowService>().setMiniMode(false),
                  icon: const Icon(Icons.close_fullscreen,
                      color: Color(0xFF8E8E93)),
                ),
              ),
              Text(
                state.label ?? _phaseLabel(state.phase),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: color),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: PomodoroRing(
                    progress: state.progress,
                    color: color,
                    size: 150,
                    child: Text(
                      state.remainingLabel,
                      style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1C1C1E),
                          fontFeatures: [FontFeature.tabularFigures()]),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Dừng',
                      onPressed: state.isIdle && state.elapsedSeconds == 0
                          ? null
                          : cubit.stop,
                      icon: const Icon(Icons.stop_circle_outlined),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 108,
                      height: 40,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: color,
                          shape: const StadiumBorder(),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: state.isRunning ? cubit.pause : cubit.start,
                        child: Text(
                          state.isRunning
                              ? 'Tạm dừng'
                              : (state.runStatus == PomodoroRunStatus.paused
                                  ? 'Tiếp tục'
                                  : 'Bắt đầu'),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Bỏ qua',
                      onPressed: cubit.skip,
                      icon: const Icon(Icons.skip_next_outlined),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
