import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Bọc flutter_local_notifications: khởi tạo, xin quyền, đặt/huỷ lịch nhắc.
@lazySingleton
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'event_reminders';

  /// Gọi 1 lần lúc khởi động app.
  Future<void> init() async {
    if (kIsWeb) return; // flutter_local_notifications không hỗ trợ web.
    tz.initializeTimeZones();
    try {
      final localName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localName));
    } catch (_) {
      // Giữ mặc định (UTC) nếu không lấy được timezone thiết bị.
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(
          android: androidInit, iOS: darwinInit, macOS: darwinInit),
    );
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);

    // macOS có implementation riêng — resolve theo IOSFlutterLocal... trả null,
    // nên nếu thiếu dòng này thông báo pomodoro trên macOS sẽ im lặng.
    final macos = _plugin.resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>();
    await macos?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Đặt nhắc cho sự kiện tại thời điểm bắt đầu (bỏ qua nếu ở quá khứ).
  Future<void> scheduleEventReminder({
    required int id,
    required String title,
    required DateTime when,
  }) async {
    if (kIsWeb) return;
    if (!when.isAfter(DateTime.now())) return;
    await _plugin.zonedSchedule(
      id,
      'Nhắc lịch',
      title,
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Nhắc sự kiện',
          channelDescription: 'Thông báo nhắc sự kiện đã lên lịch',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Báo ngay lập tức (dùng khi một phiên pomodoro kết thúc).
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return;
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Nhắc sự kiện',
          channelDescription: 'Thông báo nhắc sự kiện đã lên lịch',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// Nhắc lặp lại lúc [minutes] (phút từ 0h): mỗi ngày nếu [weekday] null,
  /// ngược lại mỗi tuần vào thứ [weekday] (1..7 = T2..CN). Lần đầu không sớm
  /// hơn [notBefore] (vd. ngày bắt đầu của mục tiêu).
  Future<void> scheduleRepeatingReminder({
    required int id,
    required String title,
    required String body,
    required int minutes,
    int? weekday,
    DateTime? notBefore,
  }) async {
    if (kIsWeb) return;
    final now = tz.TZDateTime.now(tz.local);
    final from = notBefore != null && notBefore.isAfter(now)
        ? tz.TZDateTime.from(notBefore, tz.local)
        : now;
    var when = tz.TZDateTime(
        tz.local, from.year, from.month, from.day, minutes ~/ 60, minutes % 60);
    while (when.isBefore(from) ||
        (weekday != null && when.weekday != weekday)) {
      when = tz.TZDateTime(tz.local, when.year, when.month, when.day + 1,
          when.hour, when.minute);
    }
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      when,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Nhắc sự kiện',
          channelDescription: 'Thông báo nhắc sự kiện đã lên lịch',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: weekday == null
          ? DateTimeComponents.time
          : DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Đặt 1 thông báo nổ đúng 1 lần lúc [when] (bỏ qua nếu ở quá khứ).
  Future<void> scheduleOnce({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    if (kIsWeb) return;
    if (!when.isAfter(DateTime.now())) return;
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Nhắc sự kiện',
          channelDescription: 'Thông báo nhắc sự kiện đã lên lịch',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Id các thông báo đang chờ nổ.
  Future<List<int>> pendingIds() async => kIsWeb
      ? const []
      : (await _plugin.pendingNotificationRequests()).map((r) => r.id).toList();

  /// Huỷ nhắc của một sự kiện.
  Future<void> cancel(int id) async {
    if (kIsWeb) return;
    await _plugin.cancel(id);
  }

  /// Huỷ nhiều nhắc cùng lúc.
  Future<void> cancelMany(Iterable<int> ids) async {
    if (kIsWeb) return;
    for (final id in ids) {
      await _plugin.cancel(id);
    }
  }
}
