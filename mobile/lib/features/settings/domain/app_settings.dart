import 'package:flutter/material.dart';

enum AppThemeMode {
  system('Системная', 'Переключается вместе с телефоном'),

  light('Светлая', 'Светлый фон даже вечером'),

  dark('Тёмная', 'Серые поверхности, как в обычной тёмной теме'),

  amoled('AMOLED', 'Чистый чёрный');

  const AppThemeMode(this.title, [this.description = '']);

  final String title;

  final String description;

  ThemeMode get materialMode => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark || AppThemeMode.amoled => ThemeMode.dark,
  };

  bool get isAmoled => this == AppThemeMode.amoled;
}

enum AccentColor {
  vstuBlue(0xFF1B5E9C, 'Синий'),
  green(0xFF2E7D32, 'Зелёный'),
  teal(0xFF00796B, 'Бирюзовый'),
  purple(0xFF6A4C93, 'Фиолетовый'),
  orange(0xFFB26A00, 'Оранжевый');

  const AccentColor(this.value, this.title);

  final int value;

  final String title;

  Color get color => Color(value);
}

enum StartScreen {
  auto('Умный', 'Сразу моё расписание, пока группа не выбрана — список групп'),

  groups('Всегда список групп', 'Каждый раз открывать поиск группы');

  const StartScreen(this.title, this.description);

  final String title;

  final String description;
}

class AppSettings {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.accent = AccentColor.vstuBlue,
    this.startScreen = StartScreen.auto,
    this.notificationsEnabled = false,
  });

  static const AppSettings defaults = AppSettings();

  final AppThemeMode themeMode;
  final AccentColor accent;
  final StartScreen startScreen;
  final bool notificationsEnabled;

  Color get seed => accent.color;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    AccentColor? accent,
    StartScreen? startScreen,
    bool? notificationsEnabled,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    accent: accent ?? this.accent,
    startScreen: startScreen ?? this.startScreen,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          other.themeMode == themeMode &&
          other.accent == accent &&
          other.startScreen == startScreen &&
          other.notificationsEnabled == notificationsEnabled;

  @override
  int get hashCode =>
      Object.hash(themeMode, accent, startScreen, notificationsEnabled);
}
