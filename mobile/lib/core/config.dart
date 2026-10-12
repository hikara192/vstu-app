class AppConfig {
  const AppConfig._();

  /// Адрес системы дистанционного обучения (СДО) ВГТУ.
  static const String sdoUrl = 'https://sdo.vstu.by';

  /// Имя веб-сервиса Moodle, через который приложение работает с СДО.
  /// В настройках СДО должен быть включён мобильный сервис
  /// (`moodle_mobile_app`).
  static const String sdoWebService = 'moodle_mobile_app';

  /// Эндпоинт выдачи токена по логину и паролю (`/login/token.php`).
  static const String sdoTokenPath = '/login/token.php';

  /// REST-эндпоинт веб-сервисов Moodle (`/webservice/rest/server.php`).
  static const String sdoRestPath = '/webservice/rest/server.php';

  static const String apiBaseUrl = String.fromEnvironment(
    'UNI_API_BASE_URL',
    defaultValue: 'https://schedule.vstu.by/api/v1',
  );

  static const Duration connectTimeout = Duration(seconds: 7);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const String userAgent = 'vstu-app/0.1.0';

  static const Duration searchDebounce = Duration(milliseconds: 350);

  static const String selectedGroupIdKey = 'selected_group_id';
  static const String selectedGroupNameKey = 'selected_group_name';
  static const String groupsCacheKey = 'groups_cache_json';
  static const String scheduleCachePrefix = 'schedule_cache_';

  static const String themeModeKey = 'theme_mode';
  static const String accentKey = 'accent_color';
  static const String startScreenKey = 'start_screen';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String remindersPlanFingerprintKey = 'reminders_plan_fingerprint';

  /// Частота «тиков» глобальных часов. Используется только для смены дня
  /// и перехода состояния пары; плавный прогресс идёт через локальные
  /// таймеры виджета TimeProgress — поэтому секундный тик не нужен.
  static const Duration clockTick = Duration(seconds: 30);

  static const Duration lessonReminderLead = Duration(minutes: 5);
  static const int lessonReminderHorizonDays = 14;
}
