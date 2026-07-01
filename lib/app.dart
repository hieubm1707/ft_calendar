import 'package:flutter/material.dart';

import 'features/events/presentation/pages/events_page.dart';

class FtCalendarApp extends StatelessWidget {
  const FtCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FT Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const EventsPage(),
    );
  }
}
