import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

/// Сохраняет скачанный файл во временную папку и открывает его системным
/// приложением. Абстракция нужна для тестов (в них файлы не трогаем).
abstract interface class SdoFileOpener {
  Future<void> open({
    required String fileName,
    required List<int> bytes,
    String mimeType,
  });
}

class SystemSdoFileOpener implements SdoFileOpener {
  @override
  Future<void> open({
    required String fileName,
    required List<int> bytes,
    String mimeType = '',
  }) async {
    final Directory dir = await getTemporaryDirectory();
    final File file = File('${dir.path}/${_safeName(fileName)}');
    await file.writeAsBytes(bytes, flush: true);
    await OpenFilex.open(
      file.path,
      type: mimeType.isEmpty ? null : mimeType,
    );
  }

  String _safeName(String name) {
    final String cleaned = name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
    return cleaned.isEmpty ? 'sdo_file' : cleaned;
  }
}
