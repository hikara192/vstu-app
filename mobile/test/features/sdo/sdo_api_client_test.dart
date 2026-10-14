import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vstu_app/features/sdo/data/sdo_api_client.dart';
import 'package:vstu_app/features/sdo/data/sdo_exception.dart';

/// Подменяет транспорт Dio: запоминает запросы и отдаёт заданные байты,
/// не трогая сеть.
class _RecordingAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromBytes(<int>[1, 2, 3], 200);
  }

  @override
  void close({bool force = false}) {}
}

SdoApiClient _clientWith(_RecordingAdapter adapter) {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://sdo.vstu.by'));
  dio.httpClientAdapter = adapter;
  return SdoApiClient(dio: dio);
}

void main() {
  test('downloadFile отклоняет чужие хосты и не отправляет токен', () async {
    final _RecordingAdapter adapter = _RecordingAdapter();
    final SdoApiClient client = _clientWith(adapter);

    await expectLater(
      client.downloadFile(
        'https://evil.example/steal.pdf',
        token: 'secret-token',
      ),
      throwsA(isA<SdoException>()),
    );

    expect(
      adapter.requests,
      isEmpty,
      reason: 'токен не должен уходить на чужой хост',
    );
  });

  test('downloadFile скачивает файл с домена СДО и передаёт токен', () async {
    final _RecordingAdapter adapter = _RecordingAdapter();
    final SdoApiClient client = _clientWith(adapter);

    final List<int> bytes = await client.downloadFile(
      'https://sdo.vstu.by/pluginfile.php/1/mod_assign/file.pdf',
      token: 'secret-token',
    );

    expect(bytes, <int>[1, 2, 3]);
    expect(adapter.requests.single.uri.host, 'sdo.vstu.by');
    expect(
      adapter.requests.single.uri.queryParameters['token'],
      'secret-token',
    );
  });
}
