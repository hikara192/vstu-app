import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/sdo/data/sdo_exception.dart';

void main() {
  test('ошибка прав не считается ошибкой авторизации', () {
    expect(
      sdoErrorFromMoodle('nopermissions', 'Нет прав'),
      isNot(isA<SdoAuthException>()),
    );
    expect(
      sdoErrorFromMoodle('accessexception', null),
      isNot(isA<SdoAuthException>()),
    );
  });

  test('мёртвый токен считается ошибкой авторизации', () {
    expect(sdoErrorFromMoodle('invalidtoken', null), isA<SdoAuthException>());
    expect(sdoErrorFromMoodle('usernotloggedin', null), isA<SdoAuthException>());
  });

  test('ошибка прав остаётся SdoException с непустым сообщением', () {
    final SdoException error = sdoErrorFromMoodle('nopermissions', null);

    expect(error, isA<SdoException>());
    expect(error.message, isNotEmpty);
  });

  test('неверный логин — отдельная ошибка, а не разлогин', () {
    expect(sdoErrorFromMoodle('invalidlogin', null), isNot(isA<SdoAuthException>()));
  });
}
