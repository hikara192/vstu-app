import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/config.dart';

/// Полноэкранный «мини-браузер» СДО ВГТУ: сайт открывается внутри приложения,
/// а не во внешнем браузере.
class SdoScreen extends StatefulWidget {
  const SdoScreen({super.key, this.bodyBuilder});

  /// Заменяет WebView в widget-тестах: платформенная часть webview_flutter
  /// недоступна во flutter_test, поэтому тесты подставляют пустышку.
  final WidgetBuilder? bodyBuilder;

  @override
  State<SdoScreen> createState() => _SdoScreenState();
}

class _SdoScreenState extends State<SdoScreen> {
  // В тестах (когда задан bodyBuilder) контроллер не создаётся вовсе —
  // WebViewController сразу требует зарегистрированную платформенную часть.
  WebViewController? _controller;
  bool _failed = false;
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
    if (widget.bodyBuilder == null) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => _syncNavigationState(),
            onPageFinished: (_) => _syncNavigationState(),
            onWebResourceError: (error) {
              if (error.isForMainFrame == true) {
                setState(() => _failed = true);
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(AppConfig.sdoUrl));
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

  Future<void> _openExternally() async {
    final bool launched = await launchUrl(
      Uri.parse(AppConfig.sdoUrl),
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