import 'package:flutter/material.dart';

/// Переход экранов «Shared axis X» из Material 3 — движение «вперёд/назад».
///
/// Входящий экран въезжает справа и проявляется, а предыдущий уезжает влево и
/// угасает; оба движутся одновременно. Ход — 30 % ширины экрана, длительность —
/// 300 мс (M3 medium1), кривая — emphasized.
///
/// Отличие от штатного на Android `FadeForwardsPageTransitionsBuilder`:
///   * короче (300 против 450 мс);
///   * больше ход (30 % против 25 %);
///   * уходящий экран угасает постепенно на протяжении всего перехода, а не
///     исчезает в первой его четверти.
class SharedAxisPageTransitionsBuilder extends PageTransitionsBuilder {
  /// Создаёт переход «вперёд/назад» по спецификации Material 3.
  const SharedAxisPageTransitionsBuilder();

  /// Длительность перехода — M3 medium1.
  static const Duration kDuration = Duration(milliseconds: 300);

  /// Ход экрана в долях ширины — M3 shared axis X: 30 %.
  static const double kSlideFraction = 0.3;

  /// Кривая M3 для переходов вперёд/назад.
  static const Curve kCurve = Curves.easeInOutCubicEmphasized;

  @override
  Duration get transitionDuration => kDuration;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _SharedAxisPageTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

class _SharedAxisPageTransition extends StatelessWidget {
  const _SharedAxisPageTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  /// Появление/уход собственного маршрута (push/pop).
  final Animation<double> animation;

  /// Перекрытие маршрутом сверху: 0 — не перекрыт, 1 — ушёл под него.
  final Animation<double> secondaryAnimation;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[animation, secondaryAnimation]),
      builder: (BuildContext context, Widget? child) {
        // Прогресс появления экрана: 0 — за кадром справа и прозрачен,
        // 1 — на месте.
        final double enter = SharedAxisPageTransitionsBuilder.kCurve.transform(
          animation.value,
        );
        // Прогресс ухода под верхний экран: 0 — на месте, 1 — уехал влево.
        final double exit = SharedAxisPageTransitionsBuilder.kCurve.transform(
          secondaryAnimation.value,
        );
        return FractionalTranslation(
          translation: Offset(
            SharedAxisPageTransitionsBuilder.kSlideFraction *
                (1 - enter - exit),
            0,
          ),
          child: Opacity(opacity: enter * (1 - exit), child: child),
        );
      },
      child: child,
    );
  }
}
