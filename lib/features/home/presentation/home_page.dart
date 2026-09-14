import 'package:flutter/material.dart';
import '../../calendar/presentation/index.dart';
import '../../pomodoro/presentation/index.dart';
import '../../remote/presentation/pages/remote_control_page.dart';
import '../../tasks/presentation/index.dart';
import '../../typing/presentation/index.dart';
import 'app_tab.dart';

/// Trang Home chứa GridView 3 cột hiển thị các tính năng theo Nền tảng
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _getFeaturePage(AppTab tab) {
    switch (tab) {
      case AppTab.typing:
        return const TypingPage();
      case AppTab.calendar:
        return const CalendarPage();
      case AppTab.tasks:
        return const TasksPage();
      case AppTab.focus:
        return const PomodoroPage();
      case AppTab.remote:
        return const RemoteControlPage();
    }
  }

  void _navigateToFeature(BuildContext context, AppTab tab) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _getFeaturePage(tab),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableTabs = AppTab.getAvailableTabs();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Trang chủ',
          style: TextStyle(
            color: Color(0xFF2C2C2E),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: availableTabs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final tab = availableTabs[index];
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 1,
              shadowColor: Colors.black.withAlpha(15),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _navigateToFeature(context, tab),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5252).withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tab.iconData,
                        size: 28,
                        color: const Color(0xFFFF5252),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tab.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

