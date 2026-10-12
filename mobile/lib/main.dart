import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/providers.dart';
import 'features/notifications/data/local_notifications_service.dart';
import 'features/notifications/presentation/notification_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final notifications = await _createNotifications();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        if (notifications != null)
          localNotificationsServiceProvider.overrideWithValue(notifications),
      ],
      child: const VstuApp(),
    ),
  );
}

Future<LocalNotificationsService?> _createNotifications() async {
  try {
    return await LocalNotificationsService.create();
  } catch (_) {
    return null;
  }
}
