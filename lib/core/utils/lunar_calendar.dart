import 'dart:math';

/// Kết quả chuyển đổi dương → âm lịch.
class LunarDate {
  final int day;
  final int month;
  final int year;
  final bool isLeap;

  const LunarDate(this.day, this.month, this.year, this.isLeap);
}

/// Chuyển ngày dương lịch sang âm lịch (thuật toán Hồ Ngọc Đức),
/// mặc định múi giờ +7 (Việt Nam). Dùng cho số âm lịch nhỏ dưới mỗi ô ngày.
LunarDate solarToLunar(DateTime date, {double timeZone = 7}) {
  final dayNumber = _jdFromDate(date.day, date.month, date.year);
  final k = ((dayNumber - 2415021.076998695) / 29.530588853).floor();
  var monthStart = _newMoonDay(k + 1, timeZone);
  if (monthStart > dayNumber) {
    monthStart = _newMoonDay(k, timeZone);
  }
  var a11 = _lunarMonth11(date.year, timeZone);
  var b11 = a11;
  int lunarYear;
  if (a11 >= monthStart) {
    lunarYear = date.year;
    a11 = _lunarMonth11(date.year - 1, timeZone);
  } else {
    lunarYear = date.year + 1;
    b11 = _lunarMonth11(date.year + 1, timeZone);
  }
  final lunarDay = dayNumber - monthStart + 1;
  final diff = ((monthStart - a11) / 29).floor();
  var lunarLeap = false;
  var lunarMonth = diff + 11;
  if (b11 - a11 > 365) {
    final leapMonthDiff = _leapMonthOffset(a11, timeZone);
    if (diff >= leapMonthDiff) {
      lunarMonth = diff + 10;
      if (diff == leapMonthDiff) lunarLeap = true;
    }
  }
  if (lunarMonth > 12) lunarMonth -= 12;
  if (lunarMonth >= 11 && diff < 4) lunarYear -= 1;
  return LunarDate(lunarDay, lunarMonth, lunarYear, lunarLeap);
}

int _jdFromDate(int dd, int mm, int yy) {
  final a = ((14 - mm) / 12).floor();
  final y = yy + 4800 - a;
  final m = mm + 12 * a - 3;
  var jd = dd +
      ((153 * m + 2) / 5).floor() +
      365 * y +
      (y / 4).floor() -
      (y / 100).floor() +
      (y / 400).floor() -
      32045;
  if (jd < 2299161) {
    jd = dd + ((153 * m + 2) / 5).floor() + 365 * y + (y / 4).floor() - 32083;
  }
  return jd;
}

double _newMoon(int k) {
  final t = k / 1236.85;
  final t2 = t * t;
  final t3 = t2 * t;
  final dr = pi / 180;
  var jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3;
  jd1 += 0.00033 * sin((166.56 + 132.87 * t - 0.009173 * t2) * dr);
  final m = 359.2242 + 29.10535608 * k - 0.0000333 * t2 - 0.00000347 * t3;
  final mpr = 306.0253 + 385.81691806 * k + 0.0107306 * t2 + 0.00001236 * t3;
  final f = 21.2964 + 390.67050646 * k - 0.0016528 * t2 - 0.00000239 * t3;
  var c1 = (0.1734 - 0.000393 * t) * sin(m * dr) + 0.0021 * sin(2 * dr * m);
  c1 = c1 - 0.4068 * sin(mpr * dr) + 0.0161 * sin(dr * 2 * mpr);
  c1 = c1 - 0.0004 * sin(dr * 3 * mpr);
  c1 = c1 + 0.0104 * sin(dr * 2 * f) - 0.0051 * sin(dr * (m + mpr));
  c1 = c1 - 0.0074 * sin(dr * (m - mpr)) + 0.0004 * sin(dr * (2 * f + m));
  c1 = c1 - 0.0004 * sin(dr * (2 * f - m)) - 0.0006 * sin(dr * (2 * f + mpr));
  c1 = c1 + 0.0010 * sin(dr * (2 * f - mpr)) + 0.0005 * sin(dr * (2 * mpr + m));
  final double deltat;
  if (t < -11) {
    deltat = 0.001 +
        0.000839 * t +
        0.0002261 * t2 -
        0.00000845 * t3 -
        0.000000081 * t * t3;
  } else {
    deltat = -0.000278 + 0.000265 * t + 0.000262 * t2;
  }
  return jd1 + c1 - deltat;
}

double _sunLongitude(double jdn) {
  final t = (jdn - 2451545.0) / 36525;
  final t2 = t * t;
  final dr = pi / 180;
  final m = 357.52910 + 35999.05030 * t - 0.0001559 * t2 - 0.00000048 * t * t2;
  final l0 = 280.46645 + 36000.76983 * t + 0.0003032 * t2;
  var dl = (1.914600 - 0.004817 * t - 0.000014 * t2) * sin(dr * m);
  dl = dl + (0.019993 - 0.000101 * t) * sin(dr * 2 * m) + 0.000290 * sin(dr * 3 * m);
  var l = (l0 + dl) * dr;
  l = l - 2 * pi * (l / (2 * pi)).floor();
  return l;
}

int _sunLongitudeInt(int dayNumber, double timeZone) {
  return (_sunLongitude(dayNumber - 0.5 - timeZone / 24) / pi * 6).floor();
}

int _newMoonDay(int k, double timeZone) {
  return (_newMoon(k) + 0.5 + timeZone / 24).floor();
}

int _lunarMonth11(int yy, double timeZone) {
  final off = _jdFromDate(31, 12, yy) - 2415021;
  final k = (off / 29.530588853).floor();
  var nm = _newMoonDay(k, timeZone);
  if (_sunLongitudeInt(nm, timeZone) >= 9) {
    nm = _newMoonDay(k - 1, timeZone);
  }
  return nm;
}

int _leapMonthOffset(int a11, double timeZone) {
  final k = ((a11 - 2415021.076998695) / 29.530588853 + 0.5).floor();
  var last = 0;
  var i = 1;
  var arc = _sunLongitudeInt(_newMoonDay(k + i, timeZone), timeZone);
  do {
    last = arc;
    i++;
    arc = _sunLongitudeInt(_newMoonDay(k + i, timeZone), timeZone);
  } while (arc != last && i < 14);
  return i - 1;
}
