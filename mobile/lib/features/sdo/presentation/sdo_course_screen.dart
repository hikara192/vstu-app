import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../data/sdo_exception.dart';
import '../data/sdo_models.dart';
import 'sdo_assignments_tab.dart';
import 'sdo_providers.dart';
import 'sdo_quizzes_tab.dart';
import '../sdo_screen.dart';

/// Экран курса: материалы, задания, тесты.
class SdoCourseScreen extends ConsumerWidget {
  const SdoCourseScreen({super.key, required this.course});

  final SdoCourse course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(course.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Материалы'),
              Tab(text: 'Задания'),
              Tab(text: 'Тесты'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _ContentsTab(courseId: course.id),
            SdoAssignmentsTab(courseId: course.id),
            SdoQuizzesTab(courseId: course.id),
          ],
        ),
      ),
    );
  }
}

class _ContentsTab extends ConsumerWidget {
  const _ContentsTab({required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SdoSection>> contents = ref.watch(
      sdoCourseContentsProvider(courseId),
    );

    return contents.when(
      loading: () => const ScheduleSkeleton(),
      error: (Object error, _) => ErrorView(
        message: describeSdoError(error),
        onRetry: () => ref.invalidate(sdoCourseContentsProvider(courseId)),
      ),
      data: (List<SdoSection> sections) {
        final List<SdoSection> withModules = sections
            .where((SdoSection section) => section.modules.isNotEmpty)
            .toList();
        if (withModules.isEmpty) {
          return const _EmptyContents();
        }
        return RefreshIndicator(
          onRefresh: () async =>
              ref.refresh(sdoCourseContentsProvider(courseId).future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: <Widget>[
              for (final SdoSection section in withModules)
                _SectionCard(section: section),
            ],
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final SdoSection section;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String title = section.name.isEmpty ? 'Без названия' : section.name;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
              child: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            for (final SdoModule module in section.modules)
              _ModuleTile(module: module),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _ModuleTile extends ConsumerWidget {
  const _ModuleTile({required this.module});

  final SdoModule module;

  static IconData _iconFor(String modName) {
    return switch (modName) {
      'assign' => Icons.assignment_outlined,
      'quiz' => Icons.quiz_outlined,
      'forum' => Icons.forum_outlined,
      'resource' || 'folder' || 'book' => Icons.folder_outlined,
      'url' => Icons.link,
      'page' => Icons.article_outlined,
      'lesson' => Icons.menu_book_outlined,
      'choice' => Icons.how_to_vote_outlined,
      'feedback' => Icons.rate_review_outlined,
      'chat' => Icons.chat_bubble_outline,
      'wiki' => Icons.public,
      'glossary' => Icons.auto_stories_outlined,
      _ => Icons.description_outlined,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool enabled = module.visible && module.url.isNotEmpty;

    return ListTile(
      dense: true,
      enabled: enabled,
      leading: Icon(
        _iconFor(module.modName),
        color: enabled ? scheme.primary : scheme.outline,
      ),
      title: Text(
        module.name.isEmpty ? module.modName : module.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium,
      ),
      subtitle: module.hasFiles
          ? Text(
              '${module.contents.where((SdoFile f) => !f.isWebLink).length} файл(ов)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: Icon(
        Icons.open_in_new_rounded,
        size: 16,
        color: scheme.onSurfaceVariant,
      ),
      onTap: enabled
          ? () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SdoScreen(initialUrl: module.url),
              ),
            )
          : null,
    );
  }
}

class _EmptyContents extends StatelessWidget {
  const _EmptyContents();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.folder_open_outlined,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              'Материалов пока нет',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Преподаватель ещё не добавил элементы в этот курс.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}