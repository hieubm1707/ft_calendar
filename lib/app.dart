import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/index.dart';
import 'core/theme/index.dart';
import 'features/home/presentation/home.dart';
import 'features/pomodoro/presentation/index.dart';
import 'features/settings/domain/index.dart';
import 'features/settings/presentation/index.dart';

class FtCalendarApp extends StatelessWidget {
  const FtCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Đồng hồ pomodoro là singleton, cung cấp ở gốc để trang Focus, cửa sổ nổi
    // và menu bar macOS cùng nhìn một trạng thái. `.value` → không bị đóng.
    // Chế độ Sáng/Tối cũng là singleton, đã `load()` trước runApp.
    return MultiBlocProvider(
      providers: [
        BlocProvider<PomodoroCubit>.value(value: getIt<PomodoroCubit>()),
        BlocProvider<AppearanceCubit>.value(value: getIt<AppearanceCubit>()),
      ],
      child: BlocBuilder<AppearanceCubit, AppThemeMode>(
        builder: (context, mode) => MaterialApp(
          title: kIsWeb ? 'Habitool Focus' : 'Habitool',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode == AppThemeMode.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          // Web chỉ mở tính năng Focus (các tính năng khác cần API native).
          home: kIsWeb ? const PomodoroPage() : const Home(),
        ),
      ),
    );
  }
}
