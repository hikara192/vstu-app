import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Кука сессии СДО (имя + значение).
///
/// [WebViewCookie] требует domain; здесь хранится только то, что нужно для
/// восстановления, а домен подставляет вызывающая сторона.
@immutable
class SdoSessionCookie {
  const SdoSessionCookie({required this.name, required this.value});

  factory SdoSessionCookie.fromJson(Map<String, Object?> json) {
    return SdoSessionCookie(
      name: json['name']! as String,
      value: json['value']! as String,
    );
  }

  final String name;
  final String value;

  Map<String, Object?> toJson() => <String, Object?>{'name': name, 'value': value};

  @override
  bool operator ==(Object other) {
    return other is SdoSessionCookie && other.name == name && other.value == value;
  }

  @override
  int get hashCode => Object.hash(name, value);

  @override
  String toString() => 'SdoSessionCookie(name: $name, value: $value)';
}

/// Хранит куки сессии СДО между запусками приложения.
///
/// Moodle выдаёт куку `MoodleSession` без срока действия (session cookie):
/// Android-WebView держит её только в памяти процесса и теряет при
/// перезапуске приложения. Этот сторедж позволяет снять куки с WebView и
/// вернуть их при следующем запуске.
class SdoSessionStore {
  SdoSessionStore([this._preferences]);

  static const String storageKey = 'sdo_session_cookies';

  final SharedPreferences? _preferences;

  Future<List<SdoSessionCookie>> load() async {
    final SharedPreferences preferences = _preferences ?? await SharedPreferences.getInstance();
    final String? raw = preferences.getString(storageKey);
    if (raw == null || raw.isEmpty) {
      return const <SdoSessionCookie>[];
    }
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((dynamic item) => SdoSessionCookie.fromJson(item as Map<String, dynamic>))
          .toList();
    } on Object {
      // Повреждённые данные — просто попросим пользователя войти заново.
      return const <SdoSessionCookie>[];
    }
  }

  Future<void> save(List<SdoSessionCookie> cookies) async {
    final SharedPreferences preferences = _preferences ?? await SharedPreferences.getInstance();
    final String raw = jsonEncode(cookies.map((SdoSessionCookie cookie) => cookie.toJson()).toList());
    await preferences.setString(storageKey, raw);
  }
}