import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/schedule/data/schedule_models.dart';
import 'package:vstu_app/features/schedule/domain/schedule_builder.dart';

import '../../../support/fixtures.dart';

void main() {
  final mondayOfSemester = DateTime(2025, 2, 3);

  ScheduleBuilder builderWithAnchor(List<Lesson> lessons) => ScheduleBuilder(
    semesterStart: mondayOfSemester,
    lessons: lessons,
    weekAnchor: WeekCycleAnchor(date: mondayOfSemester, number: 1),
  );

  ScheduleBuilder builderWithoutAnchor(List<Lesson> lessons) =>
      ScheduleBuilder(semesterStart: mondayOfSemester, lessons: lessons);

  group('WeekInfo', () {
    test('odd week numbers are numerator weeks', () {
      final info = WeekInfo(
        number: 1,
        startsOn: _monday,
        endsOn: _sunday,
      );
      expect(info.isNumerator, isTrue);
      expect(info.parity, LessonWeekType.numerator);
    });

    test('even week numbers are denominator weeks', () {
      final info = WeekInfo(
        number: 2,
        startsOn: _monday,
        endsOn: _sunday,
      );
      expect(info.isNumerator, isFalse);
      expect(info.parity, LessonWeekType.denominator);
    });
  });

  group('ScheduleBuilder.weekOf', () {
    final anchored = builderWithAnchor(const <Lesson>[]);

    test('starts the 4-week cycle at the anchor week', () {
      final week = anchored.weekOf(mondayOfSemester);
      expect(week.number, 1);
      expect(week.isNumerator, isTrue);
      expect(week.startsOn, mondayOfSemester);
      expect(week.endsOn, DateTime(2025, 2, 9));
    });

    test('advances to the next parity the following week', () {
      final week = anchored.weekOf(DateTime(2025, 2, 10));
      expect(week.number, 2);
      expect(week.isNumerator, isFalse);
    });

    test('wraps the cycle after four weeks', () {
      expect(anchored.weekOf(DateTime(2025, 3, 3)).number, 1);
      expect(anchored.weekOf(DateTime(2025, 3, 10)).number, 2);
    });

    test('maps a mid-week date to its Monday', () {
      expect(anchored.weekOf(DateTime(2025, 2, 5)).startsOn, mondayOfSemester);
    });

    test('falls back to the semester index when there is no anchor', () {
      final plain = builderWithoutAnchor(const <Lesson>[]);
      expect(plain.weekOf(mondayOfSemester).number, 1);
      expect(plain.weekOf(DateTime(2025, 2, 24)).number, 4);
      expect(plain.weekOf(DateTime(2025, 3, 10)).number, 2);
    });
  });

  group('ScheduleBuilder.occursOn', () {
    final anchored = builderWithAnchor(const <Lesson>[]);
    final everyMonday = buildLesson();
    final numeratorWeek = anchored.weekOf(mondayOfSemester);
    final denominatorWeek = anchored.weekOf(DateTime(2025, 2, 10));

    test('matches a lesson on its own weekday', () {
      expect(
        ScheduleBuilder.occursOn(everyMonday, mondayOfSemester, numeratorWeek),
        isTrue,
      );
    });

    test('does not match on another weekday', () {
      expect(
        ScheduleBuilder.occursOn(everyMonday, DateTime(2025, 2, 4), numeratorWeek),
        isFalse,
      );
    });

    test('does not match outside the lesson date range', () {
      expect(
        ScheduleBuilder.occursOn(
          everyMonday,
          DateTime(2025, 1, 27),
          numeratorWeek,
        ),
        isFalse,
      );
      expect(
        ScheduleBuilder.occursOn(
          everyMonday,
          DateTime(2025, 6, 2),
          numeratorWeek,
        ),
        isFalse,
      );
    });

    test('parity lessons only match their week type', () {
      final denominatorOnly = buildLesson(
        id: 2,
        weekType: LessonWeekType.denominator,
      );
      expect(
        ScheduleBuilder.occursOn(denominatorOnly, mondayOfSemester, numeratorWeek),
        isFalse,
      );
      expect(
        ScheduleBuilder.occursOn(
          denominatorOnly,
          DateTime(2025, 2, 10),
          denominatorWeek,
        ),
        isTrue,
      );
    });
  });

  group('ScheduleBuilder.stateOf', () {
    final lesson = buildLesson();
    final date = mondayOfSemester;

    test('reports upcoming before the lesson starts', () {
      expect(
        ScheduleBuilder.stateOf(lesson, date, DateTime(2025, 2, 3, 7, 59)),
        LessonState.upcoming,
      );
    });

    test('reports ongoing inside the lesson', () {
      expect(
        ScheduleBuilder.stateOf(lesson, date, DateTime(2025, 2, 3, 8, 0)),
        LessonState.ongoing,
      );
      expect(
        ScheduleBuilder.stateOf(lesson, date, DateTime(2025, 2, 3, 9, 34)),
        LessonState.ongoing,
      );
    });

    test('reports finished at and after the end time', () {
      expect(
        ScheduleBuilder.stateOf(lesson, date, DateTime(2025, 2, 3, 9, 35)),
        LessonState.finished,
      );
      expect(
        ScheduleBuilder.stateOf(lesson, date, DateTime(2025, 2, 3, 12, 0)),
        LessonState.finished,
      );
    });
  });

  group('ScheduleBuilder.slotsOn', () {
    test('merges repeating lessons with identical details into one variant', () {
      final firstHalf = buildLesson(
        id: 1,
        dateStart: DateTime(2025, 2, 3),
        dateEnd: DateTime(2025, 3, 2),
      );
      final secondHalf = buildLesson(
        id: 2,
        dateStart: DateTime(2025, 2, 10),
        dateEnd: DateTime(2025, 5, 31),
      );

      final slots = builderWithAnchor(<Lesson>[firstHalf, secondHalf])
          .slotsOn(DateTime(2025, 2, 10));

      expect(slots, hasLength(1));
      final slot = slots.single;
      expect(slot.isSplit, isFalse);
      expect(slot.lesson.dateStart, DateTime(2025, 2, 3));
      expect(slot.lesson.dateEnd, DateTime(2025, 5, 31));
      expect(slot.timeStart, '8:00');
      expect(slot.timeEnd, '9:35');
    });

    test('keeps differently-subjected lessons as separate variants', () {
      final math = buildLesson(
        id: 1,
        dateStart: DateTime(2025, 2, 3),
        dateEnd: DateTime(2025, 3, 2),
      );
      final physics = buildLesson(
        id: 3,
        subject: 'Физика',
        dateStart: DateTime(2025, 2, 10),
        dateEnd: DateTime(2025, 5, 31),
      );

      final slots = builderWithAnchor(<Lesson>[math, physics])
          .slotsOn(DateTime(2025, 2, 10));

      final slot = slots.single;
      expect(slot.isSplit, isTrue);
      expect(slot.variants, hasLength(2));
      expect(slot.commonType, 'лк');
      expect(
        slot.variants.map((lesson) => lesson.subject),
        containsAll(<String>['Математика', 'Физика']),
      );
    });

    test('orders lessons by lesson number, then subgroup, then subject', () {
      final allGroup = buildLesson(number: 2, subject: 'Физика');
      final wholeGroup = buildLesson(number: 1, subGroup: allSubgroups);
      final firstSubgroup = buildLesson(number: 1, subGroup: '1');

      final sorted = <Lesson>[firstSubgroup, allGroup, wholeGroup]
        ..sort(ScheduleBuilder.compareLessons);

      expect(
        sorted.map((lesson) => lesson.subject).toList(),
        <String>['Математика', 'Математика', 'Физика'],
      );
    });
  });

  group('ScheduleBuilder.dayView', () {
    final anchored = builderWithAnchor(
      <Lesson>[buildLesson(timeStart: '9:50', timeEnd: '11:25')],
    );

    test('computes the morning gap from the 8:00 baseline', () {
      final day = anchored.dayView(mondayOfSemester);
      expect(day.isEmpty, isFalse);
      expect(day.morningGap, const Duration(hours: 1, minutes: 50));
    });

    test('reports an empty day with no gap', () {
      final day = anchored.dayView(DateTime(2025, 2, 4));
      expect(day.isEmpty, isTrue);
      expect(day.morningGap, isNull);
    });

    test('detects today across the whole day', () {
      final day = anchored.dayView(mondayOfSemester);
      expect(day.isToday(DateTime(2025, 2, 3, 23, 59)), isTrue);
      expect(day.isToday(DateTime(2025, 2, 4)), isFalse);
    });
  });

  group('ScheduleBuilder.weekView', () {
    test('builds seven days starting on Monday', () {
      final week = builderWithAnchor(const <Lesson>[]).weekView(mondayOfSemester);
      expect(week, hasLength(7));
      expect(week.first.date, DateTime(2025, 2, 3));
      expect(week.last.date, DateTime(2025, 2, 9));
    });
  });

  group('academicPauseOf', () {
    test('inserts a pause after the first academic hour of a long lesson', () {
      final date = DateTime(2025, 2, 3);
      final lesson = buildLesson();
      expect(
        academicPauseOf(lesson, date),
        (DateTime(2025, 2, 3, 8, 45), DateTime(2025, 2, 3, 8, 50)),
      );
    });

    test('returns null for a lesson shorter than an hour with pause', () {
      final date = DateTime(2025, 2, 3);
      final short = buildLesson(timeStart: '8:00', timeEnd: '8:40');
      expect(academicPauseOf(short, date), isNull);
    });

    test('returns null when the lesson has no time range', () {
      final date = DateTime(2025, 2, 3);
      final noTime = buildLesson(timeStart: '', timeEnd: '');
      expect(academicPauseOf(noTime, date), isNull);
    });
  });
}

final DateTime _monday = DateTime(2025, 2, 3);

final DateTime _sunday = DateTime(2025, 2, 9);