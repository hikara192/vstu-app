import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/plural.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/gradient_header.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/sdo_button.dart';
import '../../../core/widgets/skeleton.dart';
import '../data/schedule_models.dart';
import '../../settings/presentation/settings_screen.dart';
import 'schedule_providers.dart';
import 'week_content.dart';
import 'week_navigator.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key, required this.groupId});

  static const String routeName = 'schedule';

  final int groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleBuilderProvider(groupId));
    final semester = ref.watch(semesterScheduleProvider(groupId));
    final group = semester.hasValue ? semester.requireValue.group : null;
    final weekOffset = ref.watch(weekOffsetProvider);

    final now = ref.watch(clockProvider.select(dateOnly));
    final targetDate = now.add(Duration(days: 7 * weekOffset));
    final builder = scheduleAsync.hasValue ? scheduleAsync.requireValue : null;
    final weekInfo = builder?.weekOf(targetDate);

    void previousWeek() => ref.read(weekOffsetProvider.notifier).previous();
    void nextWeek() => ref.read(weekOffsetProvider.notifier).next();
    void goToToday() => ref.read(weekOffsetProvider.notifier).reset();

    Future<void> refresh() async {
      ref.invalidate(semesterScheduleProvider(groupId));
      try {
        await ref.read(semesterScheduleProvider(groupId).future);
      } catch (_) {}
    }

    final Widget body;
    if (builder != null) {
      body = WeekContent(
        builder: builder,
        targetDate: targetDate,
        now: now,
        weekOffset: weekOffset,
        onRefresh: refresh,
        onPreviousWeek: previousWeek,
        onNextWeek: nextWeek,
      );
    } else if (scheduleAsync case AsyncError(:final error)) {
      body = ErrorView(
        message: describeError(error),
        onRetry: () => unawaited(refresh()),
      );
    } else {
      body = const ScheduleSkeleton();
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          _ScheduleHeader(
            group: group,
            onRefresh: () => unawaited(refresh()),
            weekNav: weekInfo == null
                ? null
                : WeekNavigator(
                    week: weekInfo,
                    showToday: weekOffset != 0,
                    onPrevious: previousWeek,
                    onNext: nextWeek,
                    onToday: goToToday,
                  ),
          ),
          OfflineBanner(onRetry: () => unawaited(refresh())),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _ScheduleHeader extends StatelessWidget {
  const _ScheduleHeader({
    required this.group,
    required this.onRefresh,
    this.weekNav,
  });

  final GroupInfo? group;
  final VoidCallback onRefresh;

  final Widget? weekNav;

  @override
  Widget build(BuildContext context) {
    final course = group?.course;
    final faculty = group?.facultyName;
    final parts = <String>[
      if (faculty != null && faculty.isNotEmpty) faculty,
      if (course != null) courseLabel(course),
    ];

    return GradientHeader(
      leading: IconButton(
        tooltip: 'К списку групп',
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => context.go('/'),
      ),
      title: group?.name ?? 'Расписание',
      subtitle: parts.isEmpty ? 'Расписание занятий' : parts.join(' • '),
      actions: <Widget>[
        const SdoButton(),
        IconButton(
          tooltip: 'Настройки',
          icon: const Icon(Icons.tune_rounded),
          onPressed: () => context.push(SettingsScreen.routePath),
        ),
        IconButton(
          tooltip: 'Обновить',
          icon: const Icon(Icons.refresh_rounded),
          onPressed: onRefresh,
        ),
      ],
      child: weekNav,
    );
  }
}
