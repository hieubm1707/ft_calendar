// Màu của trang gõ phím lấy từ `context.colors` (typing / textPrimary /
// textMuted / danger) — file này chỉ còn các hàm định dạng dùng chung.

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
