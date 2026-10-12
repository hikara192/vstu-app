import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light(Color seed) =>
      _build(Brightness.light, seed, AppColors.light, amoled: false);

  static ThemeData dark(Color seed) =>
      _build(Brightness.dark, seed, AppColors.dark, amoled: false);

  static ThemeData amoled(Color seed) =>
      _build(Brightness.dark, seed, AppColors.dark, amoled: true);

  static ThemeData _build(
    Brightness brightness,
    Color seed,
    AppColors base, {
    required bool amoled,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    final colors = base.copyWith(
      heroGradient: _heroGradient(seed, amoled: amoled),
      accentGradient: _accentGradient(seed, brightness),
    );
    final base0 = ThemeData(
      brightness: brightness,
      colorScheme: amoled ? _blackSurfaces(scheme) : scheme,
    );
    final textTheme = _textTheme(base0.textTheme);
    final outline = amoled
        ? Colors.white.withValues(alpha: 0.16)
        : scheme.outlineVariant.withValues(alpha: 0.7);
    final scaffold = amoled ? Colors.black : scheme.surface;
    final cardSurface = amoled
        ? const Color(0xFF0D0D0D)
        : scheme.surfaceContainerLow;
    final fieldSurface = amoled
        ? const Color(0xFF171717)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.45);

    return base0.copyWith(
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[colors],
      scaffoldBackgroundColor: scaffold,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: cardSurface,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: outline),
        ),
      ),
      dividerTheme: DividerThemeData(color: outline, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: fieldSurface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: _inputBorder(BorderSide.none),
        enabledBorder: _inputBorder(BorderSide.none),
        focusedBorder: _inputBorder(
          BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: _inputBorder(BorderSide(color: scheme.error, width: 1.4)),
        focusedErrorBorder: _inputBorder(
          BorderSide(color: scheme.error, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(style: _filledButtonStyle()),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _outlinedButtonStyle(outline),
      ),
      textButtonTheme: TextButtonThemeData(style: _textButtonStyle()),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          textStyle: const WidgetStatePropertyAll<TextStyle>(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
          ),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll<double>(0),
        backgroundColor: WidgetStatePropertyAll<Color>(cardSurface),
        surfaceTintColor: const WidgetStatePropertyAll<Color>(
          Colors.transparent,
        ),
        shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        side: WidgetStatePropertyAll<BorderSide>(BorderSide(color: outline)),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 12),
        ),
        hintStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(fontSize: 15, color: scheme.onSurfaceVariant),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static List<Color> _heroGradient(Color seed, {required bool amoled}) =>
      <Color>[
        Color.lerp(seed, Colors.black, amoled ? 0.72 : 0.55)!,
        Color.lerp(seed, Colors.black, amoled ? 0.55 : 0.38)!,
        Color.lerp(seed, Colors.black, amoled ? 0.38 : 0.22)!,
      ];

  static List<Color> _accentGradient(
    Color seed,
    Brightness brightness,
  ) => <Color>[
    Color.lerp(
      seed,
      Colors.black,
      brightness == Brightness.dark ? 0.45 : 0.38,
    )!,
    Color.lerp(seed, Colors.black, brightness == Brightness.dark ? 0.3 : 0.18)!,
  ];

  static ColorScheme _blackSurfaces(ColorScheme scheme) => scheme.copyWith(
    surface: Colors.black,
    surfaceContainerLowest: Colors.black,
    surfaceContainerLow: const Color(0xFF0D0D0D),
    surfaceContainer: const Color(0xFF121212),
    surfaceContainerHigh: const Color(0xFF1A1A1A),
    surfaceContainerHighest: const Color(0xFF222222),
  );

  static TextTheme _textTheme(TextTheme base) => base.copyWith(
    titleLarge: base.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
  );

  static OutlineInputBorder _inputBorder(BorderSide side) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: side,
  );

  static ButtonStyle _filledButtonStyle() => FilledButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
  );

  static ButtonStyle _outlinedButtonStyle(Color outline) =>
      OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        side: BorderSide(color: outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      );

  static ButtonStyle _textButtonStyle() => TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
  );
}
