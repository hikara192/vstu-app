/// Политика доверия к адресам СДО.
///
/// Секреты приложения (ws-токен, куки веб-сессии) можно передавать только
/// серверам ВГТУ. Всё остальное считается враждебным — в него нельзя ни
/// уходить по навигации внутри WebView, ни отправлять туда токен при
/// скачивании файлов.
const String _vstuDomain = 'vstu.by';

/// [host] — домен ВГТУ или один из его поддоменов (`sdo.vstu.by` и т. п.).
bool isAllowedSdoHost(String host) {
  final String normalized = host.toLowerCase();
  return normalized == _vstuDomain || normalized.endsWith('.$_vstuDomain');
}

/// [url] — `http(s)`-адрес на домене ВГТУ. Схема проверяется явно, чтобы
/// `javascript:`, `file:` и `intent:` не считались безопасными.
bool isAllowedSdoUrl(String url) {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null) return false;
  if (uri.scheme != 'http' && uri.scheme != 'https') return false;
  return isAllowedSdoHost(uri.host);
}
