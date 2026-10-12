import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/sdo/data/sdo_data_source.dart';
import 'package:vstu_app/features/sdo/data/sdo_models.dart';

void main() {
  group('sdoProfileFromMoodle', () {
    test('читает основные поля site_info', () {
      final SdoProfile profile = sdoProfileFromMoodle(<String, dynamic>{
        'sitename': 'СДО ВГТУ',
        'username': 'student',
        'fullname': 'Иванов Иван',
        'userid': 4242,
        'userpictureurl': 'https://sdo.vstu.by/u/1.jpg',
      });

      expect(profile.userId, 4242);
      expect(profile.username, 'student');
      expect(profile.fullName, 'Иванов Иван');
      expect(profile.siteName, 'СДО ВГТУ');
      expect(profile.userPictureUrl, 'https://sdo.vstu.by/u/1.jpg');
    });

    test('устойчив к пустому ответу', () {
      final SdoProfile profile = sdoProfileFromMoodle(<String, dynamic>{});
      expect(profile.userId, 0);
      expect(profile.username, '');
      expect(profile.fullName, '');
    });
  });

  group('sdoCourseFromMoodle', () {
    test('разбирает курс и unix-даты', () {
      final SdoCourse course = sdoCourseFromMoodle(<String, dynamic>{
        'id': 17,
        'shortname': 'МАТАН',
        'fullname': 'Математический анализ',
        'displayname': 'Матан (осень)',
        'categoryid': 3,
        'visible': 1,
        'startdate': 1700000000,
        'enddate': 1705000000,
      });

      expect(course.id, 17);
      expect(course.shortName, 'МАТАН');
      expect(course.title, 'Матан (осень)');
      expect(course.categoryId, 3);
      expect(course.visible, isTrue);
      expect(course.startDate?.isUtc, isFalse);
      expect(
        course.startDate,
        DateTime.fromMillisecondsSinceEpoch(1700000000 * 1000),
      );
    });

    test('title падает обратно на fullName и shortName', () {
      expect(
        sdoCourseFromMoodle(<String, dynamic>{'fullname': 'Физика'}).title,
        'Физика',
      );
      expect(
        sdoCourseFromMoodle(<String, dynamic>{'shortname': 'ФИЗ'}).title,
        'ФИЗ',
      );
    });

    test('visible=0 даёт false', () {
      expect(
        sdoCourseFromMoodle(<String, dynamic>{'id': 1, 'visible': 0}).visible,
        isFalse,
      );
    });
  });

  group('sdoDeadlineFromMoodle', () {
    test('добавляет название курса из карты', () {
      final SdoDeadline? deadline = sdoDeadlineFromMoodle(
        <String, dynamic>{
          'id': 5,
          'name': 'Сдать лабораторную',
          'courseid': 17,
          'timesort': 1700000000,
          'modulename': 'assign',
          'eventtype': 'due',
          'description': '<p>Не забудьте</p>',
          'overdue': true,
        },
        courseNames: <int, String>{17: 'Матан (осень)'},
      );

      expect(deadline, isNotNull);
      expect(deadline!.courseName, 'Матан (осень)');
      expect(deadline.moduleName, 'assign');
      expect(deadline.description, 'Не забудьте');
      expect(deadline.overdue, isTrue);
    });

    test('возвращает null без времени и идентификатора', () {
      expect(sdoDeadlineFromMoodle(<String, dynamic>{'name': 'x'}), isNull);
      expect(
        sdoDeadlineFromMoodle(<String, dynamic>{'id': 1, 'timesort': 0}),
        isNull,
      );
    });
  });

  group('sdoCourseGradesFromMoodle', () {
    test('отделяет итог курса от позиций', () {
      final SdoCourseGrades grades = sdoCourseGradesFromMoodle(<String, dynamic>{
        'usergrades': <dynamic>[
          <String, dynamic>{
            'courseid': 17,
            'gradeitems': <dynamic>[
              <String, dynamic>{
                'id': 1,
                'itemname': 'Тест 1',
                'itemtype': 'mod',
                'itemmodule': 'quiz',
                'gradeformatted': '8,50',
                'graderaw': 8.5,
                'grademax': 10,
              },
              <String, dynamic>{
                'id': 900,
                'itemname': null,
                'itemtype': 'course',
                'gradeformatted': '9,00',
              },
            ],
          },
        ],
      });

      expect(grades.courseId, 17);
      expect(grades.courseGradeFormatted, '9,00');
      expect(grades.items, hasLength(1));
      expect(grades.items.single.name, 'Тест 1');
      expect(grades.items.single.gradeRaw, 8.5);
      expect(grades.gradedItems, hasLength(1));
    });

    test('пустой ответ даёт итог с fallback courseId', () {
      final SdoCourseGrades grades = sdoCourseGradesFromMoodle(
        <String, dynamic>{},
        fallbackCourseId: 7,
      );
      expect(grades.courseId, 7);
      expect(grades.items, isEmpty);
    });
  });

  group('sdoSectionsFromMoodle', () {
    test('разбирает разделы и модули, чистит HTML', () {
      final List<SdoSection> sections = sdoSectionsFromMoodle(<dynamic>[
        <String, dynamic>{
          'id': 1,
          'name': 'Введение',
          'summary': '<p>Кратко о  курсе</p>',
          'modules': <dynamic>[
            <String, dynamic>{
              'id': 10,
              'name': 'Конспект',
              'modname': 'resource',
              'url': 'https://sdo.vstu.by/mod/resource/view.php?id=10',
              'visible': 1,
              'uservisible': 1,
            },
            <String, dynamic>{
              'id': 11,
              'name': 'Скрытый',
              'modname': 'quiz',
              'visible': 0,
            },
          ],
        },
      ]);

      expect(sections, hasLength(1));
      expect(sections.single.name, 'Введение');
      expect(sections.single.summary, 'Кратко о курсе');
      expect(sections.single.modules, hasLength(2));
      expect(sections.single.modules.first.modName, 'resource');
      expect(sections.single.modules.last.visible, isFalse);
    });

    test('не-список даёт пустой результат', () {
      expect(sdoSectionsFromMoodle(null), isEmpty);
      expect(sdoSectionsFromMoodle('nope'), isEmpty);
    });
  });

  group('stripHtml', () {
    test('убирает теги, лишние пробелы и раскрывает сущности', () {
      expect(
        stripHtml('<p>Привет&nbsp;<b>мир</b> &amp;  всем</p>'),
        'Привет мир & всем',
      );
      expect(stripHtml(null), '');
    });
  });
}
