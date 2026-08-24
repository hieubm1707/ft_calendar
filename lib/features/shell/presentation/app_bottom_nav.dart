import 'package:flutter/material.dart';

/// Thanh điều hướng dưới cùng: Discover / Calendar / Tasks / Focus / Notes.
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
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.grid_view_outlined), label: 'Discover'),
        NavigationDestination(
            icon: Icon(Icons.calendar_today), label: 'Calendar'),
        NavigationDestination(
            icon: Icon(Icons.checklist_outlined), label: 'Tasks'),
        NavigationDestination(
            icon: Icon(Icons.timer_outlined), label: 'Focus'),
        NavigationDestination(
            icon: Icon(Icons.description_outlined), label: 'Notes'),
      ],
    );
  }
}
