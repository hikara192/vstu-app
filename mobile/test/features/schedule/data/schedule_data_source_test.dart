import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/core/network/api_exception.dart';
import 'package:vstu_app/features/schedule/data/schedule_data_source.dart';
import 'package:vstu_app/features/schedule/data/schedule_models.dart';

import '../../../support/fixtures.dart';

void main() {
  group('lessonFromUni', () {
    test('parses a full payload', () {
      final lesson = lessonFromUni(lessonJson(teacher: teacherJson));

      expect(lesson, isNotNull);
      expect(lesson!.id, 1);
      expect(lesson.number, 1);
      expect(lesson.subject, 'Математика');
      expect(lesson.type, 'Лекция');
      expect(lesson.typeShort, 'лк');
      expect(lesson.room, '305');
      expect(lesson.frame, 2);
      expect(lesson.weekType, LessonWeekType.always);
      expect(lesson.subGroup, allSubgroups);
      expect(lesson.dayOfWeek, 0);
      expect(lesson.dateStart, DateTime(2025, 2, 3));
      expect(lesson.dateEnd, DateTime(2025, 5, 31));
      expect(lesson.teacher?.fullName, 'Тестовый Преподаватель');
    });

    test('rejects lessons that are not active', () {
      expect(lessonFromUni(lessonJson(status: 'ARCHIVED')), isNull);
    });

    test('rejects payloads missing a required field', () {
      final withoutId = lessonJson(id: 1)..remove('id');
      expect(lessonFromUni(withoutId), isNull);

      final withoutNumber = lessonJson(number: 1)..remove('lessonNumber');
      expect(lessonFromUni(withoutNumber), isNull);

      final withoutSubject = lessonJson(subject: 'Математика')
        ..remove('disciplineName');
      expect(lessonFromUni(withoutSubject), isNull);
    });

    test('rejects an invalid day of week', () {
      expect(lessonFromUni(lessonJson(dayOfWeek: 8)), isNull);
      expect(lessonFromUni(lessonJson(dayOfWeek: -1)), isNull);
    });

    test('falls back to "always" for an unknown week type', () {
      final lesson = lessonFromUni(lessonJson(weekType: 'Какая-то'));
      expect(lesson!.weekType, LessonWeekType.always);
    });
  });

  group('weekCycleAnchorFromUni', () {
    test('parses a valid anchor', () {
      final anchor = weekCycleAnchorFromUni(<String, Object?>{
        'numberOfWeek': 3,
        'date': '2025-02-03',
      });

      expect(anchor, isNotNull);
      expect(anchor!.number, 3);
      expect(anchor.date, DateTime(2025, 2, 3));
    });

    test('returns null for invalid payloads', () {
      expect(
        weekCycleAnchorFromUni(<String, Object?>{
          'numberOfWeek': 0,
          'date': '2025-02-03',
        }),
        isNull,
      );
      expect(
        weekCycleAnchorFromUni(<String, Object?>{'numberOfWeek': 3}),
        isNull,
      );
      expect(
        weekCycleAnchorFromUni(<String, Object?>{
          'numberOfWeek': 3,
          'date': 'не-дата',
        }),
        isNull,
      );
      expect(weekCycleAnchorFromUni(null), isNull);
      expect(weekCycleAnchorFromUni(<Object?>[1]), isNull);
    });
  });

  group('groupInfoFromUni', () {
    test('parses a valid payload', () {
      final info = groupInfoFromUni(
        <String, Object?>{
          'id': 42,
          'name': 'А-37',
          'facultyName': 'ФИТ',
          'currentCourse': 2,
        },
        fallbackId: 42,
      );

      expect(info, isNotNull);
      expect(info!.id, 42);
      expect(info.name, 'А-37');
      expect(info.facultyName, 'ФИТ');
      expect(info.course, 2);
    });

    test('returns null for a non-map payload', () {
      expect(groupInfoFromUni('не карта', fallbackId: 1), isNull);
      expect(groupInfoFromUni(null, fallbackId: 1), isNull);
    });
  });

  group('groupScheduleFromUni', () {
    test('builds a schedule with group info and semester start', () {
      final schedule = groupScheduleFromUni(
        <Object?>[lessonJson(teacher: teacherJson, group: groupJson)],
        groupId: 42,
      );

      expect(schedule.group.id, 42);
      expect(schedule.group.name, 'А-37');
      expect(schedule.group.facultyName, 'ФИТ');
      expect(schedule.semesterStart, DateTime(2025, 2, 3));
      expect(schedule.lessons, hasLength(1));
      expect(schedule.weekAnchor, isNull);
    });

    test('empty payload means "no published lessons", not "missing group"', () {
      expect(
        () => groupScheduleFromUni(const <Object?>[], groupId: 42),
        throwsA(
          isA<ApiException>()
              .having((error) => error.code, 'code', 'schedule_empty')
              .having(
                (error) => error.message,
                'message',
                'Для этой группы расписание пока не опубликовано',
              ),
        ),
      );
    });

    test('an all-inactive payload is also "no published lessons"', () {
      expect(
        () => groupScheduleFromUni(
          <Object?>[lessonJson(status: 'ARCHIVED')],
          groupId: 42,
        ),
        throwsA(
          isA<ApiException>().having((error) => error.code, 'code', 'schedule_empty'),
        ),
      );
    });
  });
}