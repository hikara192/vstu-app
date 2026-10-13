import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vstu_app/core/widgets/theme_reveal.dart';

void main() {
  testWidgets(
    'раскрытие применяет тему и не перестраивает контент в ходе анимации',
    (WidgetTester tester) async {
      final harnessKey = GlobalKey<_HarnessState>();
      await tester.pumpWidget(_Harness(key: harnessKey));

      final harness = harnessKey.currentState!;
      final buildsBefore = harness.contentBuilds;
      final tapPoint = tester.getCenter(find.text('CONTENT'));

      final finished = harness.reveal(tapPoint);

      // Даём движку снять кадр (toImage) и дойти до применения темы.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pump();
      await tester.pump();

      expect(harness.isDark, isTrue, reason: 'тема применена');
      expect(
        harness.contentBuilds,
        buildsBefore + 1,
        reason: 'смена темы — одно перестроение дерева контента',
      );
      expect(
        harness.revealCenter,
        tapPoint,
        reason: 'круг раскрывается из точки нажатия',
      );
      expect(
        find.descendant(
          of: find.byType(ThemeRevealArea),
          matching: find.byType(ClipPath),
        ),
        findsOneWidget,
        reason: 'оверлей раскрытия виден',
      );

      // Середина анимации: контент НЕ должен перестраиваться кадр за кадром.
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      final midBuilds = harness.contentBuilds;
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 60));
      expect(
        harness.contentBuilds,
        midBuilds,
        reason: 'во время анимации дерево контента не перестраивается',
      );
      expect(
        find.descendant(
          of: find.byType(ThemeRevealArea),
          matching: find.byType(ClipPath),
        ),
        findsOneWidget,
        reason: 'оверлей всё ещё виден',
      );

      // Финал: анимация завершена, оверлей убран, контент дальше не трогаем.
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump();
      await tester.pumpAndSettle();
      await finished;

      expect(
        harness.contentBuilds,
        midBuilds,
        reason: 'после завершения контент не перестраивается',
      );
      expect(
        find.descendant(
          of: find.byType(ThemeRevealArea),
          matching: find.byType(ClipPath),
        ),
        findsNothing,
        reason: 'оверлей убран после завершения',
      );
      expect(harness.commits, 1, reason: 'тема применена ровно один раз');
    },
  );

  testWidgets('повторный вызов во время раскрытия игнорируется', (
    WidgetTester tester,
  ) async {
    final harnessKey = GlobalKey<_HarnessState>();
    await tester.pumpWidget(_Harness(key: harnessKey));

    final harness = harnessKey.currentState!;
    final tapPoint = tester.getCenter(find.text('CONTENT'));

    final first = harness.reveal(tapPoint);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();

    // Второй вызов — пока раскрытие активно.
    final second = harness.reveal(tapPoint);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    await tester.pumpAndSettle();
    await first;
    await second;

    expect(harness.isDark, isTrue);
    expect(harness.commits, 1, reason: 'commit применяется один раз');
    expect(
      find.descendant(
        of: find.byType(ThemeRevealArea),
        matching: find.byType(ClipPath),
      ),
      findsNothing,
    );
  });

  testWidgets('если кадр снять не удалось — тема всё равно применяется', (
    WidgetTester tester,
  ) async {
    final harnessKey = GlobalKey<_HarnessState>();
    await tester.pumpWidget(
      _Harness(key: harnessKey, captureOverride: () async => null),
    );

    final harness = harnessKey.currentState!;
    final tapPoint = tester.getCenter(find.text('CONTENT'));

    final finished = harness.reveal(tapPoint);
    await finished;
    await tester.pump();

    expect(harness.isDark, isTrue, reason: 'тема применена без анимации');
    expect(harness.commits, 1);
    expect(find.byType(ClipPath), findsNothing, reason: 'оверлея нет');
  });

  testWidgets('повторное раскрытие: до старта анимации оверлей закрыт (нет вспышки '
      'новой темы)', (WidgetTester tester) async {
    final harnessKey = GlobalKey<_HarnessState>();
    await tester.pumpWidget(_Harness(key: harnessKey));

    final harness = harnessKey.currentState!;
    final tapPoint = tester.getCenter(find.text('CONTENT'));

    // Первое раскрытие — полностью до конца.
    final first = harness.reveal(tapPoint);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    await tester.pumpAndSettle();
    await first;
    expect(
      find.descendant(
        of: find.byType(ThemeRevealArea),
        matching: find.byType(ClipPath),
      ),
      findsNothing,
      reason: 'после первого раскрытия оверлея нет',
    );

    // Второе раскрытие: не даём commit завершиться. Раньше в этой паузе
    // контроллер стоял на value 1.0 (после прошлой анимации), оверлей
    // рисовался как progress==1 — круг «закрыл» весь экран, снимок старой
    // темы срезался целиком, и на кадр высвечивалась вся новая тема.
    final gate = Completer<void>();
    final second = harness.reveal(tapPoint, commitGate: gate);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    ); // снятие кадра
    await tester.pump(); // кадр с оверлеем; commit ещё ждёт на гейте

    expect(
      harness.revealProgress,
      0,
      reason:
          'до старта анимации оверлей должен быть на progress 0 '
          '(полностью закрывать экран), а не показывать новую тему',
    );

    // Геометрия оверлея: клип перекрывает весь экран.
    final ClipPath clip = tester.widget<ClipPath>(
      find.descendant(
        of: find.byType(ThemeRevealArea),
        matching: find.byType(ClipPath),
      ),
    );
    final ui.Path cover = clip.clipper!.getClip(
      const Size(800, 600),
    );
    expect(
      cover.getBounds(),
      const Rect.fromLTRB(0, 0, 800, 600),
      reason:
          'клип на прогресс 0 перекрывает весь экран (нет вспышки новой темы)',
    );

    gate.complete();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    await tester.pumpAndSettle();
    await second;

    expect(harness.commits, 2, reason: 'обе смены темы применены');
    expect(
      find.descendant(
        of: find.byType(ThemeRevealArea),
        matching: find.byType(ClipPath),
      ),
      findsNothing,
      reason: 'после второго раскрытия оверлей убран',
    );
  });

  testWidgets(
    'двойной тап во время снятия кадра приводит ровно к одному применению',
    (WidgetTester tester) async {
      final harnessKey = GlobalKey<_HarnessState>();
      await tester.pumpWidget(_Harness(key: harnessKey));

      final harness = harnessKey.currentState!;
      final tapPoint = tester.getCenter(find.text('CONTENT'));

      final first = harness.reveal(tapPoint);
      // Второй тап сразу, пока кадр ещё снимается: в этот момент _revealing
      // ещё false (снимок не выложен), поэтому нужен отдельный флаг «снимаем».
      final second = harness.reveal(tapPoint);

      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      await tester.pumpAndSettle();
      await first;
      await second;

      expect(
        harness.commits,
        1,
        reason: 'второй тап во время снятия кадра игнорируется',
      );
      expect(harness.isDark, isTrue);
      expect(
        find.descendant(
          of: find.byType(ThemeRevealArea),
          matching: find.byType(ClipPath),
        ),
        findsNothing,
      );
    },
  );
}

class _Harness extends StatefulWidget {
  const _Harness({super.key, this.captureOverride});

  final Future<ui.Image?> Function()? captureOverride;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  final GlobalKey<ThemeRevealAreaState> revealKey =
      GlobalKey<ThemeRevealAreaState>();

  bool _dark = false;
  int _commits = 0;
  int _contentBuilds = 0;

  bool get isDark => _dark;
  int get commits => _commits;
  int get contentBuilds => _contentBuilds;

  Offset get revealCenter => revealKey.currentState!.revealCenter;

  double get revealProgress => revealKey.currentState!.revealProgress;

  Future<void> reveal(Offset globalPoint, {Completer<void>? commitGate}) {
    return revealKey.currentState!.revealFrom(globalPoint, () async {
      _commits++;
      setState(() => _dark = true);
      if (commitGate != null) {
        await commitGate.future;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      home: ThemeRevealArea(
        key: revealKey,
        captureOverride: widget.captureOverride,
        child: Builder(
          builder: (context) {
            _contentBuilds++;
            return ColoredBox(
              color: Theme.of(context).colorScheme.surface,
              child: const Center(child: Text('CONTENT')),
            );
          },
        ),
      ),
    );
  }
}
