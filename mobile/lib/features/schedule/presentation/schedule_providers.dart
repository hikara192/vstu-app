import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/offline_notice.dart';
import '../../../core/providers.dart';
import '../data/schedule_data_source.dart';
import '../data/schedule_models.dart';
import '../data/schedule_repository.dart';
import '../domain/schedule_builder.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository(
    UniScheduleDataSource(ref.watch(uniApiClientProvider)),
    ref.watch(sharedPreferencesProvider),
    ({required bool servedFromCache}) {
      final notice = ref.read(isOfflineNoticeVisibleProvider.notifier);
      if (servedFromCache) {
        notice.show();
      } else {
        notice.hide();
      }
    },
  );
});

final semesterScheduleProvider = FutureProvider.family<GroupSchedule, int>((
  ref,
  groupId,
) async {
  return ref.watch(scheduleRepositoryProvider).fetchSemesterSchedule(groupId);
});

final scheduleBuilderProvider = FutureProvider.family<ScheduleBuilder, int>((
  ref,
  groupId,
) async {
  final schedule = await ref.watch(semesterScheduleProvider(groupId).future);
  return ScheduleBuilder(
    semesterStart: schedule.semesterStart,
    lessons: schedule.lessons,
    weekAnchor: schedule.weekAnchor,
  );
});

class WeekOffsetNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void next() => state++;
  void previous() => state--;
  void reset() => state = 0;
}

final weekOffsetProvider = NotifierProvider<WeekOffsetNotifier, int>(
  WeekOffsetNotifier.new,
);
