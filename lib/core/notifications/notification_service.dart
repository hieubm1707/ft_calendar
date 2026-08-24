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
  }

  /// Đặt nhắc cho sự kiện tại thời điểm bắt đầu (bỏ qua nếu ở quá khứ).
  Future<void> scheduleEventReminder({
    required int id,
    required String title,
    required DateTime when,
  }) async {
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

  /// Huỷ nhắc của một sự kiện.
  Future<void> cancel(int id) => _plugin.cancel(id);
}
