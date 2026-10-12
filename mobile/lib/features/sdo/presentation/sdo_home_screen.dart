import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/gradient_header.dart';
import '../data/sdo_exception.dart';
import '../data/sdo_models.dart';
import '../sdo_screen.dart';
import 'sdo_course_screen.dart';
import 'sdo_courses_tab.dart';
import 'sdo_deadlines_tab.dart';
import 'sdo_login_form.dart';
import 'sdo_providers.dart';

/// Корневой экран СДО внутри приложения. Пока сессии нет — показывает
/// нативную форму входа; после входа — курсы и дедлайны без веб-страниц.
class SdoHomeScreen extends ConsumerWidget {
  const SdoHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SdoProfile?> auth = ref.watch(sdoAuthProvider);

    return auth.when(
      loading: () => const _SdoScaffold(
        subtitle: 'Проверяем сессию…',
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (Object error, _) => _SdoScaffold(
        subtitle: 'Не удалось проверить вход',
        body: ErrorView(
          message: describeSdoError(error),
          onRetry: () => ref.read(sdoAuthProvider.notifier).refresh(),
        ),
      ),
      data: (SdoProfile? profile) => profile == null
          ? const _LoginView()
          : _HomeView(profile: profile),
    );
  }
}

class _SdoScaffold extends StatelessWidget {
  const _SdoScaffold({required this.subtitle, required this.body, this.actions});

  final String subtitle;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          GradientHeader(
            leading: IconButton(
              tooltip: 'Назад',
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: 'СДО ВГТУ',
            subtitle: subtitle,
            actions: actions ?? const <Widget>[],
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _LoginView extends ConsumerWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SdoScaffold(
      subtitle: 'Вход в систему дистанционного обучения',
      actions: <Widget>[
        IconButton(
          tooltip: 'Веб-версия СДО',
          icon: const Icon(Icons.public),
          onPressed: () => _openWeb(context),
        ),
      ],
      body: const SdoLoginForm(),
    );
  }
}

class _HomeView extends ConsumerWidget {
  const _HomeView({required this.profile});

  final SdoProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String subtitle = profile.fullName.isNotEmpty
        ? profile.fullName
        : profile.username;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            GradientHeader(
              leading: IconButton(
                tooltip: 'Назад',
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: 'СДО ВГТУ',
              subtitle: subtitle,
              actions: <Widget>[
                IconButton(
                  tooltip: 'Веб-версия СДО',
                  icon: const Icon(Icons.public),
                  onPressed: () => _openWeb(context),
                ),
                IconButton(
                  tooltip: 'Выйти',
                  icon: const Icon(Icons.logout_rounded),
                  onPressed: () => _confirmLogout(context, ref),
                ),
              ],
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: <Widget>[
                  Tab(text: 'Курсы'),
                  Tab(text: 'Дедлайны'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  SdoCoursesTab(
                    onOpenCourse: (SdoCourse course) => Navigator.of(context)
                        .push(
                          MaterialPageRoute<void>(
                            builder: (_) => SdoCourseScreen(course: course),
                          ),
                        ),
                  ),
                  SdoDeadlinesTab(
                    onOpenUrl: (SdoDeadline deadline) => Navigator.of(context)
                        .push(
                          MaterialPageRoute<void>(
                            builder: (_) => SdoScreen(initialUrl: deadline.url),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openWeb(BuildContext context) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const SdoScreen()));
}

Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Выйти из СДО?'),
      content: const Text(
        'Токен доступа будет удалён. Для работы с СДО потребуется войти снова.',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Выйти'),
        ),
      ],
    ),
  );
  if (confirmed ?? false) {
    await ref.read(sdoAuthProvider.notifier).logout();
  }
}
