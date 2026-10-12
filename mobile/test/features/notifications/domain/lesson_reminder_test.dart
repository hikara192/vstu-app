import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/notifications/domain/lesson_reminder.dart';
import 'package:vstu_app/features/schedule/data/schedule_models.dart';
import 'package:vstu_app/features/schedule/domain/schedule_builder.dart';

import '../../../support/fixtures.dart';

void main() {
  final mondayOfSemester = DateTime(2025, 2, 3);

  ScheduleBuilder mondaySchedule(List<Lesson> lessons) => ScheduleBuilder(
    semesterStart: mondayOfSemester,
    lessons: lessons,
    weekAnchor: WeekCycleAnchor(date: mondayOfSemester, number: 1),
  );

  group('LessonReminderPlanner.plan', () {
    test('schedules a reminder five minutes before each lesson', () {
      final builder = mondaySchedule(<Lesson>[buildLesson()]);
      final reminders = LessonReminderPlanner(horizonDays: 8).plan(
        builder,
        from: DateTime(2025, 2, 3),
      );

      expect(reminders, hasLength(2));
      expect(reminders.first.when, DateTime(2025, 2, 3, 7, 55));
      expect(reminders.last.when, DateTime(2025, 2, 10, 7, 55));
      expect(reminders.last.id - reminders.first.id, 7 * 1000);
    });

    test('builds a title and a body with the room', () {
      final builder = mondaySchedule(<Lesson>[buildLesson()]);
      final reminder = LessonReminderPlanner(horizonDays: 1).plan(
        builder,
        from: DateTime(2025, 2, 3),
      ).single;

      expect(reminder.title, 'Математика');
      expect(reminder.body, contains('Через 5 мин'));
      expect(reminder.body, contains('8:00–9:35'));
      expect(reminder.body, contains('2 корп., ауд. 305'));
    });

    test('never plans reminders for Sundays', () {
      final builder = mondaySchedule(
        <Lesson>[
          buildLesson(
            id: 9,
            dayOfWeek: 6,
            subject: 'Факультатив',
            dateStart: DateTime(2025, 2, 3),
            dateEnd: DateTime(2025, 2, 28),
          ),
        ],
      );
      final reminders = LessonReminderPlanner(horizonDays: 15).plan(
        builder,
        from: DateTime(2025, 2, 3),
      );

      expect(reminders, isEmpty);
    });

    test('skips reminders whose trigger time has already passed', () {
      final builder = mondaySchedule(<Lesson>[buildLesson()]);
      final reminders = LessonReminderPlanner(horizonDays: 8).plan(
        builder,
        from: DateTime(2025, 2, 4),
      );

      expect(reminders, hasLength(1));
      expect(reminders.single.when, DateTime(2025, 2, 10, 7, 55));
    });

    test('mentions a subgroup in the body when the lesson is split', () {
      final builder = mondaySchedule(
        <Lesson>[buildLesson(subGroup: '1')],
      );
      final reminder = LessonReminderPlanner(horizonDays: 1).plan(
        builder,
        from: DateTime(2025, 2, 3),
      ).single;

      expect(reminder.body, contains('подгруппа 1'));
    });
  });
}