import 'dart:convert';

import '../../../core/utils/parse.dart';
import 'sdo_api_client.dart';
import 'sdo_exception.dart';
import 'sdo_models.dart';

/// Доступ к данным СДО. Абстракция нужна, чтобы экраны не зависели от
/// конкретного Moodle и подменялись в тестах.
abstract interface class SdoDataSource {
  Future<String> requestToken({
    required String username,
    required String password,
  });

  Future<SdoProfile> fetchProfile(String token);

  Future<List<SdoCourse>> fetchCourses(String token, {required int userId});

  Future<List<SdoCategory>> fetchCategories(String token);

  Future<List<SdoDeadline>> fetchDeadlines(
    String token, {
    required Map<int, String> courseNames,
  });

  Future<List<SdoSection>> fetchCourseContents(
    String token, {
    required int courseId,
  });

  Future<List<SdoAssignment>> fetchAssignments(
    String token, {
    required int courseId,
    required int userId,
  });

  Future<SdoSubmission> fetchSubmission(
    String token, {
    required int assignmentId,
  });

  Future<List<SdoQuiz>> fetchQuizzes(
    String token, {
    required int courseId,
  });

  Future<List<SdoQuizAttempt>> fetchQuizAttempts(
    String token, {
    required int quizId,
    required int userId,
  });

  /// Скачивает файл курса (вложение Moodle) как байты.
  Future<List<int>> downloadFile(String url, {required String token});

  /// Сохраняет отправку задания: текст и/или файл.
  Future<void> saveSubmission(
    String token, {
    required int assignmentId,
    required int userId,
    String? onlineText,
    String? fileName,
    List<int>? fileBytes,
  });

  /// Отправляет ранее сохранённую работу на проверку
  /// (`mod_assign_submit_for_grading`). Без этого вызова задание остаётся
  /// черновиком и преподаватель его не видит.
  Future<void> submitForGrading(String token, {required int assignmentId});

  /// Возвращает ссылку автологина в веб-сессию Moodle, чтобы открывать
  /// интерактивные элементы (тесты, форумы) без повторного ввода пароля.
  Future<String?> autologinUrl(String token, {required int userId});
}

class MoodleSdoDataSource implements SdoDataSource {
  MoodleSdoDataSource(this._client);

  final SdoApiClient _client;

  @override
  Future<String> requestToken({
    required String username,
    required String password,
  }) {
    return _client.requestToken(username: username, password: password);
  }

  @override
  Future<SdoProfile> fetchProfile(String token) async {
    final Map<String, dynamic> json = await _client.call(
      'core_webservice_get_site_info',
      token: token,
    );
    return sdoProfileFromMoodle(json);
  }

  @override
  Future<List<SdoCourse>> fetchCourses(
    String token, {
    required int userId,
  }) async {
    final Map<String, dynamic> json = await _client.call(
      'core_enrol_get_users_courses',
      token: token,
      params: <String, Object?>{'userid': userId},
    );
    return _listOf(json['items'], sdoCourseFromMoodle);
  }

  @override
  Future<List<SdoCategory>> fetchCategories(String token) async {
    final Map<String, dynamic> json = await _client.call(
      'core_course_get_categories',
      token: token,
    );
    return _listOf(json['items'], sdoCategoryFromMoodle);
  }

  @override
  Future<List<SdoDeadline>> fetchDeadlines(
    String token, {
    required Map<int, String> courseNames,
  }) async {
    final Map<String, dynamic> json = await _client.call(
      'core_calendar_get_action_events_by_timesort',
      token: token,
      params: <String, Object?>{
        'timesortfrom': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'limitnum': 50,
      },
    );
    final Object? raw = json['events'];
    if (raw is! List) {
      throw const SdoException('СДО вернула неожиданный список дедлайнов.');
    }
    final List<SdoDeadline> deadlines = <SdoDeadline>[];
    for (final Object? item in raw) {
      final Map<String, dynamic>? event = asMap(item);
      if (event == null) continue;
      final SdoDeadline? deadline = sdoDeadlineFromMoodle(
        event,
        courseNames: courseNames,
      );
      if (deadline != null) deadlines.add(deadline);
    }
    return deadlines;
  }

  @override
  Future<List<SdoSection>> fetchCourseContents(
    String token, {
    required int courseId,
  }) async {
    final Map<String, dynamic> json = await _client.call(
      'core_course_get_contents',
      token: token,
      params: <String, Object?>{'courseid': courseId},
    );
    return sdoSectionsFromMoodle(json['items']);
  }

  @override
  Future<List<SdoAssignment>> fetchAssignments(
    String token, {
    required int courseId,
    required int userId,
  }) async {
    final Map<String, dynamic> json = await _client.call(
      'mod_assign_get_assignments',
      token: token,
      params: <String, Object?>{'courseids[0]': courseId},
    );

    final List<SdoAssignment> assignments = <SdoAssignment>[];
    final Object? courses = json['courses'];
    if (courses is List) {
      for (final Object? courseEntry in courses) {
        final Map<String, dynamic>? course = asMap(courseEntry);
        final Object? raw = course?['assignments'];
        if (raw is! List) continue;
        for (final Object? entry in raw) {
          final Map<String, dynamic>? data = asMap(entry);
          if (data == null) continue;
          assignments.add(sdoAssignmentFromMoodle(data, courseId: courseId));
        }
      }
    }

    if (assignments.isEmpty) return assignments;

    final Map<int, SdoSubmissionStatus> statuses = await _fetchSubmissionStatuses(
      token,
      assignmentIds: assignments
          .map((SdoAssignment assignment) => assignment.id)
          .toList(),
    );

    return <SdoAssignment>[
      for (final SdoAssignment assignment in assignments)
        assignment.copyWith(
          status: statuses[assignment.id] ?? assignment.status,
        ),
    ];
  }

  /// Статусы отправок по всем заданиям курса. Один запрос; если сервер
  /// запрещает его для студента — просто считаем, что ничего не отправлено.
  Future<Map<int, SdoSubmissionStatus>> _fetchSubmissionStatuses(
    String token, {
    required List<int> assignmentIds,
  }) async {
    if (assignmentIds.isEmpty) return const <int, SdoSubmissionStatus>{};
    try {
      final Map<String, Object?> params = <String, Object?>{
        for (int i = 0; i < assignmentIds.length; i++)
          'assignmentids[$i]': assignmentIds[i],
      };
      final Map<String, dynamic> json = await _client.call(
        'mod_assign_get_submissions',
        token: token,
        params: params,
      );
      final Map<int, SdoSubmissionStatus> result =
          <int, SdoSubmissionStatus>{};
      final Object? raw = json['assignments'];
      if (raw is List) {
        for (final Object? entry in raw) {
          final Map<String, dynamic>? item = asMap(entry);
          final int? assignmentId = asInt(item?['assignmentid']);
          final Object? submissions = item?['submissions'];
          if (assignmentId == null || submissions is! List) continue;
          for (final Object? sub in submissions) {
            final String? status = asString(asMap(sub)?['status']);
            result[assignmentId] = _statusFromMoodle(status);
            break;
          }
        }
      }
      return result;
    } on SdoAuthException {
      rethrow;
    } on SdoException {
      return const <int, SdoSubmissionStatus>{};
    }
  }

  @override
  Future<SdoSubmission> fetchSubmission(
    String token, {
    required int assignmentId,
  }) async {
    final Map<String, dynamic> json = await _client.call(
      'mod_assign_get_submission_status',
      token: token,
      params: <String, Object?>{'assignid': assignmentId},
    );
    return sdoSubmissionFromStatus(json);
  }

  @override
  Future<List<SdoQuiz>> fetchQuizzes(
    String token, {
    required int courseId,
  }) async {
    final Map<String, dynamic> json = await _client.call(
      'mod_quiz_get_quizzes_by_courses',
      token: token,
      params: <String, Object?>{'courseids[0]': courseId},
    );
    return _listOf(json['quizzes'], sdoQuizFromMoodle);
  }

  @override
  Future<List<SdoQuizAttempt>> fetchQuizAttempts(
    String token, {
    required int quizId,
    required int userId,
  }) async {
    final Map<String, dynamic> json = await _client.call(
      'mod_quiz_get_user_attempts',
      token: token,
      params: <String, Object?>{'quizid': quizId, 'userid': userId},
    );
    return _listOf(json['attempts'], sdoQuizAttemptFromMoodle);
  }

  @override
  Future<List<int>> downloadFile(String url, {required String token}) {
    return _client.downloadFile(url, token: token);
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
    final Map<String, Object?> params = <String, Object?>{
      'assignmentid': assignmentId,
    };

    if (onlineText != null) {
      params['plugindata[onlinetext_editor][text]'] = onlineText;
      params['plugindata[onlinetext_editor][format]'] = 1;
    }

    if (fileName != null && fileBytes != null) {
      final int draftId = await _uploadDraft(
        token,
        userId: userId,
        fileName: fileName,
        bytes: fileBytes,
      );
      params['plugindata[files_filemanager]'] = draftId;
    }

    await _client.call(
      'mod_assign_save_submission',
      token: token,
      params: params,
    );
  }

  @override
  Future<void> submitForGrading(
    String token, {
    required int assignmentId,
  }) async {
    await _client.call(
      'mod_assign_submit_for_grading',
      token: token,
      params: <String, Object?>{
        'assignmentid': assignmentId,
        // Обязательное подтверждение от имени студента требуется настройкой
        // задания; без него Moodle отклоняет отправку.
        'acceptsubmissionstatement': 1,
      },
    );
  }

  /// Загружает файл в черновую область пользователя Moodle и возвращает
  /// `itemid`, который затем передаётся в `mod_assign_save_submission`.
  Future<int> _uploadDraft(
    String token, {
    required int userId,
    required String fileName,
    required List<int> bytes,
  }) async {
    final Map<String, dynamic> json = await _client.call(
      'core_files_upload',
      token: token,
      params: <String, Object?>{
        'itemid': 0,
        'component': 'user',
        'filearea': 'draft',
        'filepath': '/',
        'filename': fileName,
        'filecontent': base64Encode(bytes),
        'contextlevel': 'user',
        'instanceid': userId,
      },
    );
    final int? itemId = asInt(json['itemid']);
    if (itemId == null) {
      throw const SdoException('Не удалось загрузить файл в СДО.');
    }
    return itemId;
  }

  @override
  Future<String?> autologinUrl(String token, {required int userId}) async {
    try {
      final Map<String, dynamic> json = await _client.call(
        'tool_mobile_get_autologin_key',
        token: token,
      );
      final String? key = asString(json['key']);
      final String? url = asString(json['autologinurl']);
      if (key == null || url == null) return null;
      final Uri base = Uri.parse(url);
      return base
          .replace(
            queryParameters: <String, String>{
              ...base.queryParameters,
              'key': key,
              'userid': userId.toString(),
            },
          )
          .toString();
    } on SdoException {
      // Автологин — необязательный бонус: если он недоступен, WebView просто
      // покажет страницу входа.
      return null;
    }
  }

  List<T> _listOf<T>(Object? raw, T Function(Map<String, dynamic>) parse) {
    if (raw is! List) {
      throw const SdoException('СДО вернула неожиданный ответ.');
    }
    return <T>[
      for (final Object? item in raw)
        if (asMap(item) case final Map<String, dynamic> map) parse(map),
    ];
  }
}

// --- Разбор ответов Moodle -------------------------------------------------

/// Unix-время в секундах → [DateTime] (локальное время).
DateTime? sdoDateFromUnix(Object? value) {
  final int? seconds = asInt(value);
  if (seconds == null || seconds <= 0) return null;
  return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
}

double? _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

bool _asBool(Object? value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final String? text = asString(value);
  if (text == null) return fallback;
  return text == '1' || text.toLowerCase() == 'true';
}

SdoSubmissionStatus _statusFromMoodle(String? status) {
  return switch (status) {
    'submitted' => SdoSubmissionStatus.submitted,
    'draft' => SdoSubmissionStatus.draft,
    _ => SdoSubmissionStatus.newSubmission,
  };
}

SdoProfile sdoProfileFromMoodle(Map<String, dynamic> json) {
  return SdoProfile(
    userId: asInt(json['userid']) ?? 0,
    username: asString(json['username']) ?? '',
    fullName: asString(json['fullname']) ?? '',
    siteName: asString(json['sitename']) ?? '',
    userPictureUrl: asString(json['userpictureurl']) ?? '',
  );
}

SdoCategory sdoCategoryFromMoodle(Map<String, dynamic> json) {
  return SdoCategory(
    id: asInt(json['id']) ?? 0,
    name: asString(json['name']) ?? '',
    parent: asInt(json['parent']),
    courseCount: asInt(json['coursecount']) ?? 0,
    idNumber: asString(json['idnumber']) ?? '',
  );
}

SdoCourse sdoCourseFromMoodle(Map<String, dynamic> json) {
  return SdoCourse(
    id: asInt(json['id']) ?? 0,
    shortName: asString(json['shortname']) ?? '',
    fullName: asString(json['fullname']) ?? '',
    displayName: asString(json['displayname']) ?? '',
    categoryId: asInt(json['categoryid']) ?? asInt(json['category']),
    visible: _asBool(json['visible'], fallback: true),
    startDate: sdoDateFromUnix(json['startdate']),
    endDate: sdoDateFromUnix(json['enddate']),
  );
}

SdoDeadline? sdoDeadlineFromMoodle(
  Map<String, dynamic> json, {
  Map<int, String> courseNames = const <int, String>{},
}) {
  final int? id = asInt(json['id']);
  final String? name = asString(json['name']);
  final DateTime? timeSort =
      sdoDateFromUnix(json['timesort']) ?? sdoDateFromUnix(json['timestart']);
  if (id == null || name == null || timeSort == null) return null;

  final int? courseId = asInt(json['courseid']);
  return SdoDeadline(
    id: id,
    name: name,
    timeSort: timeSort,
    courseId: courseId,
    courseName: courseId == null ? '' : courseNames[courseId] ?? '',
    moduleName: asString(json['modulename']) ?? '',
    eventType: asString(json['eventtype']) ?? '',
    description: stripHtml(asString(json['description'])),
    url: asString(json['url']) ?? '',
    overdue: _asBool(json['overdue']),
  );
}

SdoFile sdoFileFromMoodle(Map<String, dynamic> json) {
  return SdoFile(
    type: asString(json['type']) ?? 'file',
    fileName: asString(json['filename']) ?? '',
    fileUrl: asString(json['fileurl']) ?? '',
    mimeType: asString(json['mimetype']) ?? '',
    fileSize: asInt(json['filesize']) ?? 0,
    timeModified: sdoDateFromUnix(json['timemodified']),
  );
}

List<SdoSection> sdoSectionsFromMoodle(Object? raw) {
  if (raw is! List) return const <SdoSection>[];
  return <SdoSection>[
    for (final Object? entry in raw)
      if (asMap(entry) case final Map<String, dynamic> section)
        _sectionFromMoodle(section),
  ];
}

SdoSection _sectionFromMoodle(Map<String, dynamic> json) {
  final Object? rawModules = json['modules'];
  return SdoSection(
    id: asInt(json['id']) ?? 0,
    name: asString(json['name']) ?? '',
    summary: stripHtml(asString(json['summary'])),
    modules: <SdoModule>[
      if (rawModules is List)
        for (final Object? entry in rawModules)
          if (asMap(entry) case final Map<String, dynamic> module)
            _moduleFromMoodle(module),
    ],
  );
}

SdoModule _moduleFromMoodle(Map<String, dynamic> json) {
  final Object? rawContents = json['contents'];
  return SdoModule(
    id: asInt(json['id']) ?? 0,
    name: asString(json['name']) ?? '',
    modName: asString(json['modname']) ?? '',
    instance: asInt(json['instance']) ?? 0,
    url: asString(json['url']) ?? '',
    description: stripHtml(asString(json['description'])),
    visible:
        _asBool(json['visible'], fallback: true) &&
        _asBool(json['uservisible'], fallback: true),
    contents: <SdoFile>[
      if (rawContents is List)
        for (final Object? entry in rawContents)
          if (asMap(entry) case final Map<String, dynamic> content)
            sdoFileFromMoodle(content),
    ],
  );
}

SdoAssignment sdoAssignmentFromMoodle(
  Map<String, dynamic> json, {
  required int courseId,
}) {
  final List<Map<String, dynamic>> configs = <Map<String, dynamic>>[
    for (final Object? entry in (json['configs'] as List? ?? const <Object>[]))
      if (asMap(entry) case final Map<String, dynamic> config) config,
  ];

  bool pluginEnabled(String plugin) {
    final Iterable<Map<String, dynamic>> matches = configs.where(
      (Map<String, dynamic> config) => config['plugin'] == plugin,
    );
    if (matches.isEmpty) return true;
    return matches.any(
      (Map<String, dynamic> config) =>
          config['name'] == 'enabled' && _asBool(config['value']),
    );
  }

  return SdoAssignment(
    id: asInt(json['id']) ?? 0,
    courseId: asInt(json['course']) ?? courseId,
    name: asString(json['name']) ?? '',
    courseModuleId: asInt(json['cmid']) ?? 0,
    description: stripHtml(asString(json['intro'])),
    dueDate: sdoDateFromUnix(json['duedate']),
    allowFromDate: sdoDateFromUnix(json['allowsubmissionsfromdate']),
    cutoffDate: sdoDateFromUnix(json['cutoffdate']),
    maxAttempts: asInt(json['maxattempts']) ?? 0,
    requiresText: pluginEnabled('onlinetext'),
    requiresFile: pluginEnabled('file'),
    status: _statusFromMoodle(asString(json['status'])),
  );
}

SdoSubmission sdoSubmissionFromStatus(Map<String, dynamic> json) {
  final Map<String, dynamic>? lastAttempt = asMap(json['lastattempt']);
  final Map<String, dynamic>? submission = asMap(lastAttempt?['submission']);
  if (submission == null) {
    return const SdoSubmission(status: SdoSubmissionStatus.newSubmission);
  }

  final SdoSubmissionStatus status = _statusFromMoodle(
    asString(submission['status']),
  );
  String onlineText = '';
  final List<SdoFile> files = <SdoFile>[];

  final Object? plugins = submission['plugins'];
  if (plugins is List) {
    for (final Object? entry in plugins) {
      final Map<String, dynamic>? plugin = asMap(entry);
      if (plugin == null) continue;
      final Object? editorFields = plugin['editorfields'];
      if (editorFields is List) {
        for (final Object? fieldEntry in editorFields) {
          final Map<String, dynamic>? field = asMap(fieldEntry);
          if (field != null && field['name'] == 'text') {
            onlineText = stripHtml(asString(field['value']));
          }
        }
      }
      final Object? fileAreas = plugin['fileareas'];
      if (fileAreas is List) {
        for (final Object? areaEntry in fileAreas) {
          final Map<String, dynamic>? area = asMap(areaEntry);
          final Object? areaFiles = area?['files'];
          if (areaFiles is List) {
            for (final Object? fileEntry in areaFiles) {
              final Map<String, dynamic>? file = asMap(fileEntry);
              if (file != null) {
                files.add(
                  sdoFileFromMoodle(<String, dynamic>{
                    'type': 'file',
                    ...file,
                  }),
                );
              }
            }
          }
        }
      }
    }
  }

  return SdoSubmission(
    status: status,
    onlineText: onlineText,
    files: files,
    updatedAt: sdoDateFromUnix(submission['timemodified']),
  );
}

SdoQuiz sdoQuizFromMoodle(Map<String, dynamic> json) {
  return SdoQuiz(
    id: asInt(json['id']) ?? 0,
    courseId: asInt(json['course']) ?? 0,
    name: asString(json['name']) ?? '',
    courseModuleId: asInt(json['coursemodule']) ?? asInt(json['cmid']) ?? 0,
    intro: stripHtml(asString(json['intro'])),
    timeOpen: sdoDateFromUnix(json['timeopen']),
    timeClose: sdoDateFromUnix(json['timeclose']),
    timeLimit: asInt(json['timelimit']) ?? 0,
    maxAttempts: asInt(json['attempts']) ?? 0,
    gradeMethod: asInt(json['grademethod']) ?? 0,
    hasQuestions: _asBool(json['hasquestions'], fallback: true),
  );
}

SdoQuizAttempt sdoQuizAttemptFromMoodle(Map<String, dynamic> json) {
  return SdoQuizAttempt(
    id: asInt(json['id']) ?? 0,
    quizId: asInt(json['quiz']) ?? 0,
    attempt: asInt(json['attempt']) ?? 1,
    state: asString(json['state']) ?? '',
    timeStart: sdoDateFromUnix(json['timestart']),
    timeFinish: sdoDateFromUnix(json['timefinish']),
    grade: _asDouble(json['sumgrades']),
  );
}

/// Грубо убирает HTML-теги и лишние пробелы из описаний Moodle.
String stripHtml(String? html) {
  if (html == null || html.isEmpty) return '';
  final String noTags = html
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');
  return noTags.replaceAll(RegExp(r'\s+'), ' ').trim();
}
