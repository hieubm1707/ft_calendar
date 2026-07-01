import 'package:flutter/material.dart';

import 'features/calendar/presentation/index.dart';

class FtCalendarApp extends StatelessWidget {
  const FtCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FT Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B3A6)),
        useMaterial3: true,
      ),
      home: const CalendarPage(),
    );
  }
}
