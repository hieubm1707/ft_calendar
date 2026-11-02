import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import '../cubit/pomodoro_report_cubit.dart';
import '../widgets/duration_format.dart';

/// Báo cáo thời gian đã tập trung (pomodoro): tổng hợp theo ngày, lọc theo
/// tuần/tháng/năm/khoảng tuỳ chọn, kèm "focus trend" theo tag.
class PomodoroReportPage extends StatelessWidget {
  const PomodoroReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PomodoroReportCubit>()..load(),
      child: const _ReportView(),
    );
  }
}

class _ReportView extends StatelessWidget {
  const _ReportView();

  static const _rangeLabels = {
    PomodoroRange.week: 'Tuần này',
    PomodoroRange.month: 'Tháng này',
    PomodoroRange.year: 'Năm nay',
    PomodoroRange.custom: 'Tuỳ chọn',
  };

  Future<void> _pickCustomRange(
      BuildContext context, PomodoroReportState state) async {
    final cubit = context.read<PomodoroReportCubit>();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: today,
      initialDateRange: DateTimeRange(
        start: state.from.isAfter(today) ? today : state.from,
        end: state.to.isAfter(today) ? today : state.to,
      ),
      helpText: 'Chọn khoảng thời gian',
      saveText: 'Xong',
    );
    if (picked == null) return;
    await cubit.setCustomRange(picked.start, picked.end);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Báo cáo tập trung',
            style: TextStyle(
                fontWeight: FontWeight.w800, color: colors.textPrimary)),
      ),
      body: BlocConsumer<PomodoroReportCubit, PomodoroReportState>(
        listenWhen: (p, c) =>
            c.errorMessage != null && p.errorMessage != c.errorMessage,
        listener: (context, state) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Lỗi'))),
        builder: (context, state) {
          final report = state.report;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final r in PomodoroRange.values)
                    ChoiceChip(
                      label: Text(_rangeLabels[r]!),
                      selected: state.range == r,
                      selectedColor: colors.accent.withValues(alpha: 0.18),
                      onSelected: (_) => r == PomodoroRange.custom
                          ? _pickCustomRange(context, state)
                          : context.read<PomodoroReportCubit>().changeRange(r),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.date_range, size: 15, color: colors.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${_formatDay(state.from)} – ${_formatDay(state.to)}'
                      ' · ${report.dayCount} ngày',
                      style: TextStyle(fontSize: 12, color: colors.textMuted),
                    ),
                  ),
                  if (state.range == PomodoroRange.custom)
                    TextButton(
                      onPressed: () => _pickCustomRange(context, state),
                      child: const Text('Đổi khoảng'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              _SummaryGrid(report: report),
              const SizedBox(height: 20),
              if (report.totalSessions == 0)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text('Chưa có phiên tập trung nào trong khoảng này.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.textMuted)),
                )
              else ...[
                const _SectionTitle('Theo ngày'),
                _FocusChart(days: report.days),
                const SizedBox(height: 20),
                const _SectionTitle('Focus trend'),
                _FocusTrend(state: state),
                const SizedBox(height: 20),
                const _SectionTitle('Phiên gần đây'),
                ...state.sessions.take(30).map((s) => _SessionTile(
                      session: s,
                      color: state.colorOfTag(s.focusTagId),
                      onDelete: () =>
                          context.read<PomodoroReportCubit>().remove(s.id!),
                    )),
              ],
            ],
          );
        },
      ),
    );
  }
}

String _formatDay(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary)),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  final PomodoroReport report;

  const _SummaryGrid({required this.report});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCard(
        icon: Icons.timer_outlined,
        value: formatFocusDuration(report.totalFocusSeconds),
        caption: 'Tổng tập trung',
      ),
      _SummaryCard(
        icon: Icons.local_fire_department_outlined,
        value: '${report.totalSessions}',
        caption: '${report.completedSessions} phiên trọn vẹn',
      ),
      _SummaryCard(
        icon: Icons.trending_up,
        value: formatFocusDuration(report.averageSecondsPerActiveDay),
        caption: 'TB mỗi ngày có tập trung',
      ),
      _SummaryCard(
        icon: Icons.bolt_outlined,
        value: '${report.streakDays} ngày',
        caption: 'Chuỗi liên tiếp',
      ),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.7,
      children: cards,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String caption;

  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: colors.accent),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary)),
          Text(caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: colors.textMuted)),
        ],
      ),
    );
  }
}

/// Cột thời gian tập trung theo ngày; khoảng dài (năm) tự gom theo tháng.
class _FocusChart extends StatelessWidget {
  final List<PomodoroDaySummary> days;

  const _FocusChart({required this.days});

  static const _barWidth = 22.0;
  static const _gap = 10.0;
  static const _maxHeight = 120.0;

  String _label(PomodoroBucket b) => b.unit == PomodoroBucketUnit.day
      ? '${b.start.day}/${b.start.month}'
      : 'T${b.start.month}';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final buckets = bucketDaySummaries(days, autoBucketUnit(days.length));
    final peak =
        buckets.fold(0, (m, b) => b.focusSeconds > m ? b.focusSeconds : m);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: _maxHeight + 46,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          reverse: true, // mốc mới nhất nằm bên phải, hiển thị trước
          itemCount: buckets.length,
          separatorBuilder: (_, _) => const SizedBox(width: _gap),
          itemBuilder: (context, i) {
            final b = buckets[buckets.length - 1 - i];
            final ratio = peak == 0 ? 0.0 : b.focusSeconds / peak;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  b.focusSeconds == 0 ? '' : '${b.focusSeconds ~/ 60}',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted),
                ),
                const SizedBox(height: 4),
                Container(
                  width: _barWidth,
                  height: (_maxHeight * ratio).clamp(3.0, _maxHeight),
                  decoration: BoxDecoration(
                    color: b.focusSeconds == 0
                        ? colors.divider
                        : colors.accent.withValues(alpha: 0.35 + 0.65 * ratio),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(_label(b),
                    style: TextStyle(fontSize: 10, color: colors.textMuted)),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// "Focus trend": tỉ trọng thời gian theo từng tag để thấy mình hay tập trung
/// vào nhóm việc nào.
class _FocusTrend extends StatelessWidget {
  final PomodoroReportState state;

  const _FocusTrend({required this.state});

  static const _fallbackColors = [
    0xFF00B3A6,
    0xFF4C8DFF,
    0xFFFFA726,
    0xFF66BB6A,
    0xFFAB47BC,
    0xFFEF5350,
    0xFF26C6DA,
    0xFF8D6E63,
  ];

  Color _colorFor(PomodoroTagSummary tag, int index) {
    final tagColor = state.colorOfTag(tag.tagId);
    return Color(tagColor ?? _fallbackColors[index % _fallbackColors.length]);
  }

  String _titleFor(PomodoroTagSummary tag) {
    final emoji = state.emojiOfTag(tag.tagId);
    final label = tag.label.isEmpty ? 'Không đặt tên' : tag.label;
    return emoji == null ? label : '$emoji $label';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final report = state.report;
    final tags = report.tags;
    final top = report.topTag;
    final shown = tags.take(8).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (top != null) ...[
            Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 13, color: colors.textPrimary),
                children: [
                  const TextSpan(text: 'Tập trung nhiều nhất vào '),
                  TextSpan(
                    text: _titleFor(top),
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: _colorFor(top, 0)),
                  ),
                  TextSpan(
                    text: ' · ${(report.shareOf(top) * 100).round()}%'
                        ' thời gian',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Thanh tỉ trọng: nhìn phát biết mình chia thời gian thế nào.
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                height: 10,
                child: Row(
                  children: [
                    for (var i = 0; i < shown.length; i++)
                      Expanded(
                        flex: shown[i].focusSeconds.clamp(1, 1 << 30),
                        child: Container(color: _colorFor(shown[i], i)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
          for (var i = 0; i < shown.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: _colorFor(shown[i], i),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _titleFor(shown[i]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        '${formatFocusDuration(shown[i].focusSeconds)}'
                        ' · ${(report.shareOf(shown[i]) * 100).round()}%',
                        style: TextStyle(fontSize: 12, color: colors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: report.shareOf(shown[i]),
                      minHeight: 6,
                      backgroundColor: colors.surfaceAlt,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          _colorFor(shown[i], i)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('${shown[i].sessions} phiên',
                      style: TextStyle(fontSize: 11, color: colors.textMuted)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final PomodoroSession session;
  final int? color;
  final VoidCallback onDelete;

  const _SessionTile({
    required this.session,
    required this.color,
    required this.onDelete,
  });

  String _time(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final s = session;
    final accent = color == null ? colors.accent : Color(color!);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        leading: Icon(
          s.completed ? Icons.check_circle : Icons.pause_circle_filled,
          color: s.completed ? accent : colors.warning,
        ),
        title: Text(
          (s.label == null || s.label!.isEmpty) ? 'Không đặt tên' : s.label!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${s.startedAt.day}/${s.startedAt.month} · '
          '${_time(s.startedAt)}–${_time(s.endedAt)}',
          style: TextStyle(fontSize: 12, color: colors.textMuted),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(formatFocusDuration(s.focusSeconds),
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: colors.textPrimary)),
            IconButton(
              icon: Icon(Icons.close, size: 18, color: colors.textDisabled),
              onPressed: s.id == null ? null : onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
