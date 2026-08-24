import 'package:flutter/material.dart';

import 'app.dart';
import 'core/desktop/index.dart';
import 'core/di/injection.dart';
import 'core/home_widget/index.dart';
import 'core/notifications/index.dart';
import 'features/pomodoro/presentation/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await getIt<NotificationService>().init();
  // window_manager phải khởi tạo TRƯỚC runApp.
  await getIt<DesktopWindowService>().init();
  final widgetService = getIt<HomeWidgetService>();
  await widgetService.init();
  runApp(const FtCalendarApp());
  // renderFlutterWidget cần có frame/view → render sau khi UI dựng xong.
  // setIcon của menu bar cũng đọc asset qua rootBundle nên chờ frame đầu.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    widgetService.refreshAll();
    getIt<PomodoroCubit>().load();
    getIt<PomodoroTrayController>().start();
  });
}
