import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_colors.dart';
import '../../../core/config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/plural.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/gradient_header.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/sdo_button.dart';
import '../../../core/widgets/skeleton.dart';
import '../../settings/presentation/settings_screen.dart';
import '../data/group.dart';
import 'group_tile.dart';
import 'groups_hierarchy.dart';
import 'groups_providers.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  static const String routeName = 'groups';
  static const String routePath = '/';

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  String? _faculty;
  int? _course;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(AppConfig.searchDebounce, () {
      if (mounted) {
        ref.read(groupsQueryProvider.notifier).update(value);
      }
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {});
    ref.read(groupsQueryProvider.notifier).update('');
  }

  void _openSchedule(int groupId) => context.push('/schedule/$groupId');

  void _selectGroup(Group group) {
    ref.read(selectedGroupProvider.notifier).select(group);
    _openSchedule(group.id);
  }

  void _goBack() {
    setState(() {
      if (_course != null) {
        _course = null;
      } else {
        _faculty = null;
      }
    });
  }

  String _subtitleFor(String query, Group? selectedGroup) {
    final faculty = _faculty;
    if (query.isEmpty && faculty != null) {
      final course = _course;
      return course == null ? faculty : '$faculty • ${courseLabel(course)}';
    }
    return selectedGroup == null
        ? 'Найдите свою учебную группу'
        : 'Моя группа: ${selectedGroup.name}';
  }

  Widget _buildHierarchy(List<Group> groups, Group? selectedGroup) {
    final faculty = _faculty;
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
              onTap: () => setState(() {
                _faculty = item.name;
                _course = null;
              }),
            ),
        ],
      );
    }

    final facultyGroups = groups
        .where((group) => facultyOf(group) == faculty)
        .toList();

    if (_course != null) {
      return GroupsList(
        groups: facultyGroups
            .where((group) => group.course == _course)
            .toList(),
        hasQuery: false,
        selectedGroupId: selectedGroup?.id,
        onSelect: _selectGroup,
      );
    }

    final courses = coursesOf(facultyGroups);
    if (courses.isEmpty) {
      return GroupsList(
        groups: facultyGroups,
        hasQuery: false,
        selectedGroupId: selectedGroup?.id,
        onSelect: _selectGroup,
      );
    }

    return OptionsList(
      title: 'Выберите курс',
      children: <Widget>[
        for (final item in courses)
          OptionTile(
            title: courseLabel(item.course),
            subtitle: groupsLabel(item.count),
            onTap: () => setState(() => _course = item.course),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsProvider);
    final selectedGroup = ref.watch(selectedGroupProvider);
    final query = ref.watch(groupsQueryProvider);
    final groups = groupsAsync.hasValue ? groupsAsync.requireValue : null;

    final Widget body;
    if (groups != null) {
      body = query.isEmpty
          ? _buildHierarchy(groups, selectedGroup)
          : GroupsList(
              groups: groups,
              hasQuery: true,
              selectedGroupId: selectedGroup?.id,
              onSelect: _selectGroup,
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
      canPop: _faculty == null || query.isNotEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            GradientHeader(
              leading: query.isEmpty && _faculty != null
                  ? IconButton(
                      tooltip: 'Назад',
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: _goBack,
                    )
                  : null,
              title: 'VSTU HOME',
              subtitle: _subtitleFor(query, selectedGroup),
              actions: <Widget>[
                if (selectedGroup != null)
                  IconButton(
                    tooltip: 'Расписание моей группы',
                    icon: const Icon(Icons.event_note_outlined),
                    onPressed: () => _openSchedule(selectedGroup.id),
                  ),
                const SdoButton(),
                IconButton(
                  tooltip: 'Настройки',
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () => context.push(SettingsScreen.routePath),
                ),
              ],
              child: SearchBar(
                controller: _searchController,
                hintText: 'Поиск по номеру группы',
                leading: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                trailing: <Widget>[
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      tooltip: 'Очистить',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: _clearSearch,
                    ),
                ],
                onChanged: _onSearchChanged,
              ),
            ),
            if (selectedGroup != null && query.isEmpty && _faculty == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: _MyGroupCard(
                  group: selectedGroup,
                  onOpen: () => _openSchedule(selectedGroup.id),
                  onForget: () =>
                      ref.read(selectedGroupProvider.notifier).clear(),
                ),
              ),
            OfflineBanner(onRetry: () => ref.invalidate(groupsProvider)),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
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
