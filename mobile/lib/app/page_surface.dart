import 'package:flutter/material.dart';

/// Непрозрачная подложка страницы.
///
/// Маршруты одного `Navigator` во время перехода отрисованы одновременно:
/// въезжающая страница рисуется поверх уезжающей. Если страница сама не
/// закрашивает свою площадь, уезжающая просвечивает сквозь неё — видно сразу
/// два слоя, и переход выглядит сломанным. Поэтому каждый маршрут начинается с
/// подложки цвета [ThemeData.scaffoldBackgroundColor]: экран закрывает собой
/// всё, что лежит под ним, как закрывал прежний `Scaffold`.
class PageSurface extends StatelessWidget {
  const PageSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: child,
  );
}
