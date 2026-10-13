import 'package:flutter/material.dart';

/// Переход экранов «параллакс-сдвиг» — движение «вперёд/назад» с глубиной.
///
/// Входящий экран въезжает справа на всю ширину, а уходящий проходит только
/// четверть пути и постепенно затемняется. Из-за разного хода и тени уходящий
/// читается как «уехал вглубь», а не просто исчез вбок.
///
/// Отличие от штатного на Android `FadeForwardsPageTransitionsBuilder`:
///   * полный ход входящего вместо четверти ширины;
///   * уходящий не исчезает в первой четверти перехода, а едет и темнеет до
///     самого конца;
///   * 320 мс вместо 450.
///
/// Переход оборачивает только страницу. Постоянная шапка приложения живёт вне
/// анимируемого маршрута (см. `AppShell`), поэтому она не двигается.
class ParallaxPageTransitionsBuilder extends PageTransitionsBuilder {
  /// Создаёт переход «вперёд/назад» с параллаксом.
  const ParallaxPageTransitionsBuilder();

  /// Длительность перехода.
  static const Duration kDuration = Duration(milliseconds: 320);

  /// Ход уходящего экрана в долях ширины — четверть.
  static const double kOutgoingFraction = 0.25;

  /// Затемнение уходящего экрана в самом глубоком положении.
  static const double kScrimOpacity = 0.12;

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
    return _ParallaxPageTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

class _ParallaxPageTransition extends StatelessWidget {
  const _ParallaxPageTransition({
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
      // Готовый `child` передаётся дальше как есть: переход не пересобирает
      // поддерево страницы каждый кадр, а только двигает и затемняет его.
      child: child,
      builder: (BuildContext context, Widget? child) {
        // Прогресс появления экрана: 0 — за кадром справа, 1 — на своём месте.
        final double enter = ParallaxPageTransitionsBuilder.kCurve.transform(
          animation.value,
        );
        // Прогресс ухода под верхний экран: 0 — не перекрыт, 1 — ушёл под него.
        final double under = ParallaxPageTransitionsBuilder.kCurve.transform(
          secondaryAnimation.value,
        );

        final double dx =
            (1 - enter) -
            ParallaxPageTransitionsBuilder.kOutgoingFraction * under;
        final double scrim =
            ParallaxPageTransitionsBuilder.kScrimOpacity * under;

        return FractionalTranslation(
          translation: Offset(dx, 0),
          child: scrim <= 0
              ? child
              : DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: scrim),
                  ),
                  child: child,
                ),
        );
      },
    );
  }
}
