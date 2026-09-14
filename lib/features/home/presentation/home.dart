import 'package:flutter/material.dart';

import '../../../core/desktop/index.dart';
import '../../../core/di/index.dart';
import '../../pomodoro/presentation/index.dart';
import '../../settings/presentation/pages/settings_page.dart';
import 'app_bottom_nav.dart';
import 'home_page.dart';

/// Khung chính Home chứa 2 trang: Trang chủ (HomePage) và Cài đặt (SettingsPage).
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0; // 0: Trang chủ, 1: Cài đặt

  static const _pages = [
    HomePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // macOS: khi bật cửa sổ nổi nhỏ thì thu về đúng đồng hồ, bỏ bottom nav.
    return ValueListenableBuilder<bool>(
      valueListenable: getIt<DesktopWindowService>().miniMode,
      builder: (context, mini, _) {
        if (mini) return const PomodoroMiniView();
        return Scaffold(
          body: IndexedStack(index: _index, children: _pages),
          bottomNavigationBar: AppBottomNav(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
          ),
        );
      },
    );
  }
}
