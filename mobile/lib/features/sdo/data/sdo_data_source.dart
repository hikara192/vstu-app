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

  Future<List<SdoDeadline>> fetchDeadlines(
    String token, {
    required Map<int, String> courseNames,
  });

  Future<SdoCourseGrades> fetchCourseGrades(
    String token, {
    required int courseId,
    required int userId,
  });

  Future<List<SdoSection>> fetchCourseContents(
    String token, {
    required int courseId,
  });
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
    final json = await _client.call('core_webservice_get_site_info', token: token);
    return sdoProfileFromMoodle(json);
  }

  @override
  Future<List<SdoCourse>> fetchCourses(
    String token, {
    required int userId,
  }) async {
    final json = await _client.call(
      'core_enrol_get_users_courses',
      token: token,
      params: <String, Object?>{'userid': userId},
    );
    final Object? raw = json['items'];
    if (raw is! List) {
      throw const SdoException('СДО вернула неожиданный список курсов.');
    }
    return <SdoCourse>[
      for (final Object? item in raw)
        if (asMap(item) case final Map<String, dynamic> course)
          sdoCourseFromMoodle(course),
    ];
  }

  @override
  Future<List<SdoDeadline>> fetchDeadlines(
    String token, {
    required Map<int, String> courseNames,
  }) async {
    final json = await _client.call(
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
  Future<SdoCourseGrades> fetchCourseGrades(
    String token, {
    required int courseId,
    required int userId,
  }) async {
    final json = await _client.call(
      'gradereport_user_get_grade_items',
      token: token,
      params: <String, Object?>{'courseid': courseId, 'userid': userId},
    );
    return sdoCourseGradesFromMoodle(json, fallbackCourseId: courseId);
  }

  @override
  Future<List<SdoSection>> fetchCourseContents(
    String token, {
    required int courseId,
  }) async {
    final json = await _client.call(
      'core_course_get_contents',
      token: token,
      params: <String, Object?>{'courseid': courseId},
    );
    return sdoSectionsFromMoodle(json['items']);
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

SdoProfile sdoProfileFromMoodle(Map<String, dynamic> json) {
  return SdoProfile(
    userId: asInt(json['userid']) ?? 0,
    username: asString(json['username']) ?? '',
    fullName: asString(json['fullname']) ?? '',
    siteName: asString(json['sitename']) ?? '',
    userPictureUrl: asString(json['userpictureurl']) ?? '',
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

SdoGradeItem sdoGradeItemFromMoodle(Map<String, dynamic> json) {
  return SdoGradeItem(
    id: asInt(json['id']) ?? 0,
    name: asString(json['itemname']) ?? '',
    moduleName: asString(json['itemmodule']) ?? '',
    itemType: asString(json['itemtype']) ?? '',
    gradeFormatted: asString(json['gradeformatted']) ?? '',
    gradeRaw: _asDouble(json['graderaw']),
    minGrade: _asDouble(json['grademin']),
    maxGrade: _asDouble(json['grademax']),
    courseModuleId: asInt(json['cmid']),
  );
}

SdoCourseGrades sdoCourseGradesFromMoodle(
  Map<String, dynamic> json, {
  int? fallbackCourseId,
}) {
  final Object? raw = json['usergrades'];
  final Map<String, dynamic>? usergrade = raw is List && raw.isNotEmpty
      ? asMap(raw.first)
      : null;
  if (usergrade == null) {
    return SdoCourseGrades(courseId: fallbackCourseId ?? 0);
  }

  final int courseId = asInt(usergrade['courseid']) ?? fallbackCourseId ?? 0;
  final List<SdoGradeItem> items = <SdoGradeItem>[];
  String courseGrade = '';

  final Object? rawItems = usergrade['gradeitems'];
  if (rawItems is List) {
    for (final Object? entry in rawItems) {
      final Map<String, dynamic>? item = asMap(entry);
      if (item == null) continue;
      final SdoGradeItem parsed = sdoGradeItemFromMoodle(item);
      if (parsed.itemType == 'course') {
        if (courseGrade.isEmpty && parsed.hasGrade) {
          courseGrade = parsed.gradeFormatted;
        }
        continue;
      }
      items.add(parsed);
    }
  }

  return SdoCourseGrades(
    courseId: courseId,
    courseGradeFormatted: courseGrade,
    items: items,
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
  return SdoModule(
    id: asInt(json['id']) ?? 0,
    name: asString(json['name']) ?? '',
    modName: asString(json['modname']) ?? '',
    url: asString(json['url']) ?? '',
    description: stripHtml(asString(json['description'])),
    visible:
        _asBool(json['visible'], fallback: true) &&
        _asBool(json['uservisible'], fallback: true),
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
