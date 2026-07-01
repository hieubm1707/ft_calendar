import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/home_widget/index.dart';
import 'core/notifications/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await getIt<NotificationService>().init();
  final widgetService = getIt<HomeWidgetService>();
  await widgetService.init();
  runApp(const FtCalendarApp());
  // renderFlutterWidget cần có frame/view → render sau khi UI dựng xong.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    widgetService.refreshAll();
  });
}
