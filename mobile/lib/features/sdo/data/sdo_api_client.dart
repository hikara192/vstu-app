import 'package:dio/dio.dart';

import '../../../core/config.dart';
import '../../../core/utils/parse.dart';
import 'sdo_exception.dart';

/// Тонкий клиент Moodle Web Services.
///
/// Умеет ровно две вещи: выменять логин/пароль на `wstoken`
/// (`/login/token.php`) и вызвать произвольную ws-функцию
/// (`/webservice/rest/server.php`) с этим токеном.
class SdoApiClient {
  SdoApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.sdoUrl,
              connectTimeout: AppConfig.connectTimeout,
              receiveTimeout: AppConfig.receiveTimeout,
              responseType: ResponseType.json,
              headers: <String, Object?>{'User-Agent': AppConfig.userAgent},
            ),
          );

  final Dio _dio;

  void close() => _dio.close(force: true);

  /// Меняет логин и пароль ВГТУ на токен веб-сервиса Moodle.
  ///
  /// Бросает [SdoAuthException] при неверных данных и [SdoException] в
  /// остальных случаях.
  Future<String> requestToken({
    required String username,
    required String password,
  }) async {
    final Response<Object?> response = await _send(
      () => _dio.post<Object?>(
        AppConfig.sdoTokenPath,
        data: <String, Object?>{
          'username': username,
          'password': password,
          'service': AppConfig.sdoWebService,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
    );

    final Map<String, dynamic>? json = asMap(response.data);
    if (json == null) {
      throw const SdoException('СДО вернула неожиданный ответ при входе.');
    }

    final String? token = asString(json['token']);
    if (token != null) return token;

    throw sdoErrorFromMoodle(
      asString(json['errorcode']),
      asString(json['error']),
    );
  }

  /// Вызывает ws-функцию Moodle и возвращает её JSON-ответ.
  ///
  /// При ошибке Moodle (`errorcode` в теле) бросает [SdoException]
  /// или [SdoAuthException], когда токен недействителен.
  Future<Map<String, dynamic>> call(
    String wsFunction, {
    required String token,
    Map<String, Object?> params = const <String, Object?>{},
  }) async {
    final Response<Object?> response = await _send(
      () => _dio.post<Object?>(
        AppConfig.sdoRestPath,
        data: <String, Object?>{
          'wstoken': token,
          'wsfunction': wsFunction,
          'moodlewsrestformat': 'json',
          ...params,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
    );

    final Object? data = response.data;
    if (data is List) {
      return <String, dynamic>{'items': data};
    }
    final Map<String, dynamic>? json = asMap(data);
    if (json == null) {
      throw const SdoException('СДО вернула неожиданный ответ.');
    }

    final String? errorCode = asString(json['errorcode']);
    if (errorCode != null) {
      throw sdoErrorFromMoodle(
        errorCode,
        asString(json['message']) ?? asString(json['error']),
      );
    }
    return json;
  }

  /// Скачивает файл курса. Moodle отдаёт вложения через `pluginfile.php`,
  /// доступ к которым открывается ws-токеном в параметре `token`.
  Future<List<int>> downloadFile(String url, {required String token}) async {
    final Response<List<int>> response = await _sendBytes(
      () => _dio.get<List<int>>(
        url,
        queryParameters: <String, Object?>{'token': token},
        options: Options(responseType: ResponseType.bytes),
      ),
    );
    final List<int>? data = response.data;
    if (data == null || data.isEmpty) {
      throw const SdoException('СДО вернула пустой файл.');
    }
    return data;
  }

  Future<Response<Object?>> _send(
    Future<Response<Object?>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Future<Response<List<int>>> _sendBytes(
    Future<Response<List<int>>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  SdoException _mapDioError(DioException error) {
    final int? status = error.response?.statusCode;
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const SdoException(
        'СДО ВГТУ не отвечает. Попробуйте позже.',
        code: 'sdo_timeout',
      ),
      DioExceptionType.connectionError => const SdoException(
        'Нет соединения с СДО. Проверьте интернет.',
        code: 'sdo_network_error',
      ),
      _ => SdoException(
        status == null
            ? 'Не удалось связаться с СДО ВГТУ.'
            : 'СДО ВГТУ вернула ошибку (HTTP $status).',
        code: 'sdo_http_error',
      ),
    };
  }
}
