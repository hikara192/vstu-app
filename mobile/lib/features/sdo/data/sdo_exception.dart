/// Ошибка при работе с СДО (Moodle). Несёт технический [code] и человекочитаемое
/// [message], готовое к показу пользователю.
class SdoException implements Exception {
  const SdoException(this.message, {this.code = 'sdo_error'});

  final String code;
  final String message;

  @override
  String toString() => 'SdoException($code): $message';
}

/// Токен СДО недействителен или истёк: нужно повторно войти.
class SdoAuthException extends SdoException {
  const SdoAuthException([
    super.message = 'Сессия СДО истекла. Войдите заново.',
  ]) : super(code: 'sdo_unauthorized');
}

/// Понятное пользователю описание ошибки СДО.
String describeSdoError(Object? error) {
  if (error is SdoException) return error.message;
  return 'Не удалось получить данные из СДО. Попробуйте ещё раз.';
}

/// Переводит код ошибки Moodle в понятное сообщение.
SdoException sdoErrorFromMoodle(String? errorCode, String? fallbackMessage) {
  return switch (errorCode) {
    'invalidlogin' || 'invalidloginerror' => const SdoException(
      'Неверный логин или пароль СДО.',
      code: 'sdo_invalidlogin',
    ),
    'invalidtoken' ||
    'accessexception' ||
    'nopermissions' ||
    'servicerequireslogin' => const SdoAuthException(),
    'webservicesnotenabled' || 'enablewsdescription' => const SdoException(
      'В СДО ВГТУ отключены веб-сервисы. Обратитесь в поддержку СДО.',
      code: 'sdo_ws_disabled',
    ),
    'usernotloggedin' => const SdoAuthException(),
    _ => SdoException(
      fallbackMessage == null || fallbackMessage.isEmpty
          ? 'СДО ВГТУ вернула ошибку.'
          : fallbackMessage,
      code: errorCode ?? 'sdo_error',
    ),
  };
}
