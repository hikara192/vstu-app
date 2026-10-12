import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config.dart';
import '../../../core/providers.dart';
import '../domain/app_settings.dart';

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AppSettings(
      themeMode: _read(
        prefs,
        AppConfig.themeModeKey,
        AppThemeMode.values,
        AppSettings.defaults.themeMode,
      ),
      accent: _read(
        prefs,
        AppConfig.accentKey,
        AccentColor.values,
        AppSettings.defaults.accent,
      ),
      startScreen: _read(
        prefs,
        AppConfig.startScreenKey,
        StartScreen.values,
        AppSettings.defaults.startScreen,
      ),
      notificationsEnabled:
          prefs.getBool(AppConfig.notificationsEnabledKey) ??
          AppSettings.defaults.notificationsEnabled,
    );
  }

  Future<void> setThemeMode(AppThemeMode value) async {
    state = state.copyWith(themeMode: value);
    await _persist(AppConfig.themeModeKey, value.name);
  }

  Future<void> setAccent(AccentColor value) async {
    state = state.copyWith(accent: value);
    await _persist(AppConfig.accentKey, value.name);
  }

  Future<void> setStartScreen(StartScreen value) async {
    state = state.copyWith(startScreen: value);
    await _persist(AppConfig.startScreenKey, value.name);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    try {
      await ref
          .read(sharedPreferencesProvider)
          .setBool(AppConfig.notificationsEnabledKey, value);
    } catch (_) {}
  }

  Future<void> _persist(String key, String name) async {
    try {
      await ref.read(sharedPreferencesProvider).setString(key, name);
    } catch (_) {}
  }

  static T _read<T extends Enum>(
    SharedPreferences prefs,
    String key,
    List<T> values,
    T fallback,
  ) {
    final name = prefs.getString(key);
    if (name == null) return fallback;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return fallback;
  }
}

final appSettingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);
