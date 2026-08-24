import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/index.dart';
import 'features/pomodoro/presentation/index.dart';
import 'features/shell/presentation/main_shell.dart';

class FtCalendarApp extends StatelessWidget {
  const FtCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Đồng hồ pomodoro là singleton, cung cấp ở gốc để trang Focus, cửa sổ nổi
    // và menu bar macOS cùng nhìn một trạng thái. `.value` → không bị đóng.
    return BlocProvider<PomodoroCubit>.value(
      value: getIt<PomodoroCubit>(),
      child: MaterialApp(
        title: 'FT Calendar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B3A6)),
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}
