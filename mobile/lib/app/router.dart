import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/groups/presentation/groups_providers.dart';
import '../features/groups/presentation/groups_screen.dart';
import '../features/schedule/presentation/schedule_screen.dart';
import '../features/settings/data/settings_controller.dart';
import '../features/settings/domain/app_settings.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'app_shell.dart';
import 'page_surface.dart';

/// Строит `MaterialPage` для маршрута.
///
/// GoRouter 18 сам решает, какую страницу отдать маршруту с `builder:`, и
/// определяет тип приложения по тому, есть ли над ним `MaterialApp` из
/// `package:material_ui` (Material вынесли из SDK в отдельный пакет). Наше
/// приложение собрано на `package:flutter/material.dart`, поэтому проверка не
/// срабатывает и GoRouter молча отдаёт `NoTransitionPage` — с нулевой
/// длительностью и пустым `transitionsBuilder`. Переходы экранов при этом
/// исчезают целиком: `pageTransitionsTheme` вообще не спрашивают.
///
/// Явный `MaterialPage` возвращает обычный маршрут Material, и переход снова
/// берётся из темы. Страница при этом оборачивается в [PageSurface]: маршрут
/// обязан закрывать собой то, что под ним.
Page<Object?> _materialPage(GoRouterState state, Widget child) =>
    MaterialPage<void>(
      key: state.pageKey,
      name: state.name,
      child: PageSurface(child: child),
    );

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: _initialLocation(ref),
    routes: [
      // Группы и расписание делят одну оболочку: её шапка живёт вне анимируемых
      // маршрутов, поэтому при переходах стоит на месте, а едет только
      // содержание. Оболочке `pageBuilder` намеренно не задан — иначе при
      // пуше настроек поверх неё уезжал бы и хром.
      ShellRoute(
        builder: (context, state, child) => appShellFor(state, child),
        routes: [
          GoRoute(
            path: GroupsScreen.routePath,
            name: GroupsScreen.routeName,
            pageBuilder: (context, state) =>
                _materialPage(state, const GroupsScreen()),
          ),
          GoRoute(
            path: '/schedule/:groupId',
            name: ScheduleScreen.routeName,
            pageBuilder: (context, state) {
              final groupId = int.tryParse(
                state.pathParameters['groupId'] ?? '',
              );
              if (groupId == null) {
                return _materialPage(state, const GroupsScreen());
              }
              return _materialPage(state, ScheduleScreen(groupId: groupId));
            },
          ),
        ],
      ),
      GoRoute(
        path: SettingsScreen.routePath,
        name: SettingsScreen.routeName,
        pageBuilder: (context, state) =>
            _materialPage(state, const SettingsScreen()),
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
