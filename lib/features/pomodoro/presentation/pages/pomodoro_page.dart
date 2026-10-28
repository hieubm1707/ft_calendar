import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/desktop/index.dart';
import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
import '../cubit/pomodoro_cubit.dart';
import '../widgets/duration_format.dart';
import '../widgets/focus_tag_sheet.dart';
import '../widgets/pomodoro_ring.dart';
import 'pomodoro_fullscreen_page.dart';
import 'pomodoro_report_page.dart';


/// Trang "Focus". Cubit là singleton do `app.dart` cung cấp — trang chỉ hiển thị,
/// không tạo/đóng đồng hồ (đổi tab hay ẩn cửa sổ không được reset phiên).
class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) => const _PomodoroView();
}

class _PomodoroView extends StatelessWidget {
  const _PomodoroView();

  static const _focusPresets = [15, 25, 45, 60];

  Future<void> _pickTag(BuildContext context) {
    return showFocusTagSheet(context, cubit: context.read<PomodoroCubit>());
  }

  void _openReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PomodoroReportPage()),
    );
  }

  void _openFullscreen(BuildContext context) {
    Navigator.of(context).push(PomodoroFullscreenPage.route());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tập trung',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (getIt<DesktopWindowService>().isSupported)
            IconButton(
              tooltip: 'Cửa sổ nổi nhỏ',
              onPressed: () => getIt<DesktopWindowService>().setMiniMode(true),
              icon: const Icon(Icons.picture_in_picture_alt_outlined),
            ),
          IconButton(
            tooltip: 'Toàn màn hình',
            onPressed: () => _openFullscreen(context),
            icon: const Icon(Icons.fullscreen),
          ),
          IconButton(
            tooltip: 'Báo cáo',
            onPressed: () => _openReport(context),
            icon: const Icon(Icons.bar_chart_rounded),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<PomodoroCubit, PomodoroState>(
          listenWhen: (p, c) => c.errorMessage != null && p.errorMessage != c.errorMessage,
          listener: (context, state) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!))),
          builder: (context, state) {
            final color = state.isFocus ? colors.accent : colors.breakTime;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: PomodoroRing(
                      progress: state.progress,
                      color: color,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _TargetLabel(
                            state: state,
                            color: color,
                            onTap: () => _pickTag(context),
                          ),
                          const SizedBox(height: 6),
                          Text(state.remainingLabel,
                              style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                  fontFeatures: [
                                    FontFeature.tabularFigures()
                                  ])),
                          const SizedBox(height: 6),
                          _RoundDots(
                            total: state.roundsBeforeLongBreak,
                            done: state.completedRounds %
                                state.roundsBeforeLongBreak,
                            color: color,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.isIdle && state.isFocus) ...[
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        for (final m in _focusPresets)
                          ChoiceChip(
                            label: Text('$m phút'),
                            selected: state.focusMinutes == m,
                            selectedColor: color.withValues(alpha: 0.18),
                            onSelected: (_) => context
                                .read<PomodoroCubit>()
                                .setFocusMinutes(m),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 22),
                  _Controls(state: state, color: color),
                  const SizedBox(height: 24),
                  _TodayCard(
                    focusSeconds: state.todayFocusSeconds,
                    sessions: state.todaySessions,
                    onOpenReport: () => _openReport(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Nhãn giữa đồng hồ: tên tag đang chọn (hoặc tên giai đoạn nếu chưa chọn).
/// Bấm vào để mở danh sách tag.
class _TargetLabel extends StatelessWidget {
  final PomodoroState state;
  final Color color;
  final VoidCallback onTap;

  const _TargetLabel({
    required this.state,
    required this.color,
    required this.onTap,
  });

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
    final emoji = state.selectedTag?.emoji;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        // Giữ nhãn nằm gọn trong vòng tròn dù tên tag dài.
        constraints: const BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showTarget && emoji != null) ...[
              Text(emoji, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                showTarget ? state.label! : phaseLabel(state.phase),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700, color: color),
              ),
            ),
            const SizedBox(width: 3),
            Icon(Icons.expand_more, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}

/// Chấm tròn thể hiện số phiên focus đã xong trước khi được nghỉ dài.
class _RoundDots extends StatelessWidget {
  final int total;
  final int done;
  final Color color;

  const _RoundDots(
      {required this.total, required this.done, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < total; i++)
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < done ? color : color.withValues(alpha: 0.2),
            ),
          ),
      ],
    );
  }
}

class _Controls extends StatelessWidget {
  final PomodoroState state;
  final Color color;

  const _Controls({required this.state, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<PomodoroCubit>();
    final canStop = !state.isIdle || state.elapsedSeconds > 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'Dừng',
          iconSize: 28,
          color: canStop ? colors.textPrimary : colors.textDisabled,
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
          iconSize: 28,
          color: colors.textPrimary,
          onPressed: cubit.skip,
          icon: const Icon(Icons.skip_next_outlined),
        ),
      ],
    );
  }
}

class _TodayCard extends StatelessWidget {
  final int focusSeconds;
  final int sessions;
  final VoidCallback onOpenReport;

  const _TodayCard({
    required this.focusSeconds,
    required this.sessions,
    required this.onOpenReport,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(
                value: formatFocusDuration(focusSeconds),
                caption: 'Hôm nay'),
          ),
          Container(width: 1, height: 34, color: colors.divider),
          Expanded(
            child: _Stat(value: '$sessions', caption: 'Phiên'),
          ),
          TextButton(
            onPressed: onOpenReport,
            child: const Text('Xem báo cáo'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String caption;

  const _Stat({required this.value, required this.caption});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary)),
        const SizedBox(height: 2),
        Text(caption,
            style: TextStyle(fontSize: 12, color: colors.textMuted)),
      ],
    );
  }
}
