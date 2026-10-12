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
