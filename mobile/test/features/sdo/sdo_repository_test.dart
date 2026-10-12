import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/sdo/data/sdo_exception.dart';
import 'package:vstu_app/features/sdo/data/sdo_data_source.dart';
import 'package:vstu_app/features/sdo/data/sdo_models.dart';
import 'package:vstu_app/features/sdo/data/sdo_repository.dart';
import 'package:vstu_app/features/sdo/data/sdo_token_store.dart';

const SdoProfile _profile = SdoProfile(
  userId: 42,
  username: 'student',
  fullName: 'Иванов Иван',
);

/// Источник данных-заглушка: записывает вызовы и отдаёт заданные ответы.
class _FakeDataSource implements SdoDataSource {
  int? lastCoursesUserId;
  int? lastGradesCourseId;
  int? lastGradesUserId;
  int? lastContentsCourseId;
  Map<int, String>? lastDeadlineCourseNames;

  Object? loginError;

  @override
  Future<String> requestToken({
    required String username,
    required String password,
  }) async {
    if (loginError != null) throw loginError!;
    return 'token-123';
  }

  @override
  Future<SdoProfile> fetchProfile(String token) async => _profile;

  @override
  Future<List<SdoCourse>> fetchCourses(
    String token, {
    required int userId,
  }) async {
    lastCoursesUserId = userId;
    return <SdoCourse>[
      const SdoCourse(id: 17, shortName: 'ФИЗ', fullName: 'Физика'),
    ];
  }

  @override
  Future<List<SdoDeadline>> fetchDeadlines(
    String token, {
    required Map<int, String> courseNames,
  }) async {
    lastDeadlineCourseNames = courseNames;
    return <SdoDeadline>[
      SdoDeadline(
        id: 1,
        name: 'Сдать работу',
        timeSort: DateTime(2026, 10, 20, 12),
        courseId: 17,
        courseName: courseNames[17] ?? '',
      ),
    ];
  }

  @override
  Future<SdoCourseGrades> fetchCourseGrades(
    String token, {
    required int courseId,
    required int userId,
  }) async {
    lastGradesCourseId = courseId;
    lastGradesUserId = userId;
    return SdoCourseGrades(
      courseId: courseId,
      courseGradeFormatted: '9,00',
      items: const <SdoGradeItem>[
        SdoGradeItem(id: 1, name: 'Тест 1', gradeFormatted: '8,50'),
      ],
    );
  }

  @override
  Future<List<SdoSection>> fetchCourseContents(
    String token, {
    required int courseId,
  }) async {
    lastContentsCourseId = courseId;
    return <SdoSection>[
      const SdoSection(
        id: 1,
        name: 'Раздел',
        modules: <SdoModule>[SdoModule(id: 10, name: 'Конспект')],
      ),
    ];
  }
}

class _AuthFailDataSource extends _FakeDataSource {
  @override
  Future<List<SdoCourse>> fetchCourses(
    String token, {
    required int userId,
  }) async {
    throw const SdoAuthException();
  }
}

void main() {
  test('login сохраняет токен и профиль', () async {
    final _FakeDataSource source = _FakeDataSource();
    final InMemorySdoTokenStore store = InMemorySdoTokenStore();
    final SdoRepository repository = SdoRepository(source, store);

    final SdoProfile profile = await repository.login(
      username: 'student',
      password: 'secret',
    );

    expect(profile.userId, 42);
    expect(await store.readToken(), 'token-123');
    expect((await store.readProfile())?.fullName, 'Иванов Иван');
  });

  test('restore возвращает null без токена', () async {
    final SdoRepository repository = SdoRepository(
      _FakeDataSource(),
      InMemorySdoTokenStore(),
    );

    expect(await repository.restore(), isNull);
  });

  test('restore отдаёт сохранённый профиль при наличии токена', () async {
    final SdoRepository repository = SdoRepository(
      _FakeDataSource(),
      InMemorySdoTokenStore('token-123', _profile),
    );

    expect((await repository.restore())?.userId, 42);
  });

  test('fetchCourses передаёт userId из профиля', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final List<SdoCourse> courses = await repository.fetchCourses();

    expect(source.lastCoursesUserId, 42);
    expect(courses.single.fullName, 'Физика');
  });

  test('fetchDeadlines подставляет названия курсов', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final List<SdoDeadline> deadlines = await repository.fetchDeadlines();

    expect(source.lastDeadlineCourseNames, <int, String>{17: 'Физика'});
    expect(deadlines.single.courseName, 'Физика');
  });

  test('fetchCourseGrades и fetchCourseContents принимают courseId', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final SdoCourseGrades grades = await repository.fetchCourseGrades(17);
    final List<SdoSection> sections = await repository.fetchCourseContents(17);

    expect(source.lastGradesCourseId, 17);
    expect(source.lastGradesUserId, 42);
    expect(grades.courseGradeFormatted, '9,00');
    expect(source.lastContentsCourseId, 17);
    expect(sections.single.modules.single.name, 'Конспект');
  });

  test('невалидный токен чистит хранилище', () async {
    final InMemorySdoTokenStore store = InMemorySdoTokenStore(
      'token-123',
      _profile,
    );
    final SdoRepository repository = SdoRepository(
      _AuthFailDataSource(),
      store,
    );

    await expectLater(
      repository.fetchCourses(),
      throwsA(isA<SdoAuthException>()),
    );
    expect(await store.readToken(), isNull);
    expect(await store.readProfile(), isNull);
  });

  test('без токена операции бросают SdoAuthException', () async {
    final SdoRepository repository = SdoRepository(
      _FakeDataSource(),
      InMemorySdoTokenStore(),
    );

    await expectLater(
      repository.fetchCourses(),
      throwsA(isA<SdoAuthException>()),
    );
  });

  test('logout очищает хранилище', () async {
    final InMemorySdoTokenStore store = InMemorySdoTokenStore(
      'token-123',
      _profile,
    );
    final SdoRepository repository = SdoRepository(_FakeDataSource(), store);

    await repository.logout();

    expect(await store.readToken(), isNull);
    expect(await store.readProfile(), isNull);
  });
}
