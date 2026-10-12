import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:vstu_app/core/widgets/sdo_button.dart';
import 'package:vstu_app/features/sdo/sdo_screen.dart';

class _RecordingUrlLauncherPlatform extends UrlLauncherPlatform {
  final List<String> launchedUrls = <String>[];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrls.add(url);
    return true;
  }
}

/// Заменяет настоящий WebView (платформенный виджет) на пустышку,
/// чтобы экран можно было собрать в widget-тесте.
Widget _fakeWebViewBody(BuildContext context) => const SizedBox.shrink();

void main() {
  late _RecordingUrlLauncherPlatform urlLauncher;
  late UrlLauncherPlatform originalUrlLauncher;

  setUp(() {
    urlLauncher = _RecordingUrlLauncherPlatform();
    originalUrlLauncher = UrlLauncherPlatform.instance;
    UrlLauncherPlatform.instance = urlLauncher;
  });

  tearDown(() {
    UrlLauncherPlatform.instance = originalUrlLauncher;
  });

  testWidgets('SdoButton opens the SDO inside the app, not externally', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SdoButton(webViewBody: _fakeWebViewBody),
        ),
      ),
    );

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.byType(SdoScreen), findsOneWidget);
    expect(find.text('СДО ВГТУ'), findsOneWidget);
    expect(urlLauncher.launchedUrls, isEmpty);
  });

  testWidgets('SdoScreen shows the mini-browser toolbar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SdoScreen(bodyBuilder: _fakeWebViewBody)),
    );

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(find.byIcon(Icons.open_in_browser), findsOneWidget);

    final backButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.arrow_back),
    );
    expect(backButton.onPressed, isNull, reason: 'в истории ещё нет записей');
  });

  testWidgets('the open-in-browser button launches the external browser', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: SdoScreen(bodyBuilder: _fakeWebViewBody)),
    );

    await tester.tap(find.byIcon(Icons.open_in_browser));
    await tester.pump();

    expect(urlLauncher.launchedUrls, <String>['https://sdo.vstu.by']);
  });
}