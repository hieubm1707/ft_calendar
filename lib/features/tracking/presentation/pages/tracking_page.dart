import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import '../cubit/tracking_cubit.dart';
import '../widgets/task_source_chip.dart';
import '../widgets/tracking_format.dart';
import '../widgets/tracking_goal_sheet.dart';
import 'tracking_goal_detail_page.dart';
import 'tracking_reminder_settings_page.dart';

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
        actions: [
          IconButton(
            tooltip: 'Cài đặt nhắc nhở',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TrackingReminderSettingsPage(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Mục tiêu mới',
        onPressed: () => _add(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<TrackingCubit, TrackingState>(
          listenWhen: (p, c) =>
              c.errorMessage != null && p.errorMessage != c.errorMessage,
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
                        style: TextStyle(color: colors.textSecondary),
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
                              ? () {
                                  HapticFeedback.lightImpact();
                                  context.read<TrackingCubit>().toggleToday(
                                    goal,
                                  );
                                }
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

/// Dải 7 ngày: mặc định hôm nay ở giữa (3 ngày trước, 3 ngày sau). Vuốt sang
/// phải để lùi về tuần trước; trang đầu là cửa sổ chứa hôm nay nên không vuốt
/// được tới tương lai.
class _WeekStrip extends StatelessWidget {
  final TrackingState state;
  final DateTime today;

  const _WeekStrip({required this.state, required this.today});

  /// Hoàn thành hết mục tiêu của [day] chưa (ngày có mục tiêu).
  bool _allDone(DateTime day) {
    final due = goalsDueOn(state.goals, day);
    return due.isNotEmpty && due.every((g) => state.isDone(g, day));
  }

  @override
  Widget build(BuildContext context) {
    // PageView cần chiều cao cố định → tính theo cỡ chữ hệ thống để ô không bị
    // cắt: 2 dòng chữ + padding/khoảng cách/chấm (33) + viền hôm nay (3) + dư.
    final scaler = MediaQuery.textScalerOf(context);
    final height = scaler.scale(12) * 1.4 + scaler.scale(16) * 1.4 + 40;
    return SizedBox(
      height: height,
      // reverse: trang 0 = tuần hiện tại ở mép phải, trang `i` = lùi `i` tuần.
      child: PageView.builder(
        reverse: true,
        itemBuilder: (context, weeksBack) {
          final days = [
            for (var i = -3; i <= 3; i++)
              DateTime(today.year, today.month, today.day - 7 * weeksBack + i),
          ];
          return Row(
            children: [
              for (final d in days)
                Expanded(
                  child: _DayCell(
                    day: d,
                    selected: d == state.selectedDay,
                    isToday: d == today,
                    enabled: !d.isAfter(today),
                    allDone: _allDone(d),
                    onTap: () => context.read<TrackingCubit>().selectDay(d),
                  ),
                ),
            ],
          );
        },
      ),
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
    final onAccent = colors.accent.readableForeground;
    final fg = selected
        ? onAccent
        : enabled
        ? colors.textPrimary
        : colors.textDisabled;
    final label = [
      '${kWeekdayLong[day.weekday - 1]}, ${day.day}/${day.month}',
      if (isToday) 'hôm nay',
      if (allDone) 'đã xong hết mục tiêu',
    ].join(', ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Semantics(
        container: true,
        button: true,
        enabled: enabled,
        selected: selected,
        label: label,
        onTap: enabled ? onTap : null,
        excludeSemantics: true,
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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    kWeekdayShort[day.weekday - 1],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? onAccent
                          : enabled
                          ? colors.textSecondary
                          : colors.textDisabled,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: fg,
                    ),
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
                        ? onAccent
                        : colors.accent,
                  ),
                ),
              ],
            ),
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
    final percent = (progress * 100).round();
    final card = Container(
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
          // Wrap: cỡ chữ thường thì % nằm bên phải; chữ quá lớn thì % xuống dòng
          // thay vì ép tiêu đề vào cột hẹp làm gãy giữa từ.
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
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
                Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: colors.accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 10,
              color: colors.accent.withValues(alpha: 0.15),
              alignment: Alignment.centerLeft,
              child: AnimatedFractionallySizedBox(
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 300),
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
    // Đọc thành 1 câu, thay vì "0/1" và thanh ngang rời rạc.
    return Semantics(
      container: true,
      label:
          '$title: $done trên $total mục tiêu hoàn thành, $percent phần trăm',
      excludeSemantics: true,
      child: card,
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
              // Chữ cái đầu chỉ để trang trí, tên đã có ngay bên cạnh.
              ExcludeSemantics(
                child: Container(
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
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      maxLines: 2,
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
                            color: colors.textSecondary,
                          ),
                        ),
                        if (streak > 0)
                          Semantics(
                            label: 'Chuỗi $streak ngày',
                            excludeSemantics: true,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_fire_department_rounded,
                                  size: 14,
                                  color: colors.warning,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '$streak',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (goal.isFromTask) const TaskSourceChip(),
                      ],
                    ),
                  ],
                ),
              ),
              _CheckButton(
                goalName: goal.name,
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
  final String goalName;
  final bool done;
  final Color color;
  final bool enabled;
  final VoidCallback onPressed;

  const _CheckButton({
    required this.goalName,
    required this.done,
    required this.color,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ring = enabled ? color : colors.textDisabled;
    // Có tên mục tiêu + trạng thái: danh sách nhiều nút "Hoàn thành" giống hệt
    // nhau thì trình đọc màn hình không phân biệt được.
    return Semantics(
      container: true,
      button: true,
      checked: done,
      label: enabled
          ? 'Hoàn thành $goalName'
          : '$goalName, chỉ đánh dấu được hôm nay',
      onTap: onPressed,
      excludeSemantics: true,
      child: IconButton(
        tooltip: enabled
            ? (done ? 'Bỏ hoàn thành' : 'Hoàn thành')
            : 'Chỉ đánh dấu được hôm nay',
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
              ? Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: color.readableForeground,
                )
              : null,
        ),
      ),
    );
  }
}
