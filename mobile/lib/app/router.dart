import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/groups/presentation/groups_providers.dart';
import '../features/groups/presentation/groups_screen.dart';
import '../features/schedule/presentation/schedule_screen.dart';
import '../features/settings/data/settings_controller.dart';
import '../features/settings/domain/app_settings.dart';
import '../features/settings/presentation/settings_screen.dart';

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: _initialLocation(ref),
    routes: [
      GoRoute(
        path: GroupsScreen.routePath,
        name: GroupsScreen.routeName,
        builder: (context, state) => const GroupsScreen(),
      ),
      GoRoute(
        path: '/schedule/:groupId',
        name: ScheduleScreen.routeName,
        builder: (context, state) {
          final groupId = int.tryParse(state.pathParameters['groupId'] ?? '');
          if (groupId == null) {
            return const GroupsScreen();
          }
          return ScheduleScreen(groupId: groupId);
        },
      ),
      GoRoute(
        path: SettingsScreen.routePath,
        name: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  ),
);

String _initialLocation(Ref ref) {
  final settings = ref.read(appSettingsProvider);
  if (settings.startScreen == StartScreen.groups) {
    return GroupsScreen.routePath;
  }
  final groupId = ref.read(selectedGroupProvider)?.id;
  return groupId == null ? GroupsScreen.routePath : '/schedule/$groupId';
}
