import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/notifications/presentation/notification_providers.dart';
import '../features/settings/data/settings_controller.dart';
import '../features/settings/domain/app_settings.dart';
import 'router.dart';
import 'theme.dart';

class VstuApp extends ConsumerWidget {
  const VstuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(lessonReminderSyncProvider, (_, _) {});

    final AppSettings settings = ref.watch(appSettingsProvider);
    final seed = settings.seed;

    return MaterialApp.router(
      title: 'VSTU HOME',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(seed),

      darkTheme: settings.themeMode.isAmoled
          ? AppTheme.amoled(seed)
          : AppTheme.dark(seed),
      themeMode: settings.themeMode.materialMode,
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('ru'),
      supportedLocales: const [Locale('ru')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
