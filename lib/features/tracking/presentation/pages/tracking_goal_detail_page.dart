import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import '../cubit/tracking_cubit.dart';
import '../widgets/task_source_chip.dart';
import '../widgets/tracking_format.dart';
import '../widgets/tracking_goal_sheet.dart';
import '../widgets/tracking_ring.dart';

DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

/// Chi tiết 1 mục tiêu: lịch tháng (ngày đã/chưa hoàn thành), vòng tỉ lệ
/// hoàn thành và các chỉ số chuỗi/lượt. Nhận [TrackingCubit] qua BlocProvider.value.
class TrackingGoalDetailPage extends StatefulWidget {
  final TrackingGoal goal;

  const TrackingGoalDetailPage({super.key, required this.goal});

  @override
  State<TrackingGoalDetailPage> createState() => _TrackingGoalDetailPageState();
}

class _TrackingGoalDetailPageState extends State<TrackingGoalDetailPage> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final t = _today();
    _month = DateTime(t.year, t.month);
  }

  Future<void> _edit(TrackingGoal goal) async {
    final cubit = context.read<TrackingCubit>();
    final edited = await showTrackingGoalSheet(context, initial: goal);
    if (edited != null) await cubit.saveGoal(edited);
  }

  Future<void> _delete(TrackingGoal goal) async {
    final cubit = context.read<TrackingCubit>();
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá mục tiêu?'),
        content: Text('"${goal.name}" và toàn bộ lượt hoàn thành sẽ bị xoá.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await cubit.deleteGoal(goal);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<TrackingCubit, TrackingState>(
      builder: (context, state) {
        // Lấy bản mới nhất (sau khi sửa); đã xoá thì giữ bản cũ tới lúc pop.
        final goal = state.find(widget.goal) ?? widget.goal;
        final today = _today();
        final doneDays = goalDoneDays(goal, state.checkins);
        final stats = computeGoalStats(
          goal: goal,
          doneDays: doneDays,
          today: today,
          month: _month,
        );
        final color = Color(goal.color);
        return Scaffold(
          appBar: AppBar(
            title: Text(goal.name, overflow: TextOverflow.ellipsis),
            actions: goal.isFromTask
                ? null
                : [
                    IconButton(
                      tooltip: 'Sửa',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _edit(goal),
                    ),
                    IconButton(
                      tooltip: 'Xoá',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(goal),
                    ),
                  ],
          ),
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                _Info(goal: goal),
                const SizedBox(height: 16),
                _Card(
                  child: _MonthCalendar(
                    goal: goal,
                    month: _month,
                    today: today,
                    statuses: monthDayStatus(
                      goal: goal,
                      doneDays: doneDays,
                      month: _month,
                      today: today,
                    ),
                    onPrev: () => setState(
                      () => _month = DateTime(_month.year, _month.month - 1),
                    ),
                    onNext:
                        DateTime(_month.year, _month.month + 1).isAfter(today)
                        ? null
                        : () => setState(
                            () => _month = DateTime(
                              _month.year,
                              _month.month + 1,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                _Card(
                  child: Column(
                    children: [
                      TrackingRing(
                        progress: stats.completionRate,
                        color: color,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${stats.completedDays}/${stats.scheduledDays}',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            Text(
                              'ngày hoàn thành',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${(stats.completionRate * 100).round()}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _StatRow(
                        children: [
                          _Stat(
                            icon: Icons.local_fire_department_rounded,
                            iconColor: colors.warning,
                            value: '${stats.currentStreak}',
                            label: 'Chuỗi hiện tại',
                          ),
                          const SizedBox(width: 10),
                          _Stat(
                            icon: Icons.emoji_events_rounded,
                            iconColor: colors.breakTime,
                            value: '${stats.bestStreak}',
                            label: 'Chuỗi dài nhất',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _StatRow(
                        children: [
                          _Stat(
                            icon: Icons.calendar_month_rounded,
                            iconColor: colors.accent,
                            value: '${stats.doneInMonth}',
                            label: 'Hoàn thành T${_month.month}',
                          ),
                          const SizedBox(width: 10),
                          _Stat(
                            icon: Icons.check_circle_rounded,
                            iconColor: colors.success,
                            value: '${stats.totalDone}',
                            label: 'Tổng lượt hoàn thành',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Mô tả, tần suất, khoảng thời gian, giờ nhắc của mục tiêu.
class _Info extends StatelessWidget {
  final TrackingGoal goal;

  const _Info({required this.goal});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final muted = TextStyle(fontSize: 13, color: colors.textSecondary);
    final end = goal.endDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (goal.description != null) ...[
          Text(
            goal.description!,
            style: TextStyle(fontSize: 14, color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 14,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _IconText(
              icon: Icons.repeat,
              text: frequencyLabel(goal),
              style: muted,
            ),
            _IconText(
              icon: Icons.event,
              text: end == null
                  ? 'Từ ${fmtDate(goal.startDate)}'
                  : '${fmtDate(goal.startDate)} – ${fmtDate(end)}',
              style: muted,
            ),
            if (goal.reminders.isNotEmpty)
              _IconText(
                icon: Icons.notifications_none,
                text: goal.reminders.map(fmtMinutes).join(', '),
                style: muted,
              ),
            if (goal.isFromTask) ...[
              const TaskSourceChip(),
              Text(
                'Sửa ở trang Tasks',
                style: TextStyle(fontSize: 12, color: colors.textMuted),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle style;

  const _IconText({
    required this.icon,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: style.color),
        const SizedBox(width: 4),
        Text(text, style: style),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }
}

/// Lịch 1 tháng: ngày hoàn thành tô màu mục tiêu, ngày bỏ lỡ viền đỏ.
class _MonthCalendar extends StatelessWidget {
  final TrackingGoal goal;
  final DateTime month;
  final DateTime today;
  final List<TrackingDayStatus> statuses;
  final VoidCallback onPrev;
  final VoidCallback? onNext;

  const _MonthCalendar({
    required this.goal,
    required this.month,
    required this.today,
    required this.statuses,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = Color(goal.color);
    final leading = DateTime(month.year, month.month).weekday - 1;
    final cells = leading + statuses.length;
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: 'Tháng trước',
              icon: const Icon(Icons.chevron_left),
              color: colors.textSecondary,
              onPressed: onPrev,
            ),
            Expanded(
              child: Text(
                'Tháng ${month.month}, ${month.year}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: 'Tháng sau',
              icon: const Icon(Icons.chevron_right),
              color: colors.textSecondary,
              disabledColor: colors.textDisabled,
              onPressed: onNext,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final w in kWeekdayShort)
              Expanded(
                child: Text(
                  w,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: (cells / 7).ceil() * 7,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, i) {
            final dayIndex = i - leading;
            if (dayIndex < 0 || dayIndex >= statuses.length) {
              return const SizedBox.shrink();
            }
            final day = DateTime(month.year, month.month, dayIndex + 1);
            return _DayDot(
              day: day.day,
              status: statuses[dayIndex],
              color: color,
              isToday: day == today,
            );
          },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 14,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            _Legend(fill: color, label: 'Hoàn thành'),
            _Legend(border: colors.danger, label: 'Chưa hoàn thành'),
            _Legend(border: colors.border, label: 'Không phải làm'),
          ],
        ),
      ],
    );
  }
}

class _DayDot extends StatelessWidget {
  final int day;
  final TrackingDayStatus status;
  final Color color;
  final bool isToday;

  const _DayDot({
    required this.day,
    required this.status,
    required this.color,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (Color? fill, Color? border, Color text) = switch (status) {
      TrackingDayStatus.done => (color, null, Colors.white),
      TrackingDayStatus.missed => (null, colors.danger, colors.danger),
      TrackingDayStatus.pending => (null, colors.accent, colors.textPrimary),
      TrackingDayStatus.notDue => (null, null, colors.textMuted),
      TrackingDayStatus.future => (null, null, colors.textDisabled),
    };
    return Center(
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fill,
          border: border != null
              ? Border.all(color: border, width: 1.5)
              : isToday
              ? Border.all(color: colors.accent, width: 1.5)
              : null,
        ),
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 13,
            fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
            color: text,
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color? fill;
  final Color? border;
  final String label;

  const _Legend({this.fill, this.border, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fill,
            border: border == null
                ? null
                : Border.all(color: border!, width: 1.5),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, color: colors.textMuted)),
      ],
    );
  }
}

/// Hàng 2 ô chỉ số cao bằng nhau (nhãn dài xuống dòng không làm lệch ô bên cạnh).
class _StatRow extends StatelessWidget {
  final List<Widget> children;

  const _StatRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _Stat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 2,
                    style: TextStyle(fontSize: 11.5, color: colors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
