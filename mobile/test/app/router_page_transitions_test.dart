import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vstu_app/features/settings/presentation/settings_screen.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets(
    'экраны GoRouter получают переход из темы, а не мгновенную подмену',
    (WidgetTester tester) async {
      final GoRouter router = await pumpApp(tester);

      // `push` завершается только когда экран закроют — ждать его нельзя.
      unawaited(router.push(SettingsScreen.routePath));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));

      final double? midDx = dxOf(tester, SettingsScreen);
      expect(
        midDx,
        isNotNull,
        reason:
            'экран обязан ехать: если GoRouter отдаёт NoTransitionPage, '
            'перехода нет вообще и «настройки» появляются рывком',
      );
      expect(
        midDx,
        greaterThan(0),
        reason: 'в середине перехода экран ещё смещён вправо от центра',
      );
      expect(
        midDx,
        lessThan(0.5),
        reason:
            'экран уже въехал, но ещё не доехал: ход на всю ширину, значит '
            'в первой пятой перехода он ещё далеко справа',
      );

      await tester.pump(const Duration(milliseconds: 400));

      expect(
        dxOf(tester, SettingsScreen),
        moreOrLessEquals(0, epsilon: 0.001),
        reason: 'по завершении перехода экран стоит на месте',
      );
      expect(find.byType(SettingsScreen), findsOneWidget);
    },
  );
}
