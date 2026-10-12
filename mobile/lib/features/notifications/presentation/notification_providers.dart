import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  if (!enabled || group == null) {
    await service.cancelAll();
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
  await service.applyPlan(reminders);
});
