import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../domain/lesson_reminder.dart';

class LocalNotificationsService {
  LocalNotificationsService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const String _channelId = 'lesson_reminders';
  static const String _iconName = 'ic_stat_reminder';

  static const AndroidNotificationDetails _details = AndroidNotificationDetails(
    _channelId,
    'Напоминания о парах',
    channelDescription: 'Напоминания за 10 минут до начала пары.',
    importance: Importance.high,
    priority: Priority.high,
    icon: _iconName,
  );

  static Future<LocalNotificationsService> create() async {
    tz_data.initializeTimeZones();
    await _setLocalLocation();

    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_stat_reminder'),
      ),
    );
    return LocalNotificationsService(plugin);
  }

  static Future<void> _setLocalLocation() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {}
  }

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  Future<bool> requestPermissions() async {
    final android = _android;
    if (android == null) return true;
    final granted = await android.requestNotificationsPermission() ?? true;
    if (granted && !await canScheduleExact()) {
      try {
        await android.requestExactAlarmsPermission();
      } catch (_) {}
    }
    return granted;
  }

  Future<bool> canScheduleExact() async {
    final android = _android;
    if (android == null) return false;
    try {
      return await android.canScheduleExactNotifications() ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> applyPlan(List<LessonReminder> reminders) async {
    await _plugin.cancelAll();
    final mode = await canScheduleExact()
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    final now = tz.TZDateTime.now(tz.local);

    for (final reminder in reminders) {
      final at = tz.TZDateTime(
        tz.local,
        reminder.when.year,
        reminder.when.month,
        reminder.when.day,
        reminder.when.hour,
        reminder.when.minute,
      );
      if (!at.isAfter(now)) {
        continue;
      }
      await _schedule(reminder, at, mode);
    }
  }

  Future<void> _schedule(
    LessonReminder reminder,
    tz.TZDateTime at,
    AndroidScheduleMode mode,
  ) async {
    try {
      await _plugin.zonedSchedule(
        id: reminder.id,
        title: reminder.title,
        body: reminder.body,
        scheduledDate: at,
        notificationDetails: const NotificationDetails(android: _details),
        androidScheduleMode: mode,
      );
    } catch (_) {
      if (mode == AndroidScheduleMode.inexactAllowWhileIdle) {
        return;
      }
      try {
        await _plugin.zonedSchedule(
          id: reminder.id,
          title: reminder.title,
          body: reminder.body,
          scheduledDate: at,
          notificationDetails: const NotificationDetails(android: _details),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (_) {}
    }
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (_) {}
  }
}
