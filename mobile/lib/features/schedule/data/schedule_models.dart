import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_models.freezed.dart';
part 'schedule_models.g.dart';

abstract final class LessonWeekType {
  static const String always = 'Всегда';

  static const String numerator = 'Числитель';

  static const String denominator = 'Знаменатель';

  static const Set<String> known = <String>{always, numerator, denominator};
}

const String allSubgroups = 'Все';

@freezed
abstract class Teacher with _$Teacher {
  const factory Teacher({int? id, required String fullName, String? degree}) =
      _Teacher;

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);
}

@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    required int id,
    required int number,
    required String timeStart,
    required String timeEnd,
    required String type,
    required String typeShort,
    required String subject,
    Teacher? teacher,

    @Default('') String room,

    int? frame,

    @Default('Всегда') String weekType,
    @Default('Все') String subGroup,
    required int dayOfWeek,
    required DateTime dateStart,
    required DateTime dateEnd,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}

@freezed
abstract class GroupInfo with _$GroupInfo {
  const factory GroupInfo({
    required int id,
    required String name,
    String? facultyName,
    int? course,
  }) = _GroupInfo;

  factory GroupInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoFromJson(json);
}

@freezed
abstract class WeekCycleAnchor with _$WeekCycleAnchor {
  const factory WeekCycleAnchor({required DateTime date, required int number}) =
      _WeekCycleAnchor;

  factory WeekCycleAnchor.fromJson(Map<String, dynamic> json) =>
      _$WeekCycleAnchorFromJson(json);
}

@freezed
abstract class GroupSchedule with _$GroupSchedule {
  const factory GroupSchedule({
    required GroupInfo group,
    required DateTime semesterStart,
    @Default(<Lesson>[]) List<Lesson> lessons,

    WeekCycleAnchor? weekAnchor,
  }) = _GroupSchedule;

  factory GroupSchedule.fromJson(Map<String, dynamic> json) =>
      _$GroupScheduleFromJson(json);
}
