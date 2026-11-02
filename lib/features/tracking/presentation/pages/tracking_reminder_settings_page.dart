import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import '../cubit/tracking_reminder_cubit.dart';
import '../widgets/reminder_rule_sheet.dart';
import '../widgets/tracking_format.dart';

/// Cài đặt Tracking → bộ nhắc chung: mỗi luật = giờ + điều kiện % hoàn thành
/// mục tiêu trong ngày (< hoặc =).
class TrackingReminderSettingsPage extends StatelessWidget {
  const TrackingReminderSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TrackingReminderCubit>()..load(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<TrackingReminderCubit>();
    final result = await showReminderRuleSheet(context);
    final rule = result?.rule;
    if (rule != null) await cubit.add(rule);
  }

  Future<void> _edit(BuildContext context, TrackingReminderRule rule) async {
    final cubit = context.read<TrackingReminderCubit>();
    final result = await showReminderRuleSheet(context, initial: rule);
    if (result == null) return;
    if (result.delete) {
      await cubit.remove(rule);
    } else if (result.rule != null) {
      await cubit.replace(rule, result.rule!);
    }
  }

  Future<void> _confirmReset(BuildContext context) async {
    final cubit = context.read<TrackingReminderCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Khôi phục mặc định?'),
        content: const Text(
          'Bộ nhắc hiện tại sẽ được thay bằng 4 nhắc mặc định '
          '(20:00, 21:00, 22:00, 23:00).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Khôi phục'),
          ),
        ],
      ),
    );
    if (ok == true) await cubit.resetDefaults();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocConsumer<TrackingReminderCubit, TrackingReminderState>(
      listenWhen: (p, c) => c.status == TrackingReminderStatus.failure,
      listener: (context, state) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Lỗi'))),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Nhắc nhở'),
            actions: [
              IconButton(
                tooltip: 'Khôi phục mặc định',
                icon: const Icon(Icons.restart_alt),
                onPressed: () => _confirmReset(context),
              ),
            ],
          ),
          floatingActionButton: state.canAdd
              ? FloatingActionButton(
                  tooltip: 'Thêm nhắc nhở',
                  onPressed: () => _add(context),
                  child: const Icon(Icons.add),
                )
              : null,
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
              children: [
                Text(
                  'Tới giờ đặt sẵn mà tỉ lệ mục tiêu đã hoàn thành trong ngày '
                  'thoả điều kiện thì app gửi thông báo nhắc. Ngày không có '
                  'mục tiêu nào thì không nhắc.',
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
                const SizedBox(height: 16),
                if (state.status == TrackingReminderStatus.success &&
                    state.rules.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Text(
                      'Chưa có nhắc nhở nào.\nNhấn + để thêm.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.textMuted),
                    ),
                  ),
                for (final rule in state.rules) ...[
                  _RuleTile(
                    rule: rule,
                    onTap: () => _edit(context, rule),
                    onToggle: () =>
                        context.read<TrackingReminderCubit>().toggle(rule),
                  ),
                  const SizedBox(height: 10),
                ],
                if (!state.canAdd)
                  Text(
                    'Tối đa ${TrackingReminderRule.maxRules} nhắc nhở.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: colors.textMuted),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RuleTile extends StatelessWidget {
  final TrackingReminderRule rule;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const _RuleTile({
    required this.rule,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final on = rule.enabled;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 10, 14),
          child: Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                color: on ? colors.accent : colors.textDisabled,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fmtMinutes(rule.minutes),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: on ? colors.textPrimary : colors.textDisabled,
                        fontFamily: AppFonts.tabular,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Nếu hoàn thành ${comparisonSymbol(rule.comparison)} '
                      '${rule.percent}%',
                      style: TextStyle(
                        fontSize: 13,
                        color: on ? colors.textSecondary : colors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: on,
                activeTrackColor: colors.accent,
                onChanged: (_) => onToggle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
