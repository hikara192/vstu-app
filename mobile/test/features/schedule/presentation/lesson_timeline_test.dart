import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/schedule/presentation/lesson_timeline.dart';

import '../../../support/fixtures.dart';

void main() {
  // Произвольный «учебный» день; время пары у buildLesson: 8:00–9:35,
  // перерыв (у пары с перерывом): 8:45–8:50.
  final DateTime day = DateTime(2026, 3, 16);

  Widget wrap(LessonTimeline timeline) =>
      MaterialApp(home: Scaffold(body: timeline));

  Color fillColorOf(WidgetTester tester) {
    final FractionallySizedBox box =
        tester.widget<FractionallySizedBox>(find.byKey(lessonTimelineFillKey));
    final DecoratedBox decorated = box.child! as DecoratedBox;
    return (decorated.decoration as BoxDecoration).color!;
  }

  /// Доля, на которой начинается перерыв: 45 мин из 95 мин пары.
  final double pauseStartFraction = 45 / 95;

  testWidgets('бар скрыт до начала пары', (tester) async {
    final DateTime now = DateTime(2026, 3, 16, 7, 59);
    await tester.pumpWidget(
      wrap(
        LessonTimeline(
          lesson: buildLesson(),
          date: day,
          now: () => now,
        ),
      ),
    );

    expect(find.byKey(lessonTimelineFillKey), findsNothing);
    expect(find.textContaining('осталось'), findsNothing);
    expect(find.textContaining('перерыв'), findsNothing);
  });

  testWidgets('бар скрыт после конца пары', (tester) async {
    final DateTime now = DateTime(2026, 3, 16, 9, 36);
    await tester.pumpWidget(
      wrap(
        LessonTimeline(
          lesson: buildLesson(),
          date: day,
          now: () => now,
        ),
      ),
    );

    expect(find.byKey(lessonTimelineFillKey), findsNothing);
  });

  testWidgets('разделитель есть у пары с перерывом и отсутствует у короткой',
      (tester) async {
    final DateTime now = DateTime(2026, 3, 16, 8, 20);
    await tester.pumpWidget(
      wrap(
        LessonTimeline(
          lesson: buildLesson(),
          date: day,
          now: () => now,
        ),
      ),
    );
    expect(find.byKey(lessonTimelineDividerKey), findsOneWidget);

    await tester.pumpWidget(
      wrap(
        LessonTimeline(
          lesson: buildLesson(timeStart: '8:00', timeEnd: '8:40'),
          date: day,
          now: () => now,
        ),
      ),
    );
    expect(find.byKey(lessonTimelineDividerKey), findsNothing);
  });

  testWidgets('заполнение замирает на разделителе во время перерыва',
      (tester) async {
    DateTime now = DateTime(2026, 3, 16, 8, 47); // перерыв
    await tester.pumpWidget(
      wrap(
        LessonTimeline(
          lesson: buildLesson(),
          date: day,
          now: () => now,
        ),
      ),
    );

    final double frozen =
        tester.widget<FractionallySizedBox>(find.byKey(lessonTimelineFillKey))
            .widthFactor!;
    expect(frozen, closeTo(pauseStartFraction, 0.0001));

    now = DateTime(2026, 3, 16, 8, 49); // перерыв вот-вот закончится
    await tester.pump(const Duration(seconds: 1));

    final double stillFrozen =
        tester.widget<FractionallySizedBox>(find.byKey(lessonTimelineFillKey))
            .widthFactor!;
    expect(stillFrozen, closeTo(pauseStartFraction, 0.0001));
  });

  testWidgets('во время перерыва бар серый и показывает таймер mm:ss',
      (tester) async {
    final DateTime now = DateTime(2026, 3, 16, 8, 47);
    const Color lessonColor = Color(0xFF123456);
    await tester.pumpWidget(
      wrap(
        LessonTimeline(
          lesson: buildLesson(),
          date: day,
          color: lessonColor,
          now: () => now,
        ),
      ),
    );

    expect(find.text('перерыв · 3:00'), findsOneWidget);
    expect(find.text('до 8:50'), findsOneWidget);
    expect(fillColorOf(tester), isNot(lessonColor));
  });

  testWidgets('после перерыва заполнение продолжает расти и цвет возвращается',
      (tester) async {
    DateTime now = DateTime(2026, 3, 16, 8, 47);
    const Color lessonColor = Color(0xFF123456);
    await tester.pumpWidget(
      wrap(
        LessonTimeline(
          lesson: buildLesson(),
          date: day,
          color: lessonColor,
          now: () => now,
        ),
      ),
    );

    now = DateTime(2026, 3, 16, 8, 55); // вторая академическая пара
    await tester.pump(const Duration(seconds: 1));

    final double resumed =
        tester.widget<FractionallySizedBox>(find.byKey(lessonTimelineFillKey))
            .widthFactor!;
    // 55 минут из 95
    expect(resumed, closeTo(55 / 95, 0.0001));
    expect(fillColorOf(tester), lessonColor);
    expect(find.text('до 9:35'), findsOneWidget);
  });

  testWidgets('в первый час показывается остаток до конца пары',
      (tester) async {
    final DateTime now = DateTime(2026, 3, 16, 8, 20);
    await tester.pumpWidget(
      wrap(
        LessonTimeline(
          lesson: buildLesson(),
          date: day,
          now: () => now,
        ),
      ),
    );

    expect(find.text('осталось 1 час 15 минут'), findsOneWidget);
    expect(find.text('до 9:35'), findsOneWidget);
  });

  testWidgets('заливка реально отрисовывается ненулевой высоты и нужной ширины',
      (tester) async {
    final DateTime now = DateTime(2026, 3, 16, 8, 47); // перерыв: 45/95
    await tester.pumpWidget(
      wrap(
        LessonTimeline(
          lesson: buildLesson(),
          date: day,
          now: () => now,
        ),
      ),
    );

    final Size track = tester.getSize(find.byKey(lessonTimelineTrackKey));
    final Size fill = tester.getSize(find.byKey(lessonTimelineFillKey));

    // Трек занимает всю ширину, заливка — ненулевой высоты и своей доли.
    expect(track.width, greaterThan(100));
    expect(fill.height, greaterThan(0));
    expect(fill.width / track.width, closeTo(45 / 95, 0.02));
  });

  testWidgets('короткая пара: трек во всю ширину, заливка растёт по времени',
      (tester) async {
    final DateTime now = DateTime(2026, 3, 16, 8, 20);
    await tester.pumpWidget(
      wrap(
        LessonTimeline(
          lesson: buildLesson(timeStart: '8:00', timeEnd: '8:40'),
          date: day,
          now: () => now,
        ),
      ),
    );

    final Size track = tester.getSize(find.byKey(lessonTimelineTrackKey));
    final Size fill = tester.getSize(find.byKey(lessonTimelineFillKey));

    expect(track.width, greaterThan(100));
    expect(fill.height, greaterThan(0));
    // 20 минут из 40
    expect(fill.width / track.width, closeTo(0.5, 0.02));
  });

  testWidgets('отрисовывается внутри IntrinsicHeight и Row, как в карточке пары',
      (tester) async {
    final DateTime now = DateTime(2026, 3, 16, 8, 47);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(width: 60),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        LessonTimeline(
                          lesson: buildLesson(),
                          date: day,
                          now: () => now,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}