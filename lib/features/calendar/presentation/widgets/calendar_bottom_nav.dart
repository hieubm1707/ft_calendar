import 'package:flutter/material.dart';

/// Thanh điều hướng dưới cùng (Discover / Calendar / Tasks / Notes).
/// v1: chỉ hiển thị, Calendar được chọn sẵn.
class CalendarBottomNav extends StatelessWidget {
  const CalendarBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
      child: NavigationBar(
        selectedIndex: 1,
        height: 64,
        backgroundColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            label: 'Notes',
          ),
        ],
      ),
    );
  }
}
