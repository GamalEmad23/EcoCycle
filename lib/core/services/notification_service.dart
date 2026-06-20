import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationMessage {
  final String title;
  final String body;
  final DateTime time;

  NotificationMessage({
    required this.title,
    required this.body,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'time': time.toIso8601String(),
      };

  factory NotificationMessage.fromJson(Map<String, dynamic> json) =>
      NotificationMessage(
        title: json['title'] as String,
        body: json['body'] as String,
        time: DateTime.parse(json['time'] as String),
      );
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _unreadKey = 'unread_notifications_count';
  static const String _historyKey = 'notifications_history';

  // ────────────────────────────────────────────────────────────────────────────
  // Initialise – call once from main()
  // ────────────────────────────────────────────────────────────────────────────
  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);

    // Request Android 13+ permission
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Show a local notification
  // ────────────────────────────────────────────────────────────────────────────
  Future<void> showRecyclingSuccessNotification({
    String title = '♻️ طلب إعادة التدوير',
    String body = 'تم تقديم طلبك بنجاح! شكراً لمساهمتك في حماية البيئة 🌱',
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'recycling_channel',
      'Recycling Notifications',
      channelDescription: 'Notifications for recycling request submissions',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
      color: Color(0xFF4CAF50),
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _plugin.show(id, title, body, details);

    // Save to history & increment unread counter
    await _saveToHistory(title, body);
    await _incrementUnreadCount();
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Notification history
  // ────────────────────────────────────────────────────────────────────────────
  Future<void> _saveToHistory(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    final msg = NotificationMessage(
      title: title,
      body: body,
      time: DateTime.now(),
    );
    raw.insert(0, jsonEncode(msg.toJson())); // newest first
    // Keep max 50 messages
    if (raw.length > 50) raw.removeLast();
    await prefs.setStringList(_historyKey, raw);
  }

  Future<List<NotificationMessage>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    return raw
        .map((e) => NotificationMessage.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    await prefs.setInt(_unreadKey, 0);
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Unread count helpers
  // ────────────────────────────────────────────────────────────────────────────
  Future<int> getUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_unreadKey) ?? 0;
  }

  Future<void> _incrementUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_unreadKey) ?? 0;
    await prefs.setInt(_unreadKey, current + 1);
  }

  Future<void> clearUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_unreadKey, 0);
  }
}
