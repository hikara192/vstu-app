import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/app/app_colors.dart';
import 'package:vstu_app/core/widgets/gradient_header.dart';

/// Контейнер подложки — тот, что рисует градиент шапки.
Finder _surfaceBoxAbove(Finder of) => find.ancestor(
  of: of,
  matching: find.byWidgetPredicate(
    (Widget widget) =>
        widget is Container &&
        (widget.decoration as BoxDecoration?)?.gradient != null,
  ),
);

BoxDecoration _decorationOf(WidgetTester tester, Finder box) =>
    tester.widget<Container>(box).decoration! as BoxDecoration;

void main() {
  group('GradientHeader', () {
    testWidgets('рисует заголовок, подзаголовок и действия внутри подложки', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientHeader(
              title: 'VSTU HOME',
              subtitle: 'Расписание',
              actions: <Widget>[Icon(Icons.tune_rounded)],
            ),
          ),
        ),
      );

      expect(find.text('VSTU HOME'), findsOneWidget);
      expect(find.text('Расписание'), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(GradientHeaderSurface),
          matching: find.byType(GradientHeaderContent),
        ),
        findsOneWidget,
        reason: 'шапка — это ровно подложка плюс содержимое',
      );
    });
  });

  group('GradientHeaderSurface', () {
    testWidgets('принимает произвольное содержимое и владеет подложкой', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientHeaderSurface(
              child: Column(
                children: <Widget>[
                  Text('произвольное'),
                  Icon(Icons.tune_rounded),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('произвольное'), findsOneWidget);

      final Finder box = _surfaceBoxAbove(find.text('произвольное'));
      expect(
        box,
        findsOneWidget,
        reason:
            'окно хрома должно уметь нарисовать подложку под любым содержимым',
      );

      final BoxDecoration decoration = _decorationOf(tester, box);
      expect(decoration.gradient, isNotNull);
      expect(
        (decoration.gradient! as LinearGradient).colors,
        AppColors.light.heroGradient,
      );
      expect(
        decoration.borderRadius,
        const BorderRadius.vertical(bottom: Radius.circular(26)),
      );
      expect(decoration.boxShadow, isNotEmpty);

      // Отступ под системный вырез — часть подложки, а не содержимого: в тестах
      // верхнего выреза нет, поэтому остаются только 12 сверху.
      expect(
        tester.widget<Container>(box).padding,
        const EdgeInsets.fromLTRB(16, 12, 16, 18),
      );

      expect(
        IconTheme.of(tester.element(find.byIcon(Icons.tune_rounded))).color,
        Colors.white,
        reason: 'на градиенте иконки обязаны быть белыми независимо от темы',
      );
    });
  });
}
