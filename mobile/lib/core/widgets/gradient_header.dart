import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_colors.dart';

/// Градиентная подложка шапки: системный вырез, градиент, тень и белые иконки.
///
/// Здесь всё, что не меняется при переходе между экранами. В оболочке
/// приложения (`AppShell`) подложка живёт вне анимируемого маршрута, поэтому
/// при навигации она остаётся на месте, а меняющееся содержимое приходит в
/// `child`.
class GradientHeaderSurface extends StatelessWidget {
  /// Создаёт подложку шапки вокруг произвольного содержимого.
  const GradientHeaderSurface({super.key, required this.child});

  /// Радиус нижних углов подложки.
  static const BorderRadius bottomRadius = BorderRadius.vertical(
    bottom: Radius.circular(26),
  );

  /// Тень подложки: шапка читается приподнятой над содержанием.
  ///
  /// Ею же рисуется проекция поверх содержания (`_HeaderShadow` в оболочке):
  /// подложка стоит в разметке выше страниц, поэтому её собственной тени
  /// страницы не видно.
  static List<BoxShadow> shadowOf(AppColors colors) => <BoxShadow>[
    BoxShadow(
      color: colors.heroGradient.last.withValues(alpha: 0.25),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  /// Содержимое, которое рисуется поверх градиента.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors.heroGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: bottomRadius,
          boxShadow: shadowOf(colors),
        ),
        child: IconTheme.merge(
          data: const IconThemeData(color: Colors.white),
          child: child,
        ),
      ),
    );
  }
}

/// Содержимое шапки: строка с заголовком, подзаголовком и действиями.
///
/// Отделено от подложки, чтобы оболочка могла подменять только содержимое —
/// заголовок экрана и его действия — и при этом ничего не двигать.
class GradientHeaderContent extends StatelessWidget {
  /// Создаёт содержимое шапки.
  const GradientHeaderContent({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const <Widget>[],
    this.child,
  });

  final String title;

  final String? subtitle;

  final Widget? leading;

  final List<Widget> actions;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            if (leading != null) ...<Widget>[
              leading!,
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontSize: 13.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ...actions,
          ],
        ),
        if (child != null)
          Padding(padding: const EdgeInsets.only(top: 16), child: child),
      ],
    );
  }
}

/// Шапка экрана: подложка и содержимое в одном виджете.
///
/// Для экранов, которые сами владеют своей шапкой (настройки, СДО), и для мест,
/// где шапка нужна целиком. Оболочка приложения собирает эти две части
/// отдельно, чтобы подложка не двигалась при переходах.
class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const <Widget>[],
    this.child,
  });

  final String title;

  final String? subtitle;

  final Widget? leading;

  final List<Widget> actions;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GradientHeaderSurface(
      child: GradientHeaderContent(
        title: title,
        subtitle: subtitle,
        leading: leading,
        actions: actions,
        child: child,
      ),
    );
  }
}
