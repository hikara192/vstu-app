import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/plural.dart';
import '../../../core/widgets/gradient_header.dart';
import '../../../core/widgets/sdo_button.dart';
import '../../settings/presentation/settings_screen.dart';
import '../data/schedule_models.dart';
import '../domain/schedule_builder.dart';
import 'schedule_providers.dart';
import 'week_navigator.dart';

/// Содержимое шапки расписания: группа, её факультет с курсом и недели.
///
/// Подложку не рисует — её даёт вызывающий (`GradientHeaderSurface`). Шапка
/// сама читает нужные провайдеры, поэтому оболочке достаточно знать [groupId].
class ScheduleHeader extends ConsumerWidget {
  const ScheduleHeader({super.key, required this.groupId});

  final int groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semester = ref.watch(semesterScheduleProvider(groupId));
    final builderAsync = ref.watch(scheduleBuilderProvider(groupId));
    final weekOffset = ref.watch(weekOffsetProvider);
    final now = ref.watch(clockProvider.select(dateOnly));

    final GroupInfo? group = semester.hasValue
        ? semester.requireValue.group
        : null;
    final ScheduleBuilder? builder = builderAsync.hasValue
        ? builderAsync.requireValue
        : null;
    final WeekInfo? week = builder?.weekOf(
      now.add(Duration(days: 7 * weekOffset)),
    );

    final course = group?.course;
    final faculty = group?.facultyName;
    final parts = <String>[
      if (faculty != null && faculty.isNotEmpty) faculty,
      if (course != null) courseLabel(course),
    ];

    return GradientHeaderContent(
      leading: IconButton(
        tooltip: 'К списку групп',
        icon: const Icon(Icons.arrow_back_rounded),
        // Уход на список групп go_router снимает с вложенного навигатора так же,
        // как системный жест «назад»: обратный переход играет, а не схлопывается.
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
          onPressed: () => unawaited(refreshSemesterSchedule(ref, groupId)),
        ),
      ],
      child: week == null
          ? null
          : WeekNavigator(
              week: week,
              showToday: weekOffset != 0,
              onPrevious: () =>
                  ref.read(weekOffsetProvider.notifier).previous(),
              onNext: () => ref.read(weekOffsetProvider.notifier).next(),
              onToday: () => ref.read(weekOffsetProvider.notifier).reset(),
            ),
    );
  }
}
