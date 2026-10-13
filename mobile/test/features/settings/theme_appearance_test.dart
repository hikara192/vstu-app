import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/settings/domain/app_settings.dart';

void main() {
  group('effectiveAppearanceFor', () {
    test('«Светлая» всегда светлая, независимо от системы', () {
      expect(
        effectiveAppearanceFor(AppThemeMode.light, Brightness.light),
        ThemeAppearance.light,
      );
      expect(
        effectiveAppearanceFor(AppThemeMode.light, Brightness.dark),
        ThemeAppearance.light,
      );
    });

    test('«Тёмная» всегда обычная тёмная, независимо от системы', () {
      expect(
        effectiveAppearanceFor(AppThemeMode.dark, Brightness.light),
        ThemeAppearance.dark,
      );
      expect(
        effectiveAppearanceFor(AppThemeMode.dark, Brightness.dark),
        ThemeAppearance.dark,
      );
    });

    test('«AMOLED» всегда чисто-чёрная, независимо от системы', () {
      expect(
        effectiveAppearanceFor(AppThemeMode.amoled, Brightness.light),
        ThemeAppearance.amoled,
      );
      expect(
        effectiveAppearanceFor(AppThemeMode.amoled, Brightness.dark),
        ThemeAppearance.amoled,
      );
    });

    test('«Системная» следует за яркостью телефона', () {
      expect(
        effectiveAppearanceFor(AppThemeMode.system, Brightness.light),
        ThemeAppearance.light,
      );
      expect(
        effectiveAppearanceFor(AppThemeMode.system, Brightness.dark),
        ThemeAppearance.dark,
      );
    });

    test('тёмная и AMOLED — разные внешние виды (палитра серое/чёрное), '
        'хотя обе темнее светлой', () {
      expect(ThemeAppearance.dark, isNot(equals(ThemeAppearance.amoled)));
      expect(ThemeAppearance.light, isNot(equals(ThemeAppearance.dark)));
    });

    test('«Тёмная» → «Системная» при тёмной системе не меняет внешний вид '
        '(ни при светлой системе и «Светлая»)', () {
      expect(
        effectiveAppearanceFor(AppThemeMode.dark, Brightness.dark),
        effectiveAppearanceFor(AppThemeMode.system, Brightness.dark),
      );
      expect(
        effectiveAppearanceFor(AppThemeMode.light, Brightness.light),
        effectiveAppearanceFor(AppThemeMode.system, Brightness.light),
      );
    });

    test('«Тёмная» → «Системная» при светлой системе меняет внешний вид', () {
      expect(
        effectiveAppearanceFor(AppThemeMode.dark, Brightness.light),
        isNot(
          equals(effectiveAppearanceFor(AppThemeMode.system, Brightness.light)),
        ),
      );
    });
  });
}
