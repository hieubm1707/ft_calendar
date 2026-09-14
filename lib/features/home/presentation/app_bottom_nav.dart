import 'package:flutter/material.dart';

/// Thanh điều hướng chính (Bottom Navigation Bar) chỉ chứa 2 Tab: Trang chủ (Home) và Cài đặt (Settings)
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      height: 64,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFFF5252).withValues(alpha: 0.15),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: Color(0xFFFF5252)),
          label: 'Trang chủ',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings, color: Color(0xFFFF5252)),
          label: 'Cài đặt',
        ),
      ],
    );
  }
}
