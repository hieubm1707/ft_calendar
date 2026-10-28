import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import '../cubit/typing_history_cubit.dart';
import '../widgets/typing_theme.dart';

/// Lịch sử gõ phím: lọc theo tuần/tháng/năm/khoảng tuỳ chọn, xem WPM theo ngày
/// và danh sách từng bài đã làm (kèm ngày giờ).
class TypingHistoryPage extends StatelessWidget {
  const TypingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TypingHistoryCubit>()..load(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  static const _rangeLabels = {
    TypingRange.week: 'Tuần này',
    TypingRange.month: 'Tháng này',
    TypingRange.year: 'Năm nay',
    TypingRange.custom: 'Tuỳ chọn',
  };

  Future<void> _pickCustomRange(
      BuildContext context, TypingHistoryState state) async {
    final cubit = context.read<TypingHistoryCubit>();
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
        title: Text('Lịch sử gõ phím',
            style: TextStyle(fontWeight: FontWeight.w800, color: colors.textPrimary)),
      ),
      body: BlocConsumer<TypingHistoryCubit, TypingHistoryState>(
        listenWhen: (p, c) => c.status == TypingHistoryStatus.failure,
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
                  for (final r in TypingRange.values)
                    ChoiceChip(
                      label: Text(_rangeLabels[r]!),
                      selected: state.range == r,
                      selectedColor: colors.accent.withValues(alpha: 0.18),
                      onSelected: (_) => r == TypingRange.custom
                          ? _pickCustomRange(context, state)
                          : context.read<TypingHistoryCubit>().changeRange(r),
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
                      '${formatDayShort(state.from)} – ${formatDayShort(state.to)}'
                      ' · ${report.dayCount} ngày',
                      style:
                          TextStyle(fontSize: 12, color: colors.textMuted),
                    ),
                  ),
                  if (state.range == TypingRange.custom)
                    TextButton(
                      onPressed: () => _pickCustomRange(context, state),
                      child: const Text('Đổi khoảng'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              _SummaryGrid(report: report),
              const SizedBox(height: 20),
              if (report.totalTests == 0)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text('Chưa có bài test nào trong khoảng này.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.textMuted)),
                )
              else ...[
                const _SectionTitle('WPM tốt nhất theo ngày'),
                _WpmChart(days: report.days),
                const SizedBox(height: 20),
                const _SectionTitle('Theo ngôn ngữ'),
                _LanguageBreakdown(report: report),
                const SizedBox(height: 20),
                const _SectionTitle('Bài gần đây'),
                ...state.results.take(40).map((r) => _ResultTile(
                      result: r,
                      onDelete: () =>
                          context.read<TypingHistoryCubit>().remove(r.id!),
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
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700, color: colors.textPrimary)),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  final TypingReport report;

  const _SummaryGrid({required this.report});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.7,
      children: [
        _SummaryCard(
          icon: Icons.speed,
          value: report.bestWpm.toStringAsFixed(0),
          caption: 'WPM tốt nhất',
        ),
        _SummaryCard(
          icon: Icons.trending_up,
          value: report.averageWpm.toStringAsFixed(0),
          caption: 'WPM trung bình',
        ),
        _SummaryCard(
          icon: Icons.check_circle_outline,
          value: '${(report.averageAccuracy * 100).round()}%',
          caption: 'Chính xác trung bình',
        ),
        _SummaryCard(
          icon: Icons.local_fire_department_outlined,
          value: '${report.totalTests}',
          caption: '${formatTypingDuration(report.totalSeconds)}'
              ' · chuỗi ${report.streakDays} ngày',
        ),
      ],
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

/// Cột WPM tốt nhất theo ngày; khoảng dài (năm) tự gom theo tháng.
class _WpmChart extends StatelessWidget {
  final List<TypingDaySummary> days;

  const _WpmChart({required this.days});

  static const _barWidth = 22.0;
  static const _gap = 10.0;
  static const _maxHeight = 120.0;

  String _label(TypingBucket b) => b.unit == TypingBucketUnit.day
      ? '${b.start.day}/${b.start.month}'
      : 'T${b.start.month}';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final buckets = bucketTypingDays(days, autoTypingBucketUnit(days.length));
    final peak = buckets.fold(0.0, (m, b) => b.bestWpm > m ? b.bestWpm : m);

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
            final ratio = peak == 0 ? 0.0 : b.bestWpm / peak;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  b.tests == 0 ? '' : b.bestWpm.toStringAsFixed(0),
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
                    color: b.tests == 0
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

/// So sánh tốc độ giữa tiếng Anh và tiếng Việt.
class _LanguageBreakdown extends StatelessWidget {
  final TypingReport report;

  const _LanguageBreakdown({required this.report});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final peak = report.languages
        .fold(0.0, (m, l) => l.averageWpm > m ? l.averageWpm : m);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (final l in report.languages)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(l.language.label,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        'TB ${l.averageWpm.toStringAsFixed(0)}'
                        ' · tốt nhất ${l.bestWpm.toStringAsFixed(0)} WPM',
                        style: TextStyle(
                            fontSize: 12, color: colors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: peak == 0 ? 0 : l.averageWpm / peak,
                      minHeight: 6,
                      backgroundColor: colors.surfaceAlt,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colors.accent),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                      '${l.tests} bài · chính xác '
                      '${(l.averageAccuracy * 100).round()}%',
                      style: TextStyle(
                          fontSize: 11, color: colors.textMuted)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final TypingResult result;
  final VoidCallback onDelete;

  const _ResultTile({required this.result, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final r = result;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        leading: Icon(Icons.keyboard_alt_outlined, color: colors.accent),
        title: Text(
          '${r.wpm.toStringAsFixed(1)} WPM'
          ' · ${(r.accuracy * 100).round()}%',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${formatDayShort(r.takenAt)} ${formatClock(r.takenAt)}'
          ' · ${r.language.label} · ${r.mode.label} · ${r.elapsedSeconds}s',
          style: TextStyle(fontSize: 12, color: colors.textMuted),
        ),
        trailing: IconButton(
          icon: Icon(Icons.close, size: 18, color: colors.textDisabled),
          onPressed: r.id == null ? null : onDelete,
        ),
      ),
    );
  }
}
