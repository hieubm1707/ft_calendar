import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/notifications/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await getIt<NotificationService>().init();
  runApp(const FtCalendarApp());
}
