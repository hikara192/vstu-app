import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vstu_app/app/app.dart';
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

/// Яркость пикселя нарисованного кадра в логической точке `point`.
///
/// Нужна там, где обещает не дерево виджетов, а сама картинка: тень шапки —
/// это рисование, а не структура.
Future<double> lumaAt(WidgetTester tester, Offset point) async {
  final double appWidth = tester.getSize(find.byType(VstuApp)).width;
  double luma = 0;
  await tester.runAsync(() async {
    final ui.Image image = await captureImage(
      tester.element(find.byType(VstuApp)),
    );
    final ByteData? pixels = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    final double scale = image.width / appWidth;
    final int x = (point.dx * scale).round();
    final int y = (point.dy * scale).round();
    final int i = (y * image.width + x) * 4;
    luma =
        0.299 * pixels!.getUint8(i) +
        0.587 * pixels.getUint8(i + 1) +
        0.114 * pixels.getUint8(i + 2);
  });
  return luma;
}

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

  testWidgets('тень шапки читается поверх содержания', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    final double headerBottom = tester
        .getBottomLeft(find.byType(GradientHeaderSurface))
        .dy;
    final double centerX = tester.getSize(find.byType(VstuApp)).width / 2;
    // Обе точки — на фоне страницы и по её середине: в углах тень скруглена,
    // там её почти нет. Разница между точками — только сама тень.
    final double inShadow = await lumaAt(
      tester,
      Offset(centerX, headerBottom + 3),
    );
    final double belowShadow = await lumaAt(
      tester,
      Offset(centerX, headerBottom + 120),
    );

    expect(
      inShadow,
      lessThan(belowShadow - 4),
      reason:
          'шапка приподнята над содержанием: её тень обязана ложиться '
          'поверх страницы, а не пропадать под ней',
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
