import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/skeleton.dart';
import 'schedule_providers.dart';
import 'week_content.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key, required this.groupId});

  static const String routeName = 'schedule';

  final int groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleBuilderProvider(groupId));
    final weekOffset = ref.watch(weekOffsetProvider);

    final now = ref.watch(clockProvider.select(dateOnly));
    final targetDate = now.add(Duration(days: 7 * weekOffset));
    final builder = scheduleAsync.hasValue ? scheduleAsync.requireValue : null;

    void previousWeek() => ref.read(weekOffsetProvider.notifier).previous();
    void nextWeek() => ref.read(weekOffsetProvider.notifier).next();

    Future<void> refresh() => refreshSemesterSchedule(ref, groupId);

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

    return Column(
      children: <Widget>[
        OfflineBanner(onRetry: () => unawaited(refresh())),
        Expanded(child: body),
      ],
    );
  }
}
