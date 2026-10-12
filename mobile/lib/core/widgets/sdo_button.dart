import 'package:flutter/material.dart';

import '../../features/sdo/sdo_screen.dart';

/// Открывает СДО внутри приложения (полноэкранный WebView), а не во внешнем
/// браузере. [webViewBody] — шов для тестов: подменяет настоящий WebView.
void openSdo(BuildContext context, {WidgetBuilder? webViewBody}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => SdoScreen(bodyBuilder: webViewBody),
    ),
  );
}

class SdoButton extends StatelessWidget {
  const SdoButton({super.key, this.webViewBody});

  final WidgetBuilder? webViewBody;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'СДО ВГТУ',
      icon: const Icon(Icons.school_outlined),
      onPressed: () => openSdo(context, webViewBody: webViewBody),
    );
  }
}