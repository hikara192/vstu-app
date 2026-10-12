import 'package:dio/dio.dart';

import '../config.dart';
import 'api_exception.dart';

class UniApiClient {
  UniApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              connectTimeout: AppConfig.connectTimeout,
              receiveTimeout: AppConfig.receiveTimeout,
              responseType: ResponseType.json,
              headers: <String, Object?>{
                'Accept': 'application/json',
                'User-Agent': AppConfig.userAgent,
              },
            ),
          );

  final Dio _dio;

  static const int _maxRetries = 2;

  static const Duration _retryBackoff = Duration(milliseconds: 250);

  void close() => _dio.close(force: true);

  Future<Object?> getJson(String path) async {
    DioException? lastError;
    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        final response = await _dio.get<Object?>(path);
        return response.data;
      } on DioException catch (error) {
        final status = error.response?.statusCode;

        if (status != null && status >= 400 && status < 500 && status != 429) {
          throw _mapError(error);
        }
        lastError = error;
        if (attempt < _maxRetries) {
          await Future<void>.delayed(_retryBackoff * (1 << attempt));
        }
      }
    }
    throw _mapError(lastError!);
  }

  ApiException _mapError(DioException error) {
    final status = error.response?.statusCode;
    if (status == 404) {
      return groupNotFoundException;
    }
    if (status != null && status >= 500) {
      return ApiException(
        'Сервис расписания вуза временно недоступен (HTTP $status)',
        code: 'upstream_unavailable',
        statusCode: status,
      );
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const ApiException(
        'Сервис вуза не отвечает. Попробуйте позже.',
        code: 'timeout',
      ),
      DioExceptionType.connectionError => const ApiException(
        'Нет соединения с интернетом. Проверьте Wi-Fi или мобильные данные.',
        code: 'network_error',
      ),
      _ => ApiException(
        'Не удалось загрузить данные расписания',
        code: 'http_error',
        statusCode: status,
      ),
    };
  }
}
