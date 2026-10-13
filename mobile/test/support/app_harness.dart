import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vstu_app/app/app.dart';
import 'package:vstu_app/app/router.dart';
import 'package:vstu_app/core/providers.dart';
import 'package:vstu_app/features/groups/data/group.dart';
import 'package:vstu_app/features/groups/presentation/groups_providers.dart';
import 'package:vstu_app/features/schedule/data/schedule_models.dart';
import 'package:vstu_app/features/schedule/presentation/schedule_providers.dart';

/// Расписание группы 1 без сети: из него строится шапка расписания.
final GroupSchedule _schedule = GroupSchedule(
  group: const GroupInfo(id: 1, name: 'А-37', facultyName: 'ФИТ', course: 2),
  semesterStart: DateTime(2025, 2, 3),
  weekAnchor: WeekCycleAnchor(date: DateTime(2025, 2, 3), number: 1),
);

/// Контейнер живого приложения: тестам нужен доступ к состоянию провайдеров.
ProviderContainer appContainer(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(VstuApp)));

/// Поднимает настоящее приложение с настоящим роутером, но без сети.
Future<GoRouter> pumpApp(
  WidgetTester tester, {
  Map<String, Object> prefs = const <String, Object>{},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        groupsProvider.overrideWith((ref) => const <Group>[]),
        semesterScheduleProvider(1).overrideWith((ref) => _schedule),
      ],
      child: const VstuApp(),
    ),
  );
  // Без `pumpAndSettle`: в приложении тикает периодический таймер часов.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));

  return appContainer(tester).read(routerProvider);
}

/// Насколько экран смещён от своего места: 0 — на месте, 1 — на всю ширину
/// правее. `null` — если вокруг экрана перехода нет вообще.
double? dxOf(WidgetTester tester, Type screen) {
  final Finder finder = find.ancestor(
    of: find.byType(screen),
    matching: find.byType(FractionalTranslation),
  );
  if (finder.evaluate().isEmpty) {
    return null;
  }
  return tester.widget<FractionalTranslation>(finder.first).translation.dx;
}
