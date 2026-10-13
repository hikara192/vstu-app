import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vstu_app/core/config.dart';
import 'package:vstu_app/features/groups/presentation/groups_providers.dart';
import 'package:vstu_app/features/groups/presentation/groups_screen.dart';
import 'package:vstu_app/features/schedule/presentation/schedule_header.dart';
import 'package:vstu_app/features/schedule/presentation/schedule_screen.dart';

import '../support/app_harness.dart';

/// `PopScope` списка групп: он и решает, что делает системный «назад».
PopScope<Object?> _groupsPopScope(WidgetTester tester) =>
    tester.widget<PopScope<Object?>>(
      find.descendant(
        of: find.byType(GroupsScreen),
        matching: find.byType(PopScope<Object?>),
      ),
    );

void main() {
  testWidgets(
    'жест «назад» при выбранном курсе поднимает на факультет, а не закрывает приложение',
    (WidgetTester tester) async {
      final GoRouter router = await pumpApp(tester);
      final container = appContainer(tester);

      container.read(groupsBrowseProvider.notifier).selectFaculty('ФИТ');
      container.read(groupsBrowseProvider.notifier).selectCourse(2);
      await tester.pump();

      expect(
        _groupsPopScope(tester).canPop,
        isFalse,
        reason: 'назад обязан снять курс, а не закрыть приложение',
      );

      await tester.binding.handlePopRoute();
      await tester.pump();

      final GroupsBrowseState browse = container.read(groupsBrowseProvider);
      expect(browse.course, isNull, reason: 'уровень курса снят');
      expect(browse.faculty, 'ФИТ', reason: 'факультет остался выбранным');
      expect(
        router.state.uri.path,
        '/',
        reason:
            'список групп никуда не уезжал — снялся только уровень иерархии',
      );
    },
  );

  testWidgets('жест «назад» на верхнем уровне списка не трогает выбор', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    final container = appContainer(tester);

    expect(
      _groupsPopScope(tester).canPop,
      isTrue,
      reason: 'на верхнем уровне иерархии возвращаться некуда',
    );

    await tester.binding.handlePopRoute();
    await tester.pump();

    final GroupsBrowseState browse = container.read(groupsBrowseProvider);
    expect(browse.faculty, isNull);
    expect(browse.course, isNull);
  });

  testWidgets('кнопка «К списку групп» возвращает так же, как жест «назад»', (
    WidgetTester tester,
  ) async {
    final GoRouter router = await pumpApp(tester);

    unawaited(router.push('/schedule/1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(ScheduleHeader), findsOneWidget);

    await tester.tap(find.byTooltip('К списку групп'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));

    expect(router.state.uri.path, '/', reason: 'адрес меняется сразу');
    expect(
      dxOf(tester, ScheduleScreen),
      greaterThan(0),
      reason:
          'расписание обязано уехать вправо: возврат играет той же обратной '
          'анимацией, что и системный жест, а не подменяется мгновенно',
    );

    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ScheduleScreen), findsNothing);
    expect(find.byType(GroupsScreen), findsOneWidget);
  });

  testWidgets(
    'кнопка «К списку групп» работает, когда расписание — первый экран',
    (WidgetTester tester) async {
      final GoRouter router = await pumpApp(
        tester,
        prefs: <String, Object>{
          AppConfig.selectedGroupIdKey: 1,
          AppConfig.selectedGroupNameKey: 'А-37',
        },
      );
      expect(router.state.uri.path, '/schedule/1');

      await tester.tap(find.byTooltip('К списку групп'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(
        router.state.uri.path,
        '/',
        reason: 'снимать нечего — уходим на список',
      );
      expect(find.byType(GroupsScreen), findsOneWidget);
    },
  );
}
