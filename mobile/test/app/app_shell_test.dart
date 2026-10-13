import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vstu_app/app/app_shell.dart';
import 'package:vstu_app/app/page_surface.dart';
import 'package:vstu_app/core/config.dart';
import 'package:vstu_app/core/widgets/gradient_header.dart';
import 'package:vstu_app/features/groups/presentation/groups_header.dart';
import 'package:vstu_app/features/groups/presentation/groups_providers.dart';
import 'package:vstu_app/features/groups/presentation/groups_screen.dart';
import 'package:vstu_app/features/schedule/presentation/schedule_header.dart';
import 'package:vstu_app/features/schedule/presentation/schedule_screen.dart';
import 'package:vstu_app/features/settings/presentation/settings_screen.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('шапка стоит на месте, а содержание едет', (
    WidgetTester tester,
  ) async {
    final GoRouter router = await pumpApp(tester);
    final Offset headerBefore = tester.getTopLeft(
      find.byType(GradientHeaderSurface),
    );

    unawaited(router.push('/schedule/1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));

    final double? midDx = dxOf(tester, ScheduleScreen);
    expect(
      midDx,
      isNotNull,
      reason: 'содержание обязано ехать: иначе переход не виден вообще',
    );
    expect(
      midDx,
      greaterThan(0),
      reason: 'в середине перехода расписание ещё правее своего места',
    );
    expect(
      tester.getTopLeft(find.byType(GradientHeaderSurface)),
      headerBefore,
      reason: 'шапка живёт в оболочке и не участвует в переходе',
    );

    await tester.pump(const Duration(milliseconds: 400));

    expect(dxOf(tester, ScheduleScreen), moreOrLessEquals(0, epsilon: 0.001));
    expect(
      tester.getTopLeft(find.byType(GradientHeaderSurface)),
      headerBefore,
      reason: 'по завершении перехода шапка всё там же',
    );
  });

  testWidgets('кнопки шапки нажимаются в корневом навигаторе', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    final BuildContext context = tester.element(find.byType(GroupsHeader));
    expect(
      Navigator.of(context, rootNavigator: true),
      same(Navigator.of(context)),
      reason: 'иначе СДО и настройки откроются внутри оболочки, под её шапкой',
    );
  });

  testWidgets('экран настроек не оказывается внутри оболочки', (
    WidgetTester tester,
  ) async {
    final GoRouter router = await pumpApp(tester);

    unawaited(router.push(SettingsScreen.routePath));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(
      find.ancestor(
        of: find.byType(SettingsScreen),
        matching: find.byType(AppShell),
      ),
      findsNothing,
      reason:
          'полноэкранный маршрут поверх оболочки: двух шапок быть не должно',
    );
  });

  testWidgets('содержимое шапки меняется кроссфейдом', (
    WidgetTester tester,
  ) async {
    final GoRouter router = await pumpApp(tester);

    expect(find.byType(GroupsHeader), findsOneWidget);

    unawaited(router.push('/schedule/1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));

    expect(
      find.byType(GroupsHeader),
      findsOneWidget,
      reason: 'уходящая шапка ещё растворяется',
    );
    expect(
      find.byType(ScheduleHeader),
      findsOneWidget,
      reason: 'входящая шапка уже проявляется',
    );

    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(GroupsHeader), findsNothing);
    expect(find.byType(ScheduleHeader), findsOneWidget);
  });

  testWidgets('страница закрывает собой то, что под ней', (
    WidgetTester tester,
  ) async {
    final GoRouter router = await pumpApp(tester);

    expect(
      find.ancestor(
        of: find.byType(GroupsScreen),
        matching: find.byType(PageSurface),
      ),
      findsOneWidget,
      reason:
          'без непрозрачной подложки уезжающая страница просвечивает сквозь '
          'въезжающую: во время перехода видно сразу два слоя',
    );

    unawaited(router.push('/schedule/1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.ancestor(
        of: find.byType(ScheduleScreen),
        matching: find.byType(PageSurface),
      ),
      findsOneWidget,
      reason: 'расписание тоже обязано закрывать собой список групп',
    );
  });

  testWidgets('запрос поиска переживает уход на расписание и возврат', (
    WidgetTester tester,
  ) async {
    final GoRouter router = await pumpApp(tester);

    await tester.enterText(find.byType(SearchBar), 'А-3');
    await tester.pump(
      AppConfig.searchDebounce + const Duration(milliseconds: 20),
    );
    expect(appContainer(tester).read(groupsQueryProvider), 'А-3');

    unawaited(router.push('/schedule/1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(ScheduleHeader), findsOneWidget);

    router.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(GroupsHeader), findsOneWidget);
    expect(
      tester.widget<SearchBar>(find.byType(SearchBar)).controller!.text,
      'А-3',
      reason: 'запрос живёт в провайдере, поле обязано его показать',
    );
  });
}
