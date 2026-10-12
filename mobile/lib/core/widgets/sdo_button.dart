import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String sdoUrl = 'https://sdo.vstu.by';

Future<void> openSdo(BuildContext context) async {
  final Uri uri = Uri.parse(sdoUrl);
  final bool launched = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Не удалось открыть СДО')));
  }
}

class SdoButton extends StatelessWidget {
  const SdoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'СДО ВГТУ',
      icon: const Icon(Icons.school_outlined),
      onPressed: () => openSdo(context),
    );
  }
}
