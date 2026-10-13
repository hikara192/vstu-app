import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config.dart';
import '../../../core/utils/plural.dart';
import '../../../core/widgets/gradient_header.dart';
import '../../../core/widgets/sdo_button.dart';
import '../../settings/presentation/settings_screen.dart';
import '../data/group.dart';
import 'groups_providers.dart';

/// Содержимое шапки списка групп: заголовок, действия и поиск.
///
/// Подложку не рисует — её даёт вызывающий (`GradientHeaderSurface`). В оболочке
/// приложения подложка живёт вне анимируемого маршрута, поэтому при переходах
/// шапка стоит на месте, а меняется только это содержимое.
class GroupsHeader extends ConsumerStatefulWidget {
  const GroupsHeader({super.key});

  @override
  ConsumerState<GroupsHeader> createState() => _GroupsHeaderState();
}

class _GroupsHeaderState extends ConsumerState<GroupsHeader> {
  /// Поле поднимает уже введённый запрос: при возврате из расписания экран
  /// создаётся заново, а запрос живёт в провайдере.
  late final TextEditingController _searchController = TextEditingController(
    text: ref.read(groupsQueryProvider),
  );

  Timer? _debounce;

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

  String _subtitleFor(
    String query,
    Group? selectedGroup,
    GroupsBrowseState browse,
  ) {
    final faculty = browse.faculty;
    if (query.isEmpty && faculty != null) {
      final course = browse.course;
      return course == null ? faculty : '$faculty • ${courseLabel(course)}';
    }
    return selectedGroup == null
        ? 'Найдите свою учебную группу'
        : 'Моя группа: ${selectedGroup.name}';
  }

  @override
  Widget build(BuildContext context) {
    final browse = ref.watch(groupsBrowseProvider);
    final query = ref.watch(groupsQueryProvider);
    final selectedGroup = ref.watch(selectedGroupProvider);

    return GradientHeaderContent(
      leading: query.isEmpty && browse.faculty != null
          ? IconButton(
              tooltip: 'Назад',
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => ref.read(groupsBrowseProvider.notifier).up(),
            )
          : null,
      title: 'VSTU HOME',
      subtitle: _subtitleFor(query, selectedGroup, browse),
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
    );
  }
}
