import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
}

/// Хранит куки веб-сессии СДО между запусками приложения.
abstract interface class SdoSessionStore {
  Future<List<SdoSessionCookie>> load();

  Future<void> save(List<SdoSessionCookie> cookies);

  Future<void> clear();
}

/// Хранит куки в [FlutterSecureStorage]: значение куки `MoodleSession` даёт
/// доступ к веб-версии СДО, поэтому оно не должно лежать в обычных
/// `SharedPreferences` (там его может прочитать любой с доступом к данным
/// приложения). Так же защищён, как и ws-токен.
class SecureSdoSessionStore implements SdoSessionStore {
  SecureSdoSessionStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const String storageKey = 'sdo_session_cookies';

  final FlutterSecureStorage _storage;

  @override
  Future<List<SdoSessionCookie>> load() async {
    final String? raw = await _storage.read(key: storageKey);
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

  @override
  Future<void> save(List<SdoSessionCookie> cookies) {
    final String raw = jsonEncode(
      cookies.map((SdoSessionCookie cookie) => cookie.toJson()).toList(),
    );
    return _storage.write(key: storageKey, value: raw);
  }

  @override
  Future<void> clear() => _storage.delete(key: storageKey);
}

/// Хранилище в памяти — для тестов и превью.
class InMemorySdoSessionStore implements SdoSessionStore {
  InMemorySdoSessionStore([List<SdoSessionCookie>? cookies])
    : _cookies = <SdoSessionCookie>[...?cookies];

  List<SdoSessionCookie> _cookies;

  @override
  Future<List<SdoSessionCookie>> load() async => List<SdoSessionCookie>.of(_cookies);

  @override
  Future<void> save(List<SdoSessionCookie> cookies) async {
    _cookies = List<SdoSessionCookie>.of(cookies);
  }

  @override
  Future<void> clear() async {
    _cookies = <SdoSessionCookie>[];
  }
}
