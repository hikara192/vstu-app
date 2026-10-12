import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstu_app/features/sdo/sdo_session_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('SdoSessionStore сохраняет и читает куки (round-trip)', () async {
    final SdoSessionStore store = SdoSessionStore();

    await store.save(const <SdoSessionCookie>[
      SdoSessionCookie(name: 'MoodleSession', value: 'abcdef123456'),
      SdoSessionCookie(name: 'sl-session', value: 'xyz=='),
    ]);

    final List<SdoSessionCookie> loaded = await store.load();
    expect(loaded, const <SdoSessionCookie>[
      SdoSessionCookie(name: 'MoodleSession', value: 'abcdef123456'),
      SdoSessionCookie(name: 'sl-session', value: 'xyz=='),
    ]);
  });

  test('SdoSessionStore возвращает пустой список без сохранённых данных', () async {
    final SdoSessionStore store = SdoSessionStore();

    expect(await store.load(), isEmpty);
  });

  test('SdoSessionStore не падает на повреждённых данных', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'sdo_session_cookies': 'not-json-at-all',
    });
    final SdoSessionStore store = SdoSessionStore();

    expect(await store.load(), isEmpty);
  });
}