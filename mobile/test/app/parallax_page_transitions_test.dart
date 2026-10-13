import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/app/parallax_page_transitions.dart';

/// Тема только с нашим переходом: здесь проверяется чистая геометрия билдера.
/// Что он действительно подключён к теме приложения — отдельно проверяет
/// `app_theme_test.dart`, а что экраны GoRouter его получают — `app_shell_test.dart`.
ThemeData _theme() => ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ParallaxPageTransitionsBuilder(),
    },
  ),
);

/// Считает свои сборки: так ловится покадровое перестроение страницы.
class _CountedPage extends StatelessWidget {
  const _CountedPage({required this.onBuild});

  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    return const Scaffold(body: Text('second'));
  }
}

/// Насколько экран смещён от центра: 0 — на месте, 1 — целиком справа за кадром.
double _dx(WidgetTester tester, String text) {
  final Finder finder = find.ancestor(
    of: find.text(text),
    matching: find.byType(FractionalTranslation),
  );
  expect(
    finder,
    findsWidgets,
    reason: 'экран обязан ехать, иначе перехода нет вообще',
  );
  return tester.widget<FractionalTranslation>(finder.first).translation.dx;
}

/// Затемнение поверх уходящего экрана — оно и даёт ощущение глубины.
Finder _scrimOf(String text) => find.ancestor(
  of: find.text(text),
  matching: find.byWidgetPredicate(
    (Widget widget) =>
        widget is DecoratedBox &&
        widget.position == DecorationPosition.foreground,
  ),
);

/// Непрозрачность затемнения над экраном.
double _scrimOpacity(WidgetTester tester, String text) {
  final Finder scrim = _scrimOf(text);
  expect(
    scrim,
    findsOneWidget,
    reason: 'глубину даёт не только разный ход, но и затемнение уходящего',
  );
  final BoxDecoration decoration =
      tester.widget<DecoratedBox>(scrim).decoration as BoxDecoration;
  return decoration.color!.a;
}

/// Поднимает домашний экран и нажимает кнопку: переход стартовал, но ещё не
/// отрисован.
Future<void> _openSecond(
  WidgetTester tester, {
  required WidgetBuilder page,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: _theme(),
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) => TextButton(
            onPressed: () =>
                Navigator.of(context)
                    .push<void>(MaterialPageRoute<void>(builder: page)),
            child: const Text('home'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('home'));
}

void main() {
  test('длительность перехода — 320 мс', () {
    const ParallaxPageTransitionsBuilder builder =
        ParallaxPageTransitionsBuilder();

    expect(builder.transitionDuration, const Duration(milliseconds: 320));
  });

  testWidgets(
    'входящий экран едет справа на полную ширину и доезжает до нуля',
    (WidgetTester tester) async {
      await _openSecond(
        tester,
        page: (BuildContext context) => const Scaffold(body: Text('second')),
      );

      // Первый кадр после нажатия маршрут уже в дереве, но ещё под `Offstage`,
      // поэтому меряем со следующего кадра.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      expect(
        _dx(tester, 'second'),
        greaterThan(0.9),
        reason: 'входящий стартует почти за правым краем — ход на всю ширину',
      );

      await tester.pump(const Duration(milliseconds: 112));
      expect(
        _dx(tester, 'second'),
        lessThan(0.2),
        reason: 'экран доезжает до своего места',
      );

      await tester.pump(const Duration(milliseconds: 192));
      expect(
        _dx(tester, 'second'),
        moreOrLessEquals(0, epsilon: 0.002),
        reason: 'по завершении перехода экран стоит на месте',
      );
    },
  );

  testWidgets('уходящий экран уезжает только на четверть и притухает', (
    WidgetTester tester,
  ) async {
    await _openSecond(
      tester,
      page: (BuildContext context) => const Scaffold(body: Text('second')),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    expect(
      _dx(tester, 'home').abs(),
      lessThan(0.01),
      reason: 'на старте уходящий ещё стоит: входящий идёт в одиночку',
    );
    expect(
      _scrimOpacity(tester, 'home'),
      lessThan(0.01),
      reason: 'затемнение нарастает по мере ухода, а не появляется сразу',
    );

    // На кадре завершения перехода обе страницы ещё в дереве; следующий кадр
    // отправит нижнюю под `Offstage`, и её уже не найти по тексту.
    await tester.pump(const Duration(milliseconds: 304));
    expect(
      _dx(tester, 'home'),
      moreOrLessEquals(
        -ParallaxPageTransitionsBuilder.kOutgoingFraction,
        epsilon: 0.001,
      ),
      reason: 'уходящий проходит ровно четверть пути — в этом и параллакс',
    );
    expect(
      _scrimOpacity(tester, 'home'),
      moreOrLessEquals(
        ParallaxPageTransitionsBuilder.kScrimOpacity,
        epsilon: 0.001,
      ),
    );
  });

  testWidgets('поддерево страницы не перестраивается во время перехода', (
    WidgetTester tester,
  ) async {
    int builds = 0;

    await _openSecond(
      tester,
      page: (BuildContext context) => _CountedPage(onBuild: () => builds++),
    );

    await tester.pump();
    expect(builds, 1, reason: 'страница собирается один раз при появлении');

    for (int frame = 0; frame < 25; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    expect(
      builds,
      1,
      reason:
          'переход обязан анимировать уже собранное поддерево, иначе тяжёлое '
          'расписание перестраивается каждый кадр',
    );
  });
}
