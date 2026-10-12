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

  group('sdoCategoryFromMoodle', () {
    test('разбирает категорию', () {
      final SdoCategory cat = sdoCategoryFromMoodle(<String, dynamic>{
        'id': 5,
        'name': 'Программирование',
        'parent': 0,
        'coursecount': 12,
        'idnumber': 'prog',
      });

      expect(cat.id, 5);
      expect(cat.name, 'Программирование');
      expect(cat.parent, 0);
      expect(cat.courseCount, 12);
      expect(cat.idNumber, 'prog');
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

  group('sdoAssignmentFromMoodle', () {
    test('разбирает задание с дедлайнами', () {
      final SdoAssignment assignment = sdoAssignmentFromMoodle(
        <String, dynamic>{
          'id': 10,
          'course': 17,
          'name': 'Лаб 1',
          'cmid': 5,
          'intro': '<p>Описание</p>',
          'duedate': 1700000000,
          'allowsubmissionsfromdate': 1699000000,
          'cutoffdate': 1701000000,
          'maxattempts': 3,
          'configs': <dynamic>[
            {'plugin': 'onlinetext', 'name': 'enabled', 'value': 1},
            {'plugin': 'file', 'name': 'enabled', 'value': 1},
          ],
          'status': 'submitted',
        },
        courseId: 17,
      );

      expect(assignment.id, 10);
      expect(assignment.courseId, 17);
      expect(assignment.name, 'Лаб 1');
      expect(assignment.courseModuleId, 5);
      expect(assignment.description, 'Описание');
      expect(assignment.dueDate, isNotNull);
      expect(assignment.requiresText, isTrue);
      expect(assignment.requiresFile, isTrue);
      expect(assignment.maxAttempts, 3);
      expect(assignment.status, SdoSubmissionStatus.submitted);
    });
  });

  group('sdoSubmissionFromStatus', () {
    test('парсит отправку с текстом и файлами', () {
      final SdoSubmission submission = sdoSubmissionFromStatus(<String, dynamic>{
        'lastattempt': {
          'submission': {
            'status': 'draft',
            'timemodified': 1700000000,
            'plugins': <dynamic>[
              {
                'editorfields': <dynamic>[
                  {'name': 'text', 'value': 'Мой ответ'},
                ],
                'fileareas': <dynamic>[
                  {
                    'files': <dynamic>[
                      {
                        'filename': 'file.pdf',
                        'fileurl': 'https://sdo.vstu.by/.../file.pdf',
                        'mimetype': 'application/pdf',
                        'filesize': 1024,
                        'timemodified': 1700000000,
                      },
                    ],
                  },
                ],
              },
            ],
          },
        },
      });

      expect(submission.status, SdoSubmissionStatus.draft);
      expect(submission.onlineText, 'Мой ответ');
      expect(submission.files, hasLength(1));
      expect(submission.files.first.fileName, 'file.pdf');
      expect(submission.files.first.mimeType, 'application/pdf');
    });

    test('пустая отправка даёт статус new', () {
      final SdoSubmission submission = sdoSubmissionFromStatus(<String, dynamic>{});
      expect(submission.status, SdoSubmissionStatus.newSubmission);
      expect(submission.onlineText, '');
      expect(submission.files, isEmpty);
    });
  });

  group('sdoQuizFromMoodle', () {
    test('разбирает тест', () {
      final SdoQuiz quiz = sdoQuizFromMoodle(<String, dynamic>{
        'id': 7,
        'course': 17,
        'name': 'Тест по матану',
        'coursemodule': 8,
        'intro': '<p>Правила</p>',
        'timeopen': 1700000000,
        'timeclose': 1701000000,
        'timelimit': 60,
        'attempts': 2,
        'grademethod': 1,
        'hasquestions': 1,
      });

      expect(quiz.id, 7);
      expect(quiz.courseId, 17);
      expect(quiz.name, 'Тест по матану');
      expect(quiz.courseModuleId, 8);
      expect(quiz.intro, 'Правила');
      expect(quiz.timeOpen, isNotNull);
      expect(quiz.timeClose, isNotNull);
      expect(quiz.timeLimit, 60);
      expect(quiz.maxAttempts, 2);
    });
  });

  group('sdoQuizAttemptFromMoodle', () {
    test('разбирает попытку', () {
      final SdoQuizAttempt attempt = sdoQuizAttemptFromMoodle(<String, dynamic>{
        'id': 1,
        'quiz': 7,
        'attempt': 1,
        'state': 'finished',
        'timestart': 1700000000,
        'timefinish': 1700003600,
        'sumgrades': 8.5,
      });

      expect(attempt.id, 1);
      expect(attempt.quizId, 7);
      expect(attempt.attempt, 1);
      expect(attempt.state, 'finished');
      expect(attempt.isFinished, isTrue);
      expect(attempt.isInProgress, isFalse);
      expect(attempt.grade, 8.5);
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
              'contents': <dynamic>[
                {
                  'filename': 'lecture1.pdf',
                  'fileurl': 'https://sdo.vstu.by/.../lecture1.pdf',
                  'mimetype': 'application/pdf',
                  'filesize': 2048,
                },
              ],
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
      expect(sections.single.modules.first.contents, hasLength(1));
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
        stripHtml('<p>Привет&nbsp;<b>мир</b> &  всем</p>'),
        'Привет мир & всем',
      );
      expect(stripHtml(null), '');
    });
  });

  group('SdoFile extensions', () {
    test('isWebLink определяет ссылки', () {
      final f1 = SdoFile(fileUrl: 'https://example.com');
      final f2 = SdoFile(fileUrl: '');
      final f3 = SdoFile(type: 'url');
      final f4 = SdoFile(type: 'file', fileUrl: 'https://sdo.vstu.by/...');
      expect(f1.isWebLink, isTrue);
      expect(f2.isWebLink, isFalse);
      expect(f3.isWebLink, isTrue);
      expect(f4.isWebLink, isTrue);
    });

    test('isImage и isPdf', () {
      expect(SdoFile(mimeType: 'image/png').isImage, isTrue);
      expect(SdoFile(mimeType: 'application/pdf').isPdf, isTrue);
      expect(SdoFile(mimeType: 'application/msword').isPdf, isFalse);
    });
  });
}