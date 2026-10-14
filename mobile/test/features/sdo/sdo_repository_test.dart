import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/sdo/data/sdo_exception.dart';
import 'package:vstu_app/features/sdo/data/sdo_data_source.dart';
import 'package:vstu_app/features/sdo/data/sdo_models.dart';
import 'package:vstu_app/features/sdo/data/sdo_repository.dart';
import 'package:vstu_app/features/sdo/data/sdo_token_store.dart';
import 'package:vstu_app/features/sdo/sdo_session_store.dart';

const SdoProfile _profile = SdoProfile(
  userId: 42,
  username: 'student',
  fullName: 'Иванов Иван',
);

/// Источник данных-заглушка: записывает вызовы и отдаёт заданные ответы.
class _FakeDataSource implements SdoDataSource {
  int? lastCoursesUserId;
  int? lastAssignmentsCourseId;
  int? lastAssignmentsUserId;
  int? lastQuizzesCourseId;
  int? lastQuizAttemptsQuizId;
  int? lastQuizAttemptsUserId;
  int? lastSubmissionAssignmentId;
  int? lastDownloadFileCallCount;
  int? lastSaveSubmissionAssignmentId;
  int? lastSaveSubmissionUserId;
  int? lastSubmitForGradingAssignmentId;
  int? lastAutologinUserId;

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
  Future<List<SdoCategory>> fetchCategories(String token) async {
    return <SdoCategory>[
      const SdoCategory(id: 1, name: 'ИТ', courseCount: 5),
    ];
  }

  @override
  Future<List<SdoDeadline>> fetchDeadlines(
    String token, {
    required Map<int, String> courseNames,
  }) async {
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
  Future<List<SdoSection>> fetchCourseContents(
    String token, {
    required int courseId,
  }) async {
    return <SdoSection>[
      const SdoSection(
        id: 1,
        name: 'Раздел',
        modules: <SdoModule>[SdoModule(id: 10, name: 'Конспект')],
      ),
    ];
  }

  @override
  Future<List<SdoAssignment>> fetchAssignments(
    String token, {
    required int courseId,
    required int userId,
  }) async {
    lastAssignmentsCourseId = courseId;
    lastAssignmentsUserId = userId;
    return <SdoAssignment>[
      SdoAssignment(
        id: 100,
        courseId: courseId,
        name: 'Лаб 1',
        description: 'Описание',
        dueDate: DateTime(2026, 10, 20),
        requiresText: true,
        requiresFile: false,
      ),
    ];
  }

  @override
  Future<SdoSubmission> fetchSubmission(
    String token, {
    required int assignmentId,
  }) async {
    lastSubmissionAssignmentId = assignmentId;
    return const SdoSubmission(
      status: SdoSubmissionStatus.submitted,
      onlineText: 'Мой ответ',
    );
  }

  @override
  Future<List<SdoQuiz>> fetchQuizzes(
    String token, {
    required int courseId,
  }) async {
    lastQuizzesCourseId = courseId;
    return <SdoQuiz>[
      SdoQuiz(
        id: 200,
        courseId: courseId,
        name: 'Тест 1',
        courseModuleId: 5,
        timeOpen: DateTime(2026, 10, 1),
        timeClose: DateTime(2026, 11, 1),
        timeLimit: 60,
        maxAttempts: 2,
      ),
    ];
  }

  @override
  Future<List<SdoQuizAttempt>> fetchQuizAttempts(
    String token, {
    required int quizId,
    required int userId,
  }) async {
    lastQuizAttemptsQuizId = quizId;
    lastQuizAttemptsUserId = userId;
    return <SdoQuizAttempt>[
      SdoQuizAttempt(
        id: 1,
        quizId: quizId,
        attempt: 1,
        state: 'finished',
        grade: 8.5,
      ),
    ];
  }

  @override
  Future<List<int>> downloadFile(String url, {required String token}) async {
    lastDownloadFileCallCount = (lastDownloadFileCallCount ?? 0) + 1;
    return <int>[1, 2, 3];
  }

  @override
  Future<void> saveSubmission(
    String token, {
    required int assignmentId,
    required int userId,
    String? onlineText,
    String? fileName,
    List<int>? fileBytes,
  }) async {
    lastSaveSubmissionAssignmentId = assignmentId;
    lastSaveSubmissionUserId = userId;
  }

  @override
  Future<void> submitForGrading(
    String token, {
    required int assignmentId,
  }) async {
    lastSubmitForGradingAssignmentId = assignmentId;
  }

  @override
  Future<String?> autologinUrl(String token, {required int userId}) async {
    lastAutologinUserId = userId;
    return 'https://sdo.vstu.by/autologin?key=xxx&userid=$userId';
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

  test('fetchCategories вызывает источник', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final List<SdoCategory> categories = await repository.fetchCategories();
    expect(categories.single.name, 'ИТ');
  });

  test('fetchDeadlines подставляет названия курсов', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final List<SdoDeadline> deadlines = await repository.fetchDeadlines();
    expect(deadlines.single.courseName, 'Физика');
  });

  test('fetchCourseContents принимает courseId', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final List<SdoSection> sections = await repository.fetchCourseContents(17);
    expect(sections.single.modules.single.name, 'Конспект');
  });

  test('fetchAssignments передаёт courseId и userId', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final List<SdoAssignment> assignments = await repository.fetchAssignments(17);
    expect(source.lastAssignmentsCourseId, 17);
    expect(source.lastAssignmentsUserId, 42);
    expect(assignments.single.name, 'Лаб 1');
  });

  test('fetchSubmission передаёт assignmentId', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final SdoSubmission submission = await repository.fetchSubmission(100);
    expect(source.lastSubmissionAssignmentId, 100);
    expect(submission.onlineText, 'Мой ответ');
  });

  test('fetchQuizzes передаёт courseId', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final List<SdoQuiz> quizzes = await repository.fetchQuizzes(17);
    expect(source.lastQuizzesCourseId, 17);
    expect(quizzes.single.name, 'Тест 1');
  });

  test('fetchQuizAttempts передаёт quizId и userId', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final List<SdoQuizAttempt> attempts = await repository.fetchQuizAttempts(200);
    expect(source.lastQuizAttemptsQuizId, 200);
    expect(source.lastQuizAttemptsUserId, 42);
    expect(attempts.single.grade, 8.5);
  });

  test('downloadFile вызывает источник с токеном', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final List<int> bytes = await repository.downloadFile('https://sdo.vstu.by/file.pdf');
    expect(source.lastDownloadFileCallCount, 1);
    expect(bytes, <int>[1, 2, 3]);
  });

  test('saveSubmission передаёт параметры', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    await repository.saveSubmission(
      assignmentId: 100,
      onlineText: 'Ответ',
      fileName: 'file.pdf',
      fileBytes: <int>[1, 2, 3],
    );
    expect(source.lastSaveSubmissionAssignmentId, 100);
    expect(source.lastSaveSubmissionUserId, 42);
  });

  test('submitForGrading сохраняет работу и отправляет её на проверку', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    await repository.submitForGrading(
      assignmentId: 100,
      onlineText: 'Ответ',
      fileName: null,
      fileBytes: null,
    );

    expect(source.lastSaveSubmissionAssignmentId, 100);
    expect(source.lastSaveSubmissionUserId, 42);
    expect(source.lastSubmitForGradingAssignmentId, 100);
  });

  test('autologinUrl передаёт userId', () async {
    final _FakeDataSource source = _FakeDataSource();
    final SdoRepository repository = SdoRepository(
      source,
      InMemorySdoTokenStore('token-123', _profile),
    );

    final String? url = await repository.autologinUrl();
    expect(source.lastAutologinUserId, 42);
    expect(url, contains('userid=42'));
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

  test('logout очищает токен и веб-сессию', () async {
    final InMemorySdoTokenStore store = InMemorySdoTokenStore(
      'token-123',
      _profile,
    );
    final InMemorySdoSessionStore sessionStore = InMemorySdoSessionStore(
      const <SdoSessionCookie>[
        SdoSessionCookie(name: 'MoodleSession', value: 'abcdef123456'),
      ],
    );
    final SdoRepository repository = SdoRepository(
      _FakeDataSource(),
      store,
      sessionStore: sessionStore,
    );

    await repository.logout();

    expect(await store.readToken(), isNull);
    expect(await sessionStore.load(), isEmpty);
  });

  test('ошибка авторизации очищает токен и веб-сессию', () async {
    final InMemorySdoTokenStore store = InMemorySdoTokenStore(
      'token-123',
      _profile,
    );
    final InMemorySdoSessionStore sessionStore = InMemorySdoSessionStore(
      const <SdoSessionCookie>[
        SdoSessionCookie(name: 'MoodleSession', value: 'abcdef123456'),
      ],
    );
    final SdoRepository repository = SdoRepository(
      _AuthFailDataSource(),
      store,
      sessionStore: sessionStore,
    );

    await expectLater(
      repository.fetchCourses(),
      throwsA(isA<SdoAuthException>()),
    );

    expect(await store.readToken(), isNull);
    expect(await sessionStore.load(), isEmpty);
  });
}