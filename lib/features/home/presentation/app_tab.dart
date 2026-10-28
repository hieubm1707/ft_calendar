import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AppTab {
  typing,
  calendar,
  tasks,
  tracking,
  focus,
  remote;

  String get label {
    switch (this) {
      case AppTab.typing:
        return 'Typing';
      case AppTab.calendar:
        return 'Calendar';
      case AppTab.tasks:
        return 'Tasks';
      case AppTab.tracking:
        return 'Tracking';
      case AppTab.focus:
        return 'Focus';
      case AppTab.remote:
        return 'Remote';
    }
  }

  IconData get iconData {
    switch (this) {
      case AppTab.typing:
        return Icons.keyboard_alt_outlined;
      case AppTab.calendar:
        return Icons.calendar_today;
      case AppTab.tasks:
        return Icons.checklist_outlined;
      case AppTab.tracking:
        return Icons.track_changes;
      case AppTab.focus:
        return Icons.timer_outlined;
      case AppTab.remote:
        return Icons.settings_remote_outlined;
    }
  }

  /// Lấy danh sách các tab theo Nền tảng (Platform Rules):
  /// - iOS, Android: Calendar, Tasks, Focus, Remote
  /// - MacOS, Web: Typing, Calendar, Tasks, Focus
  static List<AppTab> getAvailableTabs() {
    if (kIsWeb) {
      return [
        AppTab.typing,
        AppTab.calendar,
        AppTab.tasks,
        AppTab.tracking,
        AppTab.focus,
      ];
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return [
          AppTab.calendar,
          AppTab.tasks,
          AppTab.tracking,
          AppTab.focus,
          AppTab.remote,
        ];
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        return [
          AppTab.typing,
          AppTab.calendar,
          AppTab.tasks,
          AppTab.tracking,
          AppTab.focus,
        ];
    }
  }
}
