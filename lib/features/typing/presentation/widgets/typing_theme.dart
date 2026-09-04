import 'package:flutter/material.dart';

/// Bảng màu dùng chung cho trang gõ phím và lịch sử.
const kTypingAccent = Color(0xFF4C8DFF);
const kTypingBackground = Color(0xFFFDF7F2);
const kTypingInk = Color(0xFF1C1C1E);
const kTypingMuted = Color(0xFF8E8E93);
const kTypingWrong = Color(0xFFE53935);

/// "1h 25m" / "25m" / "40s" cho thời lượng đã luyện.
String formatTypingDuration(int seconds) {
  if (seconds < 60) return '${seconds}s';
  final minutes = seconds ~/ 60;
  if (minutes < 60) return '${minutes}m';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}

String formatDayShort(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

String formatClock(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
