part of 'schedule_models.dart';

_Teacher _$TeacherFromJson(Map<String, dynamic> json) => _Teacher(
  id: (json['id'] as num?)?.toInt(),
  fullName: json['full_name'] as String,
  degree: json['degree'] as String?,
);

Map<String, dynamic> _$TeacherToJson(_Teacher instance) => <String, dynamic>{
  'id': ?instance.id,
  'full_name': instance.fullName,
  'degree': ?instance.degree,
};

_Lesson _$LessonFromJson(Map<String, dynamic> json) => _Lesson(
  id: (json['id'] as num).toInt(),
  number: (json['number'] as num).toInt(),
  timeStart: json['time_start'] as String,
  timeEnd: json['time_end'] as String,
  type: json['type'] as String,
  typeShort: json['type_short'] as String,
  subject: json['subject'] as String,
  teacher: json['teacher'] == null
      ? null
      : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
  room: json['room'] as String? ?? '',
  frame: (json['frame'] as num?)?.toInt(),
  weekType: json['week_type'] as String? ?? 'Всегда',
  subGroup: json['sub_group'] as String? ?? 'Все',
  dayOfWeek: (json['day_of_week'] as num).toInt(),
  dateStart: DateTime.parse(json['date_start'] as String),
  dateEnd: DateTime.parse(json['date_end'] as String),
);

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'time_start': instance.timeStart,
  'time_end': instance.timeEnd,
  'type': instance.type,
  'type_short': instance.typeShort,
  'subject': instance.subject,
  'teacher': ?instance.teacher?.toJson(),
  'room': instance.room,
  'frame': ?instance.frame,
  'week_type': instance.weekType,
  'sub_group': instance.subGroup,
  'day_of_week': instance.dayOfWeek,
  'date_start': instance.dateStart.toIso8601String(),
  'date_end': instance.dateEnd.toIso8601String(),
};

_GroupInfo _$GroupInfoFromJson(Map<String, dynamic> json) => _GroupInfo(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  facultyName: json['faculty_name'] as String?,
  course: (json['course'] as num?)?.toInt(),
);

Map<String, dynamic> _$GroupInfoToJson(_GroupInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'faculty_name': ?instance.facultyName,
      'course': ?instance.course,
    };

_WeekCycleAnchor _$WeekCycleAnchorFromJson(Map<String, dynamic> json) =>
    _WeekCycleAnchor(
      date: DateTime.parse(json['date'] as String),
      number: (json['number'] as num).toInt(),
    );

Map<String, dynamic> _$WeekCycleAnchorToJson(_WeekCycleAnchor instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'number': instance.number,
    };

_GroupSchedule _$GroupScheduleFromJson(Map<String, dynamic> json) =>
    _GroupSchedule(
      group: GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
      semesterStart: DateTime.parse(json['semester_start'] as String),
      lessons:
          (json['lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Lesson>[],
      weekAnchor: json['week_anchor'] == null
          ? null
          : WeekCycleAnchor.fromJson(
              json['week_anchor'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$GroupScheduleToJson(_GroupSchedule instance) =>
    <String, dynamic>{
      'group': instance.group.toJson(),
      'semester_start': instance.semesterStart.toIso8601String(),
      'lessons': instance.lessons.map((e) => e.toJson()).toList(),
      'week_anchor': ?instance.weekAnchor?.toJson(),
    };
