import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/index.dart';

/// Lưu bộ nhắc Tracking vào SharedPreferences dưới dạng chuỗi JSON (mảng object).
abstract class TrackingReminderLocalDataSource {
  /// null = người dùng chưa từng lưu (dùng bộ mặc định).
  Future<List<Map<String, dynamic>>?> getRules();

  Future<void> saveRules(List<Map<String, dynamic>> rules);
}

@LazySingleton(as: TrackingReminderLocalDataSource)
class TrackingReminderLocalDataSourceImpl
    implements TrackingReminderLocalDataSource {
  static const _key = 'tracking_reminder_rules';

  @override
  Future<List<Map<String, dynamic>>?> getRules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> saveRules(List<Map<String, dynamic>> rules) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(rules));
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
