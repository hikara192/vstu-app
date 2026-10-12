import 'package:flutter/material.dart';

import '../../features/sdo/presentation/sdo_home_screen.dart';

/// Открывает раздел СДО внутри приложения. Данные СДО (курсы, дедлайны,
/// оценки) показываются нативными экранами; веб-версия доступна отдельно,
/// как запасной вариант.
void openSdo(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const SdoHomeScreen()),
  );
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
