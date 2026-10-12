import 'package:vstu_app/features/schedule/data/schedule_models.dart';

/// Собирает [Lesson] с предсказуемыми умолчаниями для тестов:
/// пара №1, Пн, 8:00–9:35, ауд. 305 во 2 корпусе, весь семестр.
///
/// Учебные данные намеренно нейтральные и несуществующие, чтобы тестовые
/// наборы было безопасно показывать где угодно.
Lesson buildLesson({
  int id = 1,
  int number = 1,
  String timeStart = '8:00',
  String timeEnd = '9:35',
  String type = 'Лекция',
  String typeShort = 'лк',
  String subject = 'Математика',
  Teacher? teacher,
  String room = '305',
  int? frame = 2,
  String weekType = LessonWeekType.always,
  String subGroup = allSubgroups,
  int dayOfWeek = 0,
  DateTime? dateStart,
  DateTime? dateEnd,
}) =>
    Lesson(
      id: id,
      number: number,
      timeStart: timeStart,
      timeEnd: timeEnd,
      type: type,
      typeShort: typeShort,
      subject: subject,
      teacher: teacher,
      room: room,
      frame: frame,
      weekType: weekType,
      subGroup: subGroup,
      dayOfWeek: dayOfWeek,
      dateStart: dateStart ?? DateTime(2025, 2, 3),
      dateEnd: dateEnd ?? DateTime(2025, 5, 31),
    );

const Map<String, Object?> teacherJson = <String, Object?>{
  'id': 10,
  'fullName': 'Тестовый Преподаватель',
  'degree': 'к.т.н.',
};

const Map<String, Object?> groupJson = <String, Object?>{
  'id': 42,
  'name': 'А-37',
  'facultyName': 'ФИТ',
  'currentCourse': 2,
};

/// JSON-представление пары в формате API вуза (camelCase, как его отдаёт
/// `schedule.vstu.by`). Поля, для которых передано `null`, опускаются.
Map<String, dynamic> lessonJson({
  int id = 1,
  int number = 1,
  String subject = 'Математика',
  String status = 'ACTIVE',
  int dayOfWeek = 0,
  String startDate = '2025-02-03',
  String endDate = '2025-05-31',
  int timeOffset = 0,
  String type = 'Лекция',
  String typeShort = 'лк',
  String location = '305',
  int? frame = 2,
  String weekType = LessonWeekType.always,
  String? subGroup,
  Map<String, Object?>? teacher,
  Map<String, Object?>? group,
}) =>
    <String, dynamic>{
      'id': id,
      'lessonNumber': number,
      'disciplineName': subject,
      'status': status,
      'lessonDay': dayOfWeek,
      'startDate': startDate,
      'endDate': endDate,
      'timeOffset': timeOffset,
      'typeClassName': type,
      'shortTypeClassName': typeShort,
      'location': location,
      'frame': frame,
      'weekType': weekType,
      'subGroup': ?subGroup,
      'teacher': ?teacher,
      'group': ?group,
    };