import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/desktop/index.dart';
import 'core/di/injection.dart';
import 'core/home_widget/index.dart';
import 'core/notifications/index.dart';
import 'features/pomodoro/presentation/index.dart';
import 'features/settings/presentation/index.dart';
import 'features/tracking/presentation/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  if (kIsWeb) return _runWebFocus();
  await getIt<NotificationService>().init();
  // window_manager phải khởi tạo TRƯỚC runApp.
  await getIt<DesktopWindowService>().init();
  final widgetService = getIt<HomeWidgetService>();
  await widgetService.init();
  // Đọc chế độ Sáng/Tối trước khi dựng UI → không chớp nền sáng khi mở app.
  await getIt<AppearanceCubit>().load();
  runApp(const FtCalendarApp());
  // renderFlutterWidget cần có frame/view → render sau khi UI dựng xong.
  // setIcon của menu bar cũng đọc asset qua rootBundle nên chờ frame đầu.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    widgetService.refreshAll();
    getIt<PomodoroCubit>().load();
    getIt<PomodoroTrayController>().start();
    // Đặt lại nhắc Tracking theo % hoàn thành + theo dõi app ra/vào nền.
    getIt<TrackingReminderSync>().start();
  });
}

/// Bản web chỉ mở tính năng Focus: bỏ qua thông báo, widget OS, menu bar,
/// nhắc Tracking (đều là native). DB chạy bằng sqlite3.wasm.
Future<void> _runWebFocus() async {
  await getIt<AppearanceCubit>().load();
  runApp(const FtCalendarApp());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    getIt<PomodoroCubit>().load();
  });
}
