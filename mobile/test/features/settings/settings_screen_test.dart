import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vstu_app/core/providers.dart';
import 'package:vstu_app/core/widgets/theme_reveal.dart';
import 'package:vstu_app/features/settings/presentation/settings_screen.dart';

Future<void> _pumpSettings(
  WidgetTester tester, {
  Brightness platformBrightness = Brightness.light,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  tester.platformDispatcher.platformBrightnessTestValue = platformBrightness;
  addTearDown(() {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MaterialApp(home: SettingsScreen()),
    ),
  );

  // Разворачиваем секцию «Тема».
  await tester.tap(find.text('Тема'));
  await tester.pumpAndSettle();
}

Finder _overlayClip() => find.descendant(
  of: find.byType(ThemeRevealArea),
  matching: find.byType(ClipPath),
);

/// Нажимает на конкретный режим темы. Режим ищем по его уникальному описанию,
/// а не по названию: после выбора «Тёмной» заголовок секции «Тема» тоже
/// становится «Тёмная», и `find.text` был бы неоднозначен.
Future<void> _tapThemeOption(WidgetTester tester, String description) async {
  final Finder row = find
      .ancestor(of: find.text(description), matching: find.byType(InkWell))
      .first;
  await tester.ensureVisible(row);
  await tester.pumpAndSettle();
  await tester.tap(row);
  await tester.pump();
}

/// Запускает раскрытие (снятие кадра + анимацию) и ждёт завершения.
Future<void> _letRevealComplete(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 100)),
  ); // движок снимает кадр (toImage)
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('повторный выбор уже включённой темы не запускает раскрытие '
      '(светлая система, выбрана «Тёмная»)', (WidgetTester tester) async {
    await _pumpSettings(tester);

    // Первый выбор «Тёмная»: светлая → тёмная, внешний вид меняется —
    // запускается раскрытие.
    await _tapThemeOption(
      tester,
      'Серые поверхности, как в обычной тёмной теме',
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    expect(_overlayClip(), findsOneWidget, reason: 'раскрытие запущено');
    await _letRevealComplete(tester);
    expect(_overlayClip(), findsNothing, reason: 'анимация завершена');

    // Второй выбор «Тёмная»: тема та же, внешний вид не меняется —
    // раскрытия быть не должно вообще.
    await _tapThemeOption(
      tester,
      'Серые поверхности, как в обычной тёмной теме',
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      _overlayClip(),
      findsNothing,
      reason: 'визуально ничего не меняется — анимация не нужна',
    );
  });

  testWidgets(
    '«Системная» при совпадающей тематике системы не запускает раскрытие, '
    'а реальная смена темы — запускает',
    (WidgetTester tester) async {
      // Система тёмная, у пользователя стоит «Системная» (вид — тёмный).
      await _pumpSettings(tester, platformBrightness: Brightness.dark);

      // «Системная» → «Тёмная»: вид одинаковый (тёмный) — без раскрытия.
      await _tapThemeOption(
        tester,
        'Серые поверхности, как в обычной тёмной теме',
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        _overlayClip(),
        findsNothing,
        reason: 'системная тёмная и «Тёмная» дают один и тот же вид',
      );

      // «Тёмная» → «Светлая»: вид меняется — раскрытие запускается.
      await _tapThemeOption(tester, 'Светлый фон даже вечером');
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pump();
      expect(_overlayClip(), findsOneWidget, reason: 'смена вида — раскрытие');
      await _letRevealComplete(tester);
      expect(
        _overlayClip(),
        findsNothing,
        reason: 'анимация завершена, оверлей убран',
      );
    },
  );
}
