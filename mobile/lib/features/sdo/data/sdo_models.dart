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

/// Категория курсов СДО (`core_course_get_categories`). В ВГТУ категории
/// соответствуют направлениям/специальностям.
@freezed
abstract class SdoCategory with _$SdoCategory {
  const factory SdoCategory({
    required int id,
    @Default('') String name,
    int? parent,
    @Default(0) int courseCount,
    @Default('') String idNumber,
  }) = _SdoCategory;
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

/// Файл или ссылка внутри элемента курса / вложения к заданию.
@freezed
abstract class SdoFile with _$SdoFile {
  const factory SdoFile({
    @Default('file') String type,
    @Default('') String fileName,
    @Default('') String fileUrl,
    @Default('') String mimeType,
    @Default(0) int fileSize,
    DateTime? timeModified,
    @Default(<int>[]) List<int> fileBytes,
  }) = _SdoFile;
}

extension SdoFilePresentation on SdoFile {
  bool get isWebLink =>
      type == 'url' ||
      fileUrl.startsWith('http://') ||
      fileUrl.startsWith('https://');

  bool get isImage => mimeType.startsWith('image/');

  bool get isPdf => mimeType == 'application/pdf';
}

/// Модуль (элемент) внутри раздела курса (`core_course_get_contents`).
@freezed
abstract class SdoModule with _$SdoModule {
  const factory SdoModule({
    required int id,
    required String name,
    @Default('') String modName,
    @Default(0) int instance,
    @Default('') String url,
    @Default('') String description,
    @Default(true) bool visible,
    @Default(<SdoFile>[]) List<SdoFile> contents,
  }) = _SdoModule;
}

extension SdoModulePresentation on SdoModule {
  bool get isAssign => modName == 'assign';

  bool get isQuiz => modName == 'quiz';

  bool get isResource =>
      modName == 'resource' || modName == 'folder' || modName == 'book';

  bool get isUrl => modName == 'url';

  bool get hasFiles => contents.any((SdoFile file) => !file.isWebLink);
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

/// Статус отправки задания студентом.
enum SdoSubmissionStatus {
  /// Работа не начата.
  newSubmission,

  /// Черновик сохранён, но не отправлен.
  draft,

  /// Работа отправлена на проверку.
  submitted,
}

/// Учебное задание (`mod_assign_get_assignments`).
@freezed
abstract class SdoAssignment with _$SdoAssignment {
  const factory SdoAssignment({
    required int id,
    required int courseId,
    required String name,
    @Default(0) int courseModuleId,
    @Default('') String description,
    DateTime? dueDate,
    DateTime? allowFromDate,
    DateTime? cutoffDate,
    @Default(0) int maxAttempts,
    @Default(false) bool requiresText,
    @Default(false) bool requiresFile,
    @Default(SdoSubmissionStatus.newSubmission) SdoSubmissionStatus status,
    DateTime? submittedAt,
    @Default('') String onlineText,
    @Default(<SdoFile>[]) List<SdoFile> files,
  }) = _SdoAssignment;
}

extension SdoAssignmentPresentation on SdoAssignment {
  bool get isSubmitted => status == SdoSubmissionStatus.submitted;

  bool get isDraft => status == SdoSubmissionStatus.draft;

  bool get isOverdue {
    final DateTime? due = dueDate;
    return due != null && !isSubmitted && DateTime.now().isAfter(due);
  }
}

/// Тест (`mod_quiz_get_quizzes_by_courses`).
@freezed
abstract class SdoQuiz with _$SdoQuiz {
  const factory SdoQuiz({
    required int id,
    required int courseId,
    required String name,
    @Default(0) int courseModuleId,
    @Default('') String intro,
    DateTime? timeOpen,
    DateTime? timeClose,
    @Default(0) int timeLimit,
    @Default(0) int maxAttempts,
    @Default(0) int gradeMethod,
    @Default(false) bool hasQuestions,
  }) = _SdoQuiz;
}

extension SdoQuizPresentation on SdoQuiz {
  bool get isOpenNow {
    final DateTime now = DateTime.now();
    if (timeOpen != null && now.isBefore(timeOpen!)) return false;
    if (timeClose != null && now.isAfter(timeClose!)) return false;
    return true;
  }

  bool get isNotYetOpen =>
      timeOpen != null && DateTime.now().isBefore(timeOpen!);

  bool get isClosed => timeClose != null && DateTime.now().isAfter(timeClose!);
}

/// Попытка прохождения теста (`mod_quiz_get_user_attempts`).
@freezed
abstract class SdoQuizAttempt with _$SdoQuizAttempt {
  const factory SdoQuizAttempt({
    required int id,
    required int quizId,
    @Default(1) int attempt,
    @Default('') String state,
    DateTime? timeStart,
    DateTime? timeFinish,
    double? grade,
  }) = _SdoQuizAttempt;
}

extension SdoQuizAttemptPresentation on SdoQuizAttempt {
  bool get isFinished => state == 'finished';

  bool get isInProgress => state == 'inprogress';
}

/// Текущая отправка студента по заданию (`mod_assign_get_submission_status`).
class SdoSubmission {
  const SdoSubmission({
    required this.status,
    this.onlineText = '',
    this.files = const <SdoFile>[],
    this.updatedAt,
  });

  final SdoSubmissionStatus status;
  final String onlineText;
  final List<SdoFile> files;
  final DateTime? updatedAt;
}

extension SdoSubmissionPresentation on SdoSubmission {
  bool get isOverdue {
    // В реальности нужно проверять cutoffDate/duedate задания,
    // но здесь нет ссылки на задание. Оставляем как флаг.
    return status == SdoSubmissionStatus.newSubmission ||
        status == SdoSubmissionStatus.draft;
  }
}
