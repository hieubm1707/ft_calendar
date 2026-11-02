import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/index.dart';
import '../../domain/index.dart';
import '../cubit/appearance_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cài Đặt',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const _SectionTitle('GIAO DIỆN'),
                  _SettingsCard(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              _LeadingIcon(
                                icon: Icons.palette_outlined,
                                color: colors.accent,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Chế độ hiển thị',
                                  style: TextStyle(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          BlocBuilder<AppearanceCubit, AppThemeMode>(
                            builder: (context, mode) =>
                                SegmentedButton<AppThemeMode>(
                                  showSelectedIcon: false,
                                  style: SegmentedButton.styleFrom(
                                    selectedBackgroundColor: colors.accent
                                        .withValues(alpha: 0.15),
                                    selectedForegroundColor: colors.accent,
                                    foregroundColor: colors.textSecondary,
                                    side: BorderSide(color: colors.border),
                                  ),
                                  segments: const [
                                    ButtonSegment(
                                      value: AppThemeMode.light,
                                      icon: Icon(Icons.light_mode_outlined),
                                      label: Text('Sáng'),
                                    ),
                                    ButtonSegment(
                                      value: AppThemeMode.dark,
                                      icon: Icon(Icons.dark_mode_outlined),
                                      label: Text('Tối'),
                                    ),
                                  ],
                                  selected: {mode},
                                  onSelectionChanged: (s) => context
                                      .read<AppearanceCubit>()
                                      .setMode(s.first),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle('THÔNG BÁO'),
                  _SettingsCard(
                    child: SwitchListTile.adaptive(
                      value: _notificationsEnabled,
                      activeTrackColor: colors.accent,
                      activeThumbColor: Colors.white,

                      title: Text(
                        'Thông báo ứng dụng',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Bật/tắt thông báo nhắc lịch và thời gian Pomodoro',
                        style: TextStyle(color: colors.textMuted, fontSize: 13),
                      ),
                      secondary: _LeadingIcon(
                        icon: Icons.notifications_active,
                        color: colors.accent,
                      ),
                      onChanged: _toggleNotifications,
                    ),
                  ),
                ],
              ),
            ),

            // Footer hiển thị phiên bản ứng dụng
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 12),
              child: Column(
                children: [
                  Text(
                    'ft_calender',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Phiên bản 1.0.0 (Build 1)',
                    style: TextStyle(color: colors.textMuted, fontSize: 12),
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

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: context.colors.textMuted,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Thẻ trắng (nền `surface`) bo góc, viền mảnh + bóng nhẹ.
class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _LeadingIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
