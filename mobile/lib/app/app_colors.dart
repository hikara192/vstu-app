import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.lecture,
    required this.practice,
    required this.lab,
    required this.other,
    required this.numerator,
    required this.denominator,
    required this.heroGradient,
    required this.accentGradient,
  });

  final Color lecture;

  final Color practice;

  final Color lab;

  final Color other;

  final Color numerator;

  final Color denominator;

  final List<Color> heroGradient;

  final List<Color> accentGradient;

  static const AppColors light = AppColors(
    lecture: Color(0xFF1B5E9C),
    practice: Color(0xFF00796B),
    lab: Color(0xFF7B3FA0),
    other: Color(0xFF5F6368),
    numerator: Color(0xFF2E7D32),
    denominator: Color(0xFFB26A00),
    heroGradient: <Color>[
      Color(0xFF0F3A66),
      Color(0xFF1B5E9C),
      Color(0xFF2E86C1),
    ],
    accentGradient: <Color>[Color(0xFF1B5E9C), Color(0xFF3E9BD6)],
  );

  static const AppColors dark = AppColors(
    lecture: Color(0xFF8FC6FF),
    practice: Color(0xFF7FD8CB),
    lab: Color(0xFFD6B6F7),
    other: Color(0xFFB0B6BD),
    numerator: Color(0xFF9BE29B),
    denominator: Color(0xFFF3C97B),
    heroGradient: <Color>[
      Color(0xFF08243C),
      Color(0xFF11456F),
      Color(0xFF1B5E9C),
    ],
    accentGradient: <Color>[Color(0xFF154E80), Color(0xFF2E86C1)],
  );

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? light;

  Color lessonType(String typeShort) => switch (typeShort.toLowerCase()) {
    'лк' || 'лек' => lecture,
    'пз' || 'пр' || 'сем' => practice,
    'лр' || 'лаб' => lab,
    _ => other,
  };

  Color parity(bool isNumerator) => isNumerator ? numerator : denominator;

  @override
  AppColors copyWith({
    Color? lecture,
    Color? practice,
    Color? lab,
    Color? other,
    Color? numerator,
    Color? denominator,
    List<Color>? heroGradient,
    List<Color>? accentGradient,
  }) {
    return AppColors(
      lecture: lecture ?? this.lecture,
      practice: practice ?? this.practice,
      lab: lab ?? this.lab,
      other: other ?? this.other,
      numerator: numerator ?? this.numerator,
      denominator: denominator ?? this.denominator,
      heroGradient: heroGradient ?? this.heroGradient,
      accentGradient: accentGradient ?? this.accentGradient,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      lecture: Color.lerp(lecture, other.lecture, t) ?? lecture,
      practice: Color.lerp(practice, other.practice, t) ?? practice,
      lab: Color.lerp(lab, other.lab, t) ?? lab,
      other: Color.lerp(this.other, other.other, t) ?? this.other,
      numerator: Color.lerp(numerator, other.numerator, t) ?? numerator,
      denominator: Color.lerp(denominator, other.denominator, t) ?? denominator,
      heroGradient: _lerpColors(heroGradient, other.heroGradient, t),
      accentGradient: _lerpColors(accentGradient, other.accentGradient, t),
    );
  }

  static List<Color> _lerpColors(List<Color> from, List<Color> to, double t) {
    final length = from.length < to.length ? from.length : to.length;
    return <Color>[
      for (var i = 0; i < length; i++) Color.lerp(from[i], to[i], t) ?? from[i],
    ];
  }
}
