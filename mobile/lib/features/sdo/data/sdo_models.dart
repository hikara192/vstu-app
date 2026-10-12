import 'package:freezed_annotation/freezed_annotation.dart';

part 'sdo_models.freezed.dart';

/// Профиль пользователя СДО, полученный из `core_webservice_get_site_info`.
@freezed
abstract class SdoProfile with _$SdoProfile {
  const factory SdoProfile({
    required int userId,
    required String username,
    required String fullName,
    @Default('') String siteName,
    @Default('') String userPictureUrl,
  }) = _SdoProfile;
}

/// Курс, в который зачислен студент (`core_enrol_get_users_courses`).
@freezed
abstract class SdoCourse with _$SdoCourse {
  const factory SdoCourse({
    required int id,
    @Default('') String shortName,
    @Default('') String fullName,
    @Default('') String displayName,
    int? categoryId,
    @Default(true) bool visible,
    DateTime? startDate,
    DateTime? endDate,
  }) = _SdoCourse;
}

extension SdoCoursePresentation on SdoCourse {
  /// Название для списка: `displayName`, иначе `fullName`, иначе `shortName`.
  String get title {
    if (displayName.isNotEmpty) return displayName;
    if (fullName.isNotEmpty) return fullName;
    return shortName;
  }
}

/// Событие календаря с дедлайном (`core_calendar_get_action_events_by_timesort`).
@freezed
abstract class SdoDeadline with _$SdoDeadline {
  const factory SdoDeadline({
    required int id,
    required String name,
    required DateTime timeSort,
    int? courseId,
    @Default('') String courseName,
    @Default('') String moduleName,
    @Default('') String eventType,
    @Default('') String description,
    @Default('') String url,
    @Default(false) bool overdue,
  }) = _SdoDeadline;
}

/// Одна позиция в журнале оценок.
@freezed
abstract class SdoGradeItem with _$SdoGradeItem {
  const factory SdoGradeItem({
    required int id,
    @Default('') String name,
    @Default('') String moduleName,
    @Default('') String itemType,
    @Default('') String gradeFormatted,
    double? gradeRaw,
    double? minGrade,
    double? maxGrade,
    int? courseModuleId,
  }) = _SdoGradeItem;
}

extension SdoGradeItemPresentation on SdoGradeItem {
  bool get hasGrade => gradeFormatted.isNotEmpty && gradeFormatted != '-';
}

/// Оценки по одному курсу (`gradereport_user_get_grade_items`).
@freezed
abstract class SdoCourseGrades with _$SdoCourseGrades {
  const factory SdoCourseGrades({
    required int courseId,
    @Default('') String courseName,
    @Default('') String courseGradeFormatted,
    @Default(<SdoGradeItem>[]) List<SdoGradeItem> items,
  }) = _SdoCourseGrades;
}

extension SdoCourseGradesPresentation on SdoCourseGrades {
  /// Только позиции, по которым реально выставлена оценка.
  List<SdoGradeItem> get gradedItems =>
      items.where((SdoGradeItem item) => item.hasGrade).toList();
}

/// Модуль (элемент) внутри раздела курса (`core_course_get_contents`).
@freezed
abstract class SdoModule with _$SdoModule {
  const factory SdoModule({
    required int id,
    required String name,
    @Default('') String modName,
    @Default('') String url,
    @Default('') String description,
    @Default(true) bool visible,
  }) = _SdoModule;
}

/// Раздел курса с вложенными модулями (`core_course_get_contents`).
@freezed
abstract class SdoSection with _$SdoSection {
  const factory SdoSection({
    required int id,
    @Default('') String name,
    @Default('') String summary,
    @Default(<SdoModule>[]) List<SdoModule> modules,
  }) = _SdoSection;
}
