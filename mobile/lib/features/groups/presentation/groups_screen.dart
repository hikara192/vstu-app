import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_colors.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/plural.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/skeleton.dart';
import '../data/group.dart';
import 'group_tile.dart';
import 'groups_hierarchy.dart';
import 'groups_providers.dart';

/// Содержание экрана списка групп: иерархия, закреплённая группа и баннер.
///
/// Хром — `Scaffold` и шапку — рисует оболочка приложения (`AppShell`), поэтому
/// здесь остаётся только то, что должно ехать при переходе.
class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  static const String routeName = 'groups';
  static const String routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsProvider);
    final selectedGroup = ref.watch(selectedGroupProvider);
    final query = ref.watch(groupsQueryProvider);
    final browse = ref.watch(groupsBrowseProvider);
    final groups = groupsAsync.hasValue ? groupsAsync.requireValue : null;

    void openSchedule(int groupId) => context.push('/schedule/$groupId');
    void selectGroup(Group group) {
      ref.read(selectedGroupProvider.notifier).select(group);
      openSchedule(group.id);
    }

    final Widget body;
    if (groups != null) {
      body = query.isEmpty
          ? _buildHierarchy(ref, groups, selectedGroup, browse, selectGroup)
          : GroupsList(
              groups: groups,
              hasQuery: true,
              selectedGroupId: selectedGroup?.id,
              onSelect: selectGroup,
            );
    } else if (groupsAsync case AsyncError(:final error)) {
      body = ErrorView(
        message: describeError(error),
        onRetry: () => ref.invalidate(groupsProvider),
      );
    } else {
      body = const GroupsSkeleton();
    }

    return PopScope<Object?>(
      canPop: browse.faculty == null || query.isNotEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(groupsBrowseProvider.notifier).up();
      },
      child: Column(
        children: <Widget>[
          if (selectedGroup != null && query.isEmpty && browse.faculty == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: _MyGroupCard(
                group: selectedGroup,
                onOpen: () => openSchedule(selectedGroup.id),
                onForget: () =>
                    ref.read(selectedGroupProvider.notifier).clear(),
              ),
            ),
          OfflineBanner(onRetry: () => ref.invalidate(groupsProvider)),
          Expanded(child: body),
        ],
      ),
    );
  }
}

/// Строит текущий уровень иерархии: факультеты, курсы или группы.
Widget _buildHierarchy(
  WidgetRef ref,
  List<Group> groups,
  Group? selectedGroup,
  GroupsBrowseState browse,
  void Function(Group group) onSelect,
) {
  final faculty = browse.faculty;
  if (faculty == null) {
    final faculties = facultiesOf(groups);
    if (faculties.isEmpty) return const GroupsEmpty(hasQuery: false);
    return OptionsList(
      title: 'Выберите факультет',
      children: <Widget>[
        for (final item in faculties)
          OptionTile(
            title: item.name,
            subtitle: groupsLabel(item.count),
            onTap: () => ref
                .read(groupsBrowseProvider.notifier)
                .selectFaculty(item.name),
          ),
      ],
    );
  }

  final facultyGroups = groups
      .where((group) => facultyOf(group) == faculty)
      .toList();

  final course = browse.course;
  if (course != null) {
    return GroupsList(
      groups: facultyGroups.where((group) => group.course == course).toList(),
      hasQuery: false,
      selectedGroupId: selectedGroup?.id,
      onSelect: onSelect,
    );
  }

  final courses = coursesOf(facultyGroups);
  if (courses.isEmpty) {
    return GroupsList(
      groups: facultyGroups,
      hasQuery: false,
      selectedGroupId: selectedGroup?.id,
      onSelect: onSelect,
    );
  }

  return OptionsList(
    title: 'Выберите курс',
    children: <Widget>[
      for (final item in courses)
        OptionTile(
          title: courseLabel(item.course),
          subtitle: groupsLabel(item.count),
          onTap: () =>
              ref.read(groupsBrowseProvider.notifier).selectCourse(item.course),
        ),
    ],
  );
}

class _MyGroupCard extends StatelessWidget {
  const _MyGroupCard({
    required this.group,
    required this.onOpen,
    required this.onForget,
  });

  final Group group;
  final VoidCallback onOpen;
  final VoidCallback onForget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors.accentGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.accentGradient.last.withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.bookmark_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Моя группа',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        group.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Убрать из закреплённых',
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: onForget,
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
