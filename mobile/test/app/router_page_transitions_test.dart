import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vstu_app/app/app.dart';
import 'package:vstu_app/app/router.dart';
import 'package:vstu_app/app/shared_axis_page_transitions.dart';
import 'package:vstu_app/core/providers.dart';
import 'package:vstu_app/features/groups/data/group.dart';
import 'package:vstu_app/features/groups/presentation/groups_providers.dart';
import 'package:vstu_app/features/settings/presentation/settings_screen.dart';

/// Поднимает настоящее приложение с настоящим роутером (без сетевых запросов).
Future<GoRouter> _pumpApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        groupsProvider.overrideWith((ref) => const <Group>[]),
      ],
      child: const VstuApp(),
    ),
  );
  // Без `pumpAndSettle`: в приложении тикает периодический таймер часов.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));

  return ProviderScope.containerOf(tester.element(find.byType(VstuApp)))
      .read(routerProvider);
}

/// Насколько экран смещён от центра: 0 — на месте, 0.3 — целиком за кадром.
double? _dx(WidgetTester tester, Type screen) {
  final Finder finder = find.ancestor(
    of: find.byType(screen),
    matching: find.byType(FractionalTranslation),
  );
  if (finder.evaluate().isEmpty) {
    return null;
  }
  return tester.widget<FractionalTranslation>(finder.first).translation.dx;
}

void main() {
  testWidgets(
    'экраны GoRouter получают переход из темы, а не мгновенную подмену',
    (WidgetTester tester) async {
      final GoRouter router = await _pumpApp(tester);

      // `push` завершается только когда экран закроют — ждать его нельзя.
      unawaited(router.push(SettingsScreen.routePath));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));

      final double? midDx = _dx(tester, SettingsScreen);
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
        lessThan(SharedAxisPageTransitionsBuilder.kSlideFraction),
        reason: 'экран уже въехал, но ещё не доехал',
      );

      await tester.pump(const Duration(milliseconds: 400));

      expect(
        _dx(tester, SettingsScreen),
        moreOrLessEquals(0, epsilon: 0.001),
        reason: 'по завершении перехода экран стоит на месте',
      );
      expect(find.byType(SettingsScreen), findsOneWidget);
    },
  );
}
