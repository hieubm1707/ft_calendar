import '../../domain/index.dart';

const kWeekdayShort = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

/// Bảng màu chọn cho mục tiêu (dữ liệu người dùng nên giữ hex). Mặc định = màu nhấn.
const kTrackingColors = <int>[
  TrackingGoal.defaultColor,
  0xFF9B7BF0,
  0xFFEF5B78,
  0xFFF2A33A,
  0xFF2DBE8F,
  0xFF22A9E0,
  0xFFEC407A,
  0xFF5C6BC0,
];

String two(int n) => n.toString().padLeft(2, '0');

String fmtDate(DateTime d) => '${two(d.day)}/${two(d.month)}/${d.year}';

String fmtMinutes(int m) => '${two(m ~/ 60)}:${two(m % 60)}';

/// "Hằng ngày" hoặc "T2, T4, T6".
String frequencyLabel(TrackingGoal goal) {
  if (goal.frequency == TrackingFrequency.daily ||
      goal.activeWeekdays.length == 7) {
    return 'Hằng ngày';
  }
  final days = goal.activeWeekdays.toList()..sort();
  return days.map((w) => kWeekdayShort[w - 1]).join(', ');
}

/// "Hôm nay", "Hôm qua" hoặc "T5, 23/10".
String dayTitle(DateTime day, DateTime today) {
  final diff = DateTime(
    today.year,
    today.month,
    today.day,
  ).difference(DateTime(day.year, day.month, day.day)).inDays;
  if (diff == 0) return 'Hôm nay';
  if (diff == 1) return 'Hôm qua';
  return '${kWeekdayShort[day.weekday - 1]}, ${day.day}/${day.month}';
}
