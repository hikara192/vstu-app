import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/config.dart';
import 'sdo_host_policy.dart';
import 'sdo_session_store.dart';

/// Полноэкранный «мини-браузер» СДО ВГТУ: сайт открывается внутри приложения,
/// а не во внешнем браузере.
class SdoScreen extends StatefulWidget {
  const SdoScreen({super.key, this.bodyBuilder, this.initialUrl});

  /// Заменяет WebView в widget-тестах: платформенная часть webview_flutter
  /// недоступна во flutter_test, поэтому тесты подставляют пустышку.
  final WidgetBuilder? bodyBuilder;

  /// Адрес, который открывается первым. По умолчанию — главная СДО.
  /// Позволяет открыть конкретный элемент курса (задание, тест, файл).
  final String? initialUrl;

  String get _startUrl => initialUrl ?? AppConfig.sdoUrl;

  @override
  State<SdoScreen> createState() => _SdoScreenState();
}

class _SdoScreenState extends State<SdoScreen> {
  // В тестах (когда задан bodyBuilder) контроллер не создаётся вовсе —
  // WebViewController сразу требует зарегистрированную платформенную часть.
  WebViewController? _controller;
  late final WebViewCookieManager _cookieManager;
  late final SdoSessionStore _sessionStore;
  bool _failed = false;
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
    if (widget.bodyBuilder == null) {
      _cookieManager = WebViewCookieManager();
      _sessionStore = SecureSdoSessionStore();
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => _syncNavigationState(),
            onPageFinished: (_) {
              _syncNavigationState();
              _snapshotSession();
            },
            onNavigationRequest: (NavigationRequest request) {
              if (isAllowedSdoUrl(request.url)) {
                return NavigationDecision.navigate;
              }
              // Сессия СДО уже активна в этом WebView: чужой адрес здесь — это
              // доступ к ней. Открываем снаружи, внутри приложения не пускаем.
              unawaited(_openExternally(request.url));
              return NavigationDecision.prevent;
            },
            onWebResourceError: (error) {
              if (error.isForMainFrame == true) {
                setState(() => _failed = true);
              }
            },
          ),
        );
      _initializeSession();
    }
  }

  /// Возвращает сохранённую сессию в WebView до первой загрузки страницы:
  /// Moodle выдаёт куку `MoodleSession` без срока действия, и Android-WebView
  /// теряет её при перезапуске приложения, хотя серверная сессия ещё жива.
  Future<void> _initializeSession() async {
    try {
      final List<SdoSessionCookie> saved = await _sessionStore.load();
      for (final SdoSessionCookie cookie in saved) {
        await _cookieManager.setCookie(
          WebViewCookie(
            name: cookie.name,
            value: cookie.value,
            domain: AppConfig.sdoUrl,
            path: '/',
          ),
        );
      }
    } on Object {
      // Сессию восстановить не удалось — пользователь просто войдёт заново.
    }
    unawaited(_controller?.loadRequest(Uri.parse(widget._startUrl)));
  }

  /// Снимает текущие куки с WebView и сохраняет их, чтобы авторизация
  /// пережила перезапуск приложения. На странице входа сессия ещё гостевая —
  /// такие куки не сохраняем, чтобы не затереть авторизованную сессию.
  Future<void> _snapshotSession() async {
    final WebViewController? controller = _controller;
    if (controller == null) {
      return;
    }
    try {
      final String? url = await controller.currentUrl();
      if (url != null && url.contains('/login/')) {
        return;
      }
      final List<WebViewCookie> cookies = await _cookieManager.getCookies(
        domain: Uri.parse(AppConfig.sdoUrl),
      );
      if (cookies.isEmpty) {
        return;
      }
      await _sessionStore.save(
        cookies
            .map((WebViewCookie cookie) => SdoSessionCookie(name: cookie.name, value: cookie.value))
            .toList(),
      );
    } on Object {
      // Снимок не удался — хуже будет только перелогин при следующем запуске.
    }
  }

  // Кнопки «назад/вперёд» зависят от истории WebView, поэтому обновляем
  // панель инструментов при каждой смене страницы.
  Future<void> _syncNavigationState() async {
    final WebViewController? controller = _controller;
    if (!mounted || controller == null) {
      return;
    }
    final bool back = await controller.canGoBack();
    final bool forward = await controller.canGoForward();
    if (!mounted) {
      return;
    }
    setState(() {
      _canGoBack = back;
      _canGoForward = forward;
    });
  }

  void _retry() {
    setState(() => _failed = false);
    unawaited(_controller?.reload());
    _syncNavigationState();
  }

  Future<void> _openExternally([String? url]) async {
    final String target = url ?? await _controller?.currentUrl() ?? widget._startUrl;
    final bool launched = await launchUrl(
      Uri.parse(target),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть СДО')),
      );
    }
  }

  Widget _buildBody() {
    final WidgetBuilder? bodyBuilder = widget.bodyBuilder;
    if (bodyBuilder != null) {
      return bodyBuilder(context);
    }
    if (_failed) {
      return _ErrorView(onRetry: _retry, onOpenExternal: _openExternally);
    }
    return WebViewWidget(controller: _controller!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('СДО ВГТУ')),
      body: _buildBody(),
      bottomNavigationBar: _BrowserBar(
        canGoBack: _canGoBack,
        canGoForward: _canGoForward,
        onBack: () => unawaited(_controller?.goBack()),
        onForward: () => unawaited(_controller?.goForward()),
        onRefresh: _retry,
        onOpenExternal: _openExternally,
      ),
    );
  }
}

class _BrowserBar extends StatelessWidget {
  const _BrowserBar({
    required this.canGoBack,
    required this.canGoForward,
    required this.onBack,
    required this.onForward,
    required this.onRefresh,
    required this.onOpenExternal,
  });

  final bool canGoBack;
  final bool canGoForward;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onRefresh;
  final VoidCallback onOpenExternal;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              tooltip: 'Назад',
              icon: const Icon(Icons.arrow_back),
              onPressed: canGoBack ? onBack : null,
            ),
            IconButton(
              tooltip: 'Вперёд',
              icon: const Icon(Icons.arrow_forward),
              onPressed: canGoForward ? onForward : null,
            ),
            IconButton(
              tooltip: 'Обновить',
              icon: const Icon(Icons.refresh),
              onPressed: onRefresh,
            ),
            IconButton(
              tooltip: 'Открыть в браузере',
              icon: const Icon(Icons.open_in_browser),
              onPressed: onOpenExternal,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry, required this.onOpenExternal});

  final VoidCallback onRetry;
  final VoidCallback onOpenExternal;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.cloud_off, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'Не удалось загрузить СДО',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onOpenExternal,
              child: const Text('Открыть в браузере'),
            ),
          ],
        ),
      ),
    );
  }
}