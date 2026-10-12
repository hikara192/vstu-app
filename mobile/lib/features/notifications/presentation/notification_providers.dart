import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config.dart';
import '../../../core/providers.dart';
import '../../groups/presentation/groups_providers.dart';
import '../../schedule/domain/schedule_builder.dart';
import '../../schedule/presentation/schedule_providers.dart';
import '../../settings/data/settings_controller.dart';
import '../data/local_notifications_service.dart';
import '../domain/lesson_reminder.dart';

final localNotificationsServiceProvider = Provider<LocalNotificationsService?>(
  (ref) => null,
);

final lessonReminderSyncProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(localNotificationsServiceProvider);
  if (service == null) return;

  final enabled = ref.watch(
    appSettingsProvider.select((settings) => settings.notificationsEnabled),
  );
  final group = ref.watch(selectedGroupProvider);
  final prefs = ref.read(sharedPreferencesProvider);

  if (!enabled || group == null) {
    await service.cancelAll();
    await prefs.remove(AppConfig.remindersPlanFingerprintKey);
    return;
  }

  final schedule = ref.watch(semesterScheduleProvider(group.id));
  if (!schedule.hasValue) return;

  final data = schedule.requireValue;
  final builder = ScheduleBuilder(
    semesterStart: data.semesterStart,
    lessons: data.lessons,
    weekAnchor: data.weekAnchor,
  );
  final reminders = const LessonReminderPlanner().plan(
    builder,
    from: DateTime.now(),
  );

  // Планируем заново только если план действительно изменился — иначе
  // каждый запуск приложения дёргал бы cancelAll + десятки zonedSchedule.
  final fingerprint = _remindersFingerprint(reminders);
  if (prefs.getString(AppConfig.remindersPlanFingerprintKey) == fingerprint) {
    return;
  }

  await service.applyPlan(reminders);
  await prefs.setString(AppConfig.remindersPlanFingerprintKey, fingerprint);
});

/// Детерминированный отпечаток плана напоминаний: если расписание (или
/// лид, или сами пары) не менялись, уведомления не пересоздаются.
String _remindersFingerprint(List<LessonReminder> reminders) {
  final buffer = StringBuffer();
  for (final reminder in reminders) {
    buffer
      ..write(reminder.id)
      ..write('@')
      ..write(reminder.when.millisecondsSinceEpoch)
      ..write('#')
      ..write(reminder.title)
      ..write('|')
      ..write(reminder.body)
      ..write('\n');
  }
  // FNV-1a 32-bit — стабилен между запусками (в отличие от Object.hash).
  var hash = 0x811c9dc5;
  const prime = 0x01000193;
  for (final unit in buffer.toString().codeUnits) {
    hash = ((hash ^ unit) * prime) & 0xFFFFFFFF;
  }
  return hash.toRadixString(16);
}
