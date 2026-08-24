import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
import '../../domain/index.dart';
import '../cubit/pomodoro_report_cubit.dart';
import '../widgets/duration_format.dart';

const _kAccent = Color(0xFF00B3A6);
const _kBackground = Color(0xFFFDF7F2);

/// Báo cáo thời gian đã tập trung (pomodoro).
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
    PomodoroRange.week: '7 ngày',
    PomodoroRange.month: '30 ngày',
    PomodoroRange.all: 'Tất cả',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        backgroundColor: _kBackground,
        elevation: 0,
        title: const Text('Báo cáo tập trung',
            style: TextStyle(
                fontWeight: FontWeight.w800, color: Color(0xFF1C1C1E))),
      ),
      body: BlocConsumer<PomodoroReportCubit, PomodoroReportState>(
        listenWhen: (p, c) => c.status == PomodoroReportStatus.failure,
        listener: (context, state) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Lỗi'))),
        builder: (context, state) {
          final report = state.report;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              Wrap(
                spacing: 8,
                children: [
                  for (final r in PomodoroRange.values)
                    ChoiceChip(
                      label: Text(_rangeLabels[r]!),
                      selected: state.range == r,
                      selectedColor: _kAccent.withValues(alpha: 0.18),
                      onSelected: (_) =>
                          context.read<PomodoroReportCubit>().changeRange(r),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _SummaryGrid(report: report),
              const SizedBox(height: 20),
              if (report.totalSessions == 0)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text('Chưa có phiên tập trung nào.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8E8E93))),
                )
              else ...[
                const _SectionTitle('Theo ngày'),
                _DailyChart(days: report.days),
                const SizedBox(height: 20),
                const _SectionTitle('Theo công việc'),
                _LabelBreakdown(
                    labels: report.labels,
                    totalSeconds: report.totalFocusSeconds),
                const SizedBox(height: 20),
                const _SectionTitle('Phiên gần đây'),
                ...state.sessions.take(30).map((s) => _SessionTile(
                      session: s,
                      onDelete: () => context
                          .read<PomodoroReportCubit>()
                          .remove(s.id!),
                    )),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1E))),
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
        caption: 'TB mỗi ngày có học',
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: _kAccent),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1C1C1E))),
          Text(caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93))),
        ],
      ),
    );
  }
}

/// Cột thời gian tập trung theo ngày (cuộn ngang khi khoảng dài).
class _DailyChart extends StatelessWidget {
  final List<PomodoroDaySummary> days;

  const _DailyChart({required this.days});

  static const _barWidth = 22.0;
  static const _gap = 10.0;
  static const _maxHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    final peak = days.fold(0, (m, d) => d.focusSeconds > m ? d.focusSeconds : m);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: _maxHeight + 46,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          reverse: true, // ngày mới nhất nằm bên phải, hiển thị trước
          itemCount: days.length,
          separatorBuilder: (_, _) => const SizedBox(width: _gap),
          itemBuilder: (context, i) {
            final d = days[days.length - 1 - i];
            final ratio = peak == 0 ? 0.0 : d.focusSeconds / peak;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  d.focusSeconds == 0 ? '' : '${d.focusSeconds ~/ 60}',
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E8E93)),
                ),
                const SizedBox(height: 4),
                Container(
                  width: _barWidth,
                  height: (_maxHeight * ratio).clamp(3.0, _maxHeight),
                  decoration: BoxDecoration(
                    color: d.focusSeconds == 0
                        ? const Color(0xFFEEEEEE)
                        : _kAccent.withValues(alpha: 0.35 + 0.65 * ratio),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text('${d.date.day}/${d.date.month}',
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF8E8E93))),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LabelBreakdown extends StatelessWidget {
  final List<PomodoroLabelSummary> labels;
  final int totalSeconds;

  const _LabelBreakdown({required this.labels, required this.totalSeconds});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (final l in labels.take(8))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.label.isEmpty ? 'Không đặt tên' : l.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text('${formatFocusDuration(l.focusSeconds)} · ${l.sessions} phiên',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF8E8E93))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: totalSeconds == 0
                          ? 0
                          : l.focusSeconds / totalSeconds,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFF0F0F0),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(_kAccent),
                    ),
                  ),
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
  final VoidCallback onDelete;

  const _SessionTile({required this.session, required this.onDelete});

  String _time(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final s = session;
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        leading: Icon(
          s.completed ? Icons.check_circle : Icons.pause_circle_filled,
          color: s.completed ? _kAccent : const Color(0xFFFFA726),
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
          style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(formatFocusDuration(s.focusSeconds),
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E))),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Color(0xFFBDBDBD)),
              onPressed: s.id == null ? null : onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
