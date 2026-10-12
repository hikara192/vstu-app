class ApiException implements Exception {
  const ApiException(this.message, {this.code = 'unknown', this.statusCode});

  final String code;
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($code, $statusCode): $message';
}

String describeError(Object error) =>
    error is ApiException ? error.message : 'Не удалось загрузить данные';

const ApiException groupNotFoundException = ApiException(
  'Такой группы нет в расписании',
  code: 'group_not_found',
  statusCode: 404,
);

/// Группа существует, но занятий для неё нет: API вернул пустой список
/// (каникулы, сессия или расписание ещё не опубликовано). Это не то же
/// самое, что отсутствующая группа, и не должно показывать «группы нет».
const ApiException emptyScheduleException = ApiException(
  'Для этой группы расписание пока не опубликовано',
  code: 'schedule_empty',
);
