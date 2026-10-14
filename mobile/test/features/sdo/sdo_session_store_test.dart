import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/sdo/sdo_session_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  test('SecureSdoSessionStore сохраняет и читает куки (round-trip)', () async {
    final SdoSessionStore store = SecureSdoSessionStore();

    await store.save(const <SdoSessionCookie>[
      SdoSessionCookie(name: 'MoodleSession', value: 'abcdef123456'),
      SdoSessionCookie(name: 'sl-session', value: 'xyz=='),
    ]);

    expect(await store.load(), const <SdoSessionCookie>[
      SdoSessionCookie(name: 'MoodleSession', value: 'abcdef123456'),
      SdoSessionCookie(name: 'sl-session', value: 'xyz=='),
    ]);
  });

  test('SecureSdoSessionStore возвращает пустой список без данных', () async {
    expect(await SecureSdoSessionStore().load(), isEmpty);
  });

  test('SecureSdoSessionStore не падает на повреждённых данных', () async {
    FlutterSecureStorage.setMockInitialValues(<String, String>{
      SecureSdoSessionStore.storageKey: 'not-json-at-all',
    });

    expect(await SecureSdoSessionStore().load(), isEmpty);
  });

  test('SecureSdoSessionStore.clear удаляет сохранённую сессию', () async {
    final SdoSessionStore store = SecureSdoSessionStore();
    await store.save(const <SdoSessionCookie>[
      SdoSessionCookie(name: 'MoodleSession', value: 'abcdef123456'),
    ]);

    await store.clear();

    expect(await store.load(), isEmpty);
  });

  test('SdoSessionCookie.toString не раскрывает значение куки', () {
    const SdoSessionCookie cookie = SdoSessionCookie(
      name: 'MoodleSession',
      value: 'super-secret',
    );

    expect(cookie.toString(), isNot(contains('super-secret')));
  });
}
