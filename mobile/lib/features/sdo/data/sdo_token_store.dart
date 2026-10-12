import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'sdo_models.dart';

/// Хранит токен СДО и профиль пользователя между запусками приложения.
abstract interface class SdoTokenStore {
  Future<String?> readToken();
  Future<void> writeToken(String token);
  Future<SdoProfile?> readProfile();
  Future<void> writeProfile(SdoProfile profile);
  Future<void> clear();
}

/// Реализация поверх [FlutterSecureStorage]: на Android данные шифруются
/// (AES-GCM, ключ в Keystore). Токен Moodle не должен попадать в
/// обычные SharedPreferences.
class SecureSdoTokenStore implements SdoTokenStore {
  SecureSdoTokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _tokenKey = 'sdo_ws_token';
  static const String _profileKey = 'sdo_profile';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<SdoProfile?> readProfile() async {
    final String? raw = await _storage.read(key: _profileKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is Map) {
        return _profileFromJson(decoded.cast<String, dynamic>());
      }
    } on Object {
      // Повреждённый профиль — просто загрузим его заново после входа.
    }
    return null;
  }

  @override
  Future<void> writeProfile(SdoProfile profile) => _storage.write(
    key: _profileKey,
    value: jsonEncode(_profileToJson(profile)),
  );

  @override
  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _profileKey);
  }
}

/// Хранилище в памяти — для тестов и превью.
class InMemorySdoTokenStore implements SdoTokenStore {
  InMemorySdoTokenStore([this._token, this._profile]);

  String? _token;
  SdoProfile? _profile;

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<void> writeToken(String token) async => _token = token;

  @override
  Future<SdoProfile?> readProfile() async => _profile;

  @override
  Future<void> writeProfile(SdoProfile profile) async => _profile = profile;

  @override
  Future<void> clear() async {
    _token = null;
    _profile = null;
  }
}

Map<String, Object?> _profileToJson(SdoProfile profile) => <String, Object?>{
  'userId': profile.userId,
  'username': profile.username,
  'fullName': profile.fullName,
  'siteName': profile.siteName,
  'userPictureUrl': profile.userPictureUrl,
};

SdoProfile _profileFromJson(Map<String, dynamic> json) => SdoProfile(
  userId: (json['userId'] as num?)?.toInt() ?? 0,
  username: json['username'] as String? ?? '',
  fullName: json['fullName'] as String? ?? '',
  siteName: json['siteName'] as String? ?? '',
  userPictureUrl: json['userPictureUrl'] as String? ?? '',
);
