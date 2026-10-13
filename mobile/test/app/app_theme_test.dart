import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstu_app/app/app.dart';
import 'package:vstu_app/app/router.dart';
import 'package:vstu_app/app/theme.dart';
import 'package:vstu_app/core/providers.dart';
import 'package:vstu_app/features/settings/data/settings_controller.dart';
import 'package:vstu_app/features/settings/domain/app_settings.dart';

const Key _probeKey = Key('theme-probe');

/// Акцент по умолчанию и та же тёмная тема, которую выбирает `VstuApp`.
const Color _defaultSeed = Color(0xFF1B5E9C);

GoRouter _probeRouter() => GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const Scaffold(body: SizedBox(key: _probeKey)),
    ),
  ],
);

void main() {
  testWidgets(
    'смена темы применяется за один кадр, без покадрового перестроения дерева',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            routerProvider.overrideWithValue(_probeRouter()),
          ],
          child: const VstuApp(),
        ),
      );

      ThemeData themeOfProbe() =>
          Theme.of(tester.element(find.byKey(_probeKey)));

      // Стартуем в светлой теме.
      expect(themeOfProbe().brightness, Brightness.light);

      final ProviderContainer container = ProviderScope.containerOf(
        tester.element(find.byKey(_probeKey)),
      );
      await container
          .read(appSettingsProvider.notifier)
          .setThemeMode(AppThemeMode.dark);

      // Один кадр — тема должна примениться целиком. Раньше здесь запускалась
      // 200-мс анимация MaterialApp, и в этом кадре тема была ещё светлой
      // (начинался лерп), а всё дерево перестраивалось каждый кадр анимации.
      await tester.pump();

      final ThemeData dark = AppTheme.dark(_defaultSeed);
      expect(themeOfProbe().brightness, Brightness.dark);
      expect(
        themeOfProbe().colorScheme.surface,
        dark.colorScheme.surface,
        reason: 'тема должна переключиться мгновенно, без лерпа',
      );
    },
  );
}
