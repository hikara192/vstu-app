import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vstu_app/core/providers.dart';
import 'package:vstu_app/core/widgets/gradient_header.dart';
import 'package:vstu_app/features/schedule/data/schedule_models.dart';
import 'package:vstu_app/features/schedule/presentation/schedule_header.dart';
import 'package:vstu_app/features/schedule/presentation/schedule_providers.dart';
import 'package:vstu_app/features/schedule/presentation/week_navigator.dart';

/// Расписание одной группы: шапке нужны имя группы, факультет и курс, а
/// навигатор недель строится из семестра.
final GroupSchedule _schedule = GroupSchedule(
  group: const GroupInfo(id: 1, name: 'А-37', facultyName: 'ФИТ', course: 2),
  semesterStart: DateTime(2025, 2, 3),
  weekAnchor: WeekCycleAnchor(date: DateTime(2025, 2, 3), number: 1),
);

/// Поднимает шапку так же, как оболочка: подложку даёт вызывающий, шапка
/// отдаёт только содержимое.
Future<void> _pumpHeader(
  WidgetTester tester, {
  GroupSchedule Function()? schedule,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        semesterScheduleProvider(1)
            .overrideWith((ref) => schedule?.call() ?? _schedule),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: GradientHeaderSurface(child: ScheduleHeader(groupId: 1)),
        ),
      ),
    ),
  );

  // Семестр отдаётся сразу, а построитель недель — следующим микрошагом.
  await tester.pump();
}

void main() {
  testWidgets('шапка показывает группу, факультет с курсом и кнопку к списку', (
    WidgetTester tester,
  ) async {
    await _pumpHeader(tester);

    expect(find.text('А-37'), findsOneWidget);
    expect(find.text('ФИТ • 2 курс'), findsOneWidget);
    expect(find.byTooltip('К списку групп'), findsOneWidget);
    expect(find.byTooltip('Настройки'), findsOneWidget);
    expect(find.byTooltip('Обновить'), findsOneWidget);
  });

  testWidgets('известная неделя даёт навигатор недель', (
    WidgetTester tester,
  ) async {
    await _pumpHeader(tester);

    expect(find.byType(WeekNavigator), findsOneWidget);
  });

  testWidgets('«Обновить» переспрашивает расписание', (
    WidgetTester tester,
  ) async {
    int fetches = 0;
    await _pumpHeader(
      tester,
      schedule: () {
        fetches++;
        return _schedule;
      },
    );

    expect(
      fetches,
      1,
      reason: 'первое построение шапки уже спросило расписание',
    );

    await tester.tap(find.byTooltip('Обновить'));
    await tester.pump();

    expect(fetches, 2, reason: 'кнопка обязана сходить за свежим расписанием');
  });
}
