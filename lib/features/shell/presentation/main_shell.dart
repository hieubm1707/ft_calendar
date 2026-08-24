import 'package:flutter/material.dart';

import '../../calendar/presentation/index.dart';
import '../../pomodoro/presentation/index.dart';
import '../../tasks/presentation/index.dart';
import 'app_bottom_nav.dart';

/// Khung chính: bottom nav chuyển giữa Discover / Calendar / Tasks / Notes.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 1; // mặc định tab Calendar

  static const _pages = [
    _Placeholder(label: 'Discover'),
    CalendarPage(),
    TasksPage(),
    PomodoroPage(),
    _Placeholder(label: 'Notes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String label;

  const _Placeholder({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      body: Center(
        child: Text('$label\nSắp ra mắt',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 16)),
      ),
    );
  }
}
