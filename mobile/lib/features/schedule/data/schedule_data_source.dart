import '../../../core/network/api_exception.dart';
import '../../../core/network/uni_api_client.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/parse.dart';
import '../domain/bells.dart';
import 'schedule_models.dart';

export '../domain/bells.dart' show timeSlots, resolveTimeSlot;

abstract interface class ScheduleDataSource {
  Future<GroupSchedule> fetchSemesterSchedule(int groupId);

  Future<WeekCycleAnchor> fetchWeekAnchor();
}

class UniScheduleDataSource implements ScheduleDataSource {
  UniScheduleDataSource(this._client);

  final UniApiClient _client;

  @override
  Future<GroupSchedule> fetchSemesterSchedule(int groupId) async {
    final payload = await _client.getJson('/schedule/group/$groupId');
    if (payload is! List) {
      throw const ApiException(
        'API вернул неожиданный ответ вместо расписания',
        code: 'bad_response',
      );
    }
    return groupScheduleFromUni(payload, groupId: groupId);
  }

  @override
  Future<WeekCycleAnchor> fetchWeekAnchor() async {
    final payload = await _client.getJson('/schedule/week');
    final anchor = weekCycleAnchorFromUni(payload);
    if (anchor == null) {
      throw const ApiException(
        'API вуза не вернул номер текущей недели',
        code: 'bad_response',
      );
    }
    return anchor;
  }
}

WeekCycleAnchor? weekCycleAnchorFromUni(Object? raw) {
  final json = asMap(raw);
  if (json == null) return null;
  final number = asInt(json['numberOfWeek']);
  final date = parseIsoDate(json['date']);
  if (number == null || number < 1 || date == null) return null;
  return WeekCycleAnchor(date: date, number: number);
}

GroupSchedule groupScheduleFromUni(
  List<Object?> items, {
  required int groupId,
  WeekCycleAnchor? weekAnchor,
}) {
  final lessons = <Lesson>[];
  GroupInfo? group;
  for (final Object? item in items) {
    final json = asMap(item);
    if (json == null) continue;
    group ??= groupInfoFromUni(json['group'], fallbackId: groupId);
    final lesson = lessonFromUni(json);
    if (lesson != null) lessons.add(lesson);
  }

  if (lessons.isEmpty) {
    throw emptyScheduleException;
  }

  return GroupSchedule(
    group: group ?? GroupInfo(id: groupId, name: 'Группа $groupId'),
    semesterStart: semesterStartOf(lessons),
    lessons: lessons,
    weekAnchor: weekAnchor,
  );
}

GroupInfo? groupInfoFromUni(Object? raw, {required int fallbackId}) {
  final json = asMap(raw);
  if (json == null) return null;
  return GroupInfo(
    id: asInt(json['id']) ?? fallbackId,
    name: asString(json['name']) ?? 'Группа $fallbackId',
    facultyName: asString(json['facultyName']),
    course: asInt(json['currentCourse']),
  );
}

Lesson? lessonFromUni(Map<String, dynamic> json) {
  final id = asInt(json['id']);
  final number = asInt(json['lessonNumber']);
  final subject = asString(json['disciplineName']);
  final status = asString(json['status']);
  if (id == null || number == null || subject == null) return null;
  if (status != null && status != 'ACTIVE') return null;

  final dayOfWeek = asInt(json['lessonDay']);
  if (dayOfWeek == null || dayOfWeek < 0 || dayOfWeek >= DateTime.daysPerWeek) {
    return null;
  }
  final dateStart = parseIsoDate(json['startDate']);
  final dateEnd = parseIsoDate(json['endDate']);
  if (dateStart == null || dateEnd == null) return null;

  final (timeStart, timeEnd) = resolveTimeSlot(
    number,
    asInt(json['timeOffset']) ?? 0,
  );

  return Lesson(
    id: id,
    number: number,
    timeStart: timeStart,
    timeEnd: timeEnd,
    type: asString(json['typeClassName']) ?? '',
    typeShort: asString(json['shortTypeClassName']) ?? '',
    subject: subject,
    room: asString(json['location']) ?? '',
    frame: buildingFrameOf(json['frame']),
    weekType: weekTypeOf(asString(json['weekType'])),
    subGroup: asString(json['subGroup']) ?? allSubgroups,
    teacher: teacherFromUni(asMap(json['teacher'])),
    dayOfWeek: dayOfWeek,
    dateStart: dateStart,
    dateEnd: dateEnd,
  );
}

String weekTypeOf(String? value) =>
    value != null && LessonWeekType.known.contains(value)
    ? value
    : LessonWeekType.always;

int? buildingFrameOf(Object? raw) {
  final frame = asInt(raw);
  return frame != null && frame > 0 ? frame : null;
}

Teacher? teacherFromUni(Map<String, dynamic>? json) {
  final fullName = asString(json?['fullName']);
  if (fullName == null) return null;
  return Teacher(
    id: asInt(json?['id']),
    fullName: fullName,
    degree: asString(json?['degree']),
  );
}

DateTime semesterStartOf(List<Lesson> lessons) {
  final dates = lessons.map((lesson) => lesson.dateStart).toList()..sort();
  return mondayOf(dates.first);
}
