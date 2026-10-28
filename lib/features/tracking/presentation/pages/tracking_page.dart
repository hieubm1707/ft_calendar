import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import '../cubit/tracking_cubit.dart';
import '../widgets/task_source_chip.dart';
import '../widgets/tracking_format.dart';
import '../widgets/tracking_goal_sheet.dart';
import 'tracking_goal_detail_page.dart';

DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

/// Trang Tracking: dải 7 ngày (hôm nay ở giữa) → tiến độ ngày đang xem → danh
/// sách mục tiêu phải làm hôm đó. Chỉ hôm nay mới bấm hoàn thành được; ngày quá
/// khứ chỉ xem, ngày tương lai bị khoá.
class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TrackingCubit>()..load(),
      child: const _TrackingView(),
    );
  }
}

class _TrackingView extends StatelessWidget {
  const _TrackingView();

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<TrackingCubit>();
    final goal = await showTrackingGoalSheet(context);
    if (goal != null) await cubit.saveGoal(goal);
  }

  /// Ngày đã qua chỉ để xem — báo nhẹ thay vì để chạm lọt xuống mở chi tiết.
  void _showViewOnly(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Ngày đã qua chỉ để xem — chỉ đánh dấu được hôm nay'),
        ),
      );
  }

  void _openDetail(BuildContext context, TrackingGoal goal) {
    final cubit = context.read<TrackingCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: TrackingGoalDetailPage(goal: goal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tracking',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Mục tiêu mới',
        onPressed: () => _add(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<TrackingCubit, TrackingState>(
          listenWhen: (p, c) => c.status == TrackingStatus.failure,
          listener: (context, state) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Lỗi'))),
          builder: (context, state) {
            final today = _today();
            final due = state.dueGoals;
            final isToday = state.selectedDay == today;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                    child: _WeekStrip(state: state, today: today),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: _ProgressCard(
                      title: dayTitle(state.selectedDay, today),
                      done: state.doneCount,
                      total: due.length,
                    ),
                  ),
                ),
                if (state.status == TrackingStatus.success && due.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        state.goals.isEmpty
                            ? 'Chưa có mục tiêu nào.\nNhấn + để tạo mới.'
                            : 'Không có mục tiêu nào vào ngày này.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.textMuted),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    sliver: SliverList.separated(
                      itemCount: due.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final goal = due[i];
                        return _GoalTile(
                          goal: goal,
                          done: state.isDone(goal, state.selectedDay),
                          streak: computeGoalStats(
                            goal: goal,
                            doneDays: goalDoneDays(goal, state.checkins),
                            today: today,
                            month: today,
                          ).currentStreak,
                          canToggle: isToday,
                          onToggle: isToday
                              ? () => context.read<TrackingCubit>().toggleToday(
                                  goal,
                                )
                              : () => _showViewOnly(context),
                          onTap: () => _openDetail(context, goal),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Dải 7 ngày: mặc định hôm nay ở giữa (3 ngày trước, 3 ngày sau). Mũi tên ‹ lùi
/// về tuần trước để xem lại; › tiến lại, không vượt quá cửa sổ chứa hôm nay.
class _WeekStrip extends StatefulWidget {
  final TrackingState state;
  final DateTime today;

  const _WeekStrip({required this.state, required this.today});

  @override
  State<_WeekStrip> createState() => _WeekStripState();
}

class _WeekStripState extends State<_WeekStrip> {
  int _weeksBack = 0;

  /// Hoàn thành hết mục tiêu của [day] chưa (ngày có mục tiêu).
  bool _allDone(DateTime day) {
    final due = goalsDueOn(widget.state.goals, day);
    return due.isNotEmpty && due.every((g) => widget.state.isDone(g, day));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final center = DateTime(
      widget.today.year,
      widget.today.month,
      widget.today.day - 7 * _weeksBack,
    );
    final days = [
      for (var i = -3; i <= 3; i++)
        DateTime(center.year, center.month, center.day + i),
    ];
    return Row(
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: 'Tuần trước',
          color: colors.textSecondary,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => setState(() => _weeksBack++),
        ),
        for (final d in days)
          Expanded(
            child: _DayCell(
              day: d,
              selected: d == widget.state.selectedDay,
              isToday: d == widget.today,
              enabled: !d.isAfter(widget.today),
              allDone: _allDone(d),
              onTap: () => context.read<TrackingCubit>().selectDay(d),
            ),
          ),
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: 'Tuần sau',
          color: colors.textSecondary,
          disabledColor: colors.textDisabled,
          icon: const Icon(Icons.chevron_right),
          onPressed: _weeksBack == 0
              ? null
              : () => setState(() => _weeksBack--),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool selected;
  final bool isToday;
  final bool enabled;
  final bool allDone;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.selected,
    required this.isToday,
    required this.enabled,
    required this.allDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = selected
        ? Colors.white
        : enabled
        ? colors.textPrimary
        : colors.textDisabled;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? colors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isToday && !selected
                ? Border.all(color: colors.accent, width: 1.5)
                : null,
          ),
          child: Column(
            children: [
              Text(
                kWeekdayShort[day.weekday - 1],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white70
                      : enabled
                      ? colors.textMuted
                      : colors.textDisabled,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
              const SizedBox(height: 4),
              // Chấm = đã hoàn thành hết mục tiêu của ngày đó.
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !allDone
                      ? Colors.transparent
                      : selected
                      ? Colors.white
                      : colors.success,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thẻ tiến độ của ngày đang xem: số mục tiêu đã xong / tổng + thanh ngang.
class _ProgressCard extends StatelessWidget {
  final String title;
  final int done;
  final int total;

  const _ProgressCard({
    required this.title,
    required this.done,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final progress = total == 0 ? 0.0 : done / total;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$done/$total mục tiêu hoàn thành',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: colors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 10,
              color: colors.accent.withValues(alpha: 0.15),
              alignment: Alignment.centerLeft,
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                widthFactor: progress,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  final TrackingGoal goal;
  final bool done;
  final int streak;
  final bool canToggle;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const _GoalTile({
    required this.goal,
    required this.done,
    required this.streak,
    required this.canToggle,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = Color(goal.color);
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  goal.name.characters.first.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        decoration: done ? TextDecoration.lineThrough : null,
                        decorationColor: colors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          frequencyLabel(goal),
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textMuted,
                          ),
                        ),
                        if (streak > 0)
                          Text(
                            '🔥 $streak',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors.warning,
                            ),
                          ),
                        if (goal.isFromTask) const TaskSourceChip(),
                      ],
                    ),
                  ],
                ),
              ),
              _CheckButton(
                done: done,
                color: color,
                enabled: canToggle,
                onPressed: onToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Nút tròn hoàn thành. Ngày quá khứ ([enabled] = false) vẽ mờ, chỉ hiện trạng thái.
class _CheckButton extends StatelessWidget {
  final bool done;
  final Color color;
  final bool enabled;
  final VoidCallback onPressed;

  const _CheckButton({
    required this.done,
    required this.color,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ring = enabled ? color : colors.textDisabled;
    return IconButton(
      tooltip: enabled ? (done ? 'Bỏ hoàn thành' : 'Hoàn thành') : null,
      onPressed: onPressed,
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: done ? color : Colors.transparent,
          border: done ? null : Border.all(color: ring, width: 2),
        ),
        child: done
            ? const Icon(Icons.check_rounded, size: 20, color: Colors.white)
            : null,
      ),
    );
  }
}
