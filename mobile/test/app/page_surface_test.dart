import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vstu_app/app/page_surface.dart';

void main() {
  // Цвет намеренно не равен умолчанию: подложка обязана брать фон темы, иначе
  // тема перестанет на неё влиять.
  const Color background = Color(0xFF123456);

  Future<void> pumpSurface(WidgetTester tester, {Widget? child}) =>
      tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(scaffoldBackgroundColor: background),
          home: PageSurface(child: child ?? const SizedBox.expand()),
        ),
      );

  testWidgets('закрывает свою площадь фоном темы', (WidgetTester tester) async {
    await pumpSurface(tester);

    final Finder box = find.descendant(
      of: find.byType(PageSurface),
      matching: find.byType(ColoredBox),
    );
    expect(box, findsOneWidget);
    expect(tester.widget<ColoredBox>(box).color, background);
    expect(
      tester.getSize(box),
      tester.getSize(find.byType(PageSurface)),
      reason: 'подложка не меньше страницы: иначе края остаются прозрачными',
    );
  });

  testWidgets('пропускает содержание сквозь себя', (WidgetTester tester) async {
    await pumpSurface(tester, child: const Text('расписание'));

    expect(find.text('расписание'), findsOneWidget);
    expect(
      find.descendant(
        of: find.descendant(
          of: find.byType(PageSurface),
          matching: find.byType(ColoredBox),
        ),
        matching: find.text('расписание'),
      ),
      findsOneWidget,
      reason: 'подложка рисуется за содержанием, а не вместо него',
    );
  });
}
