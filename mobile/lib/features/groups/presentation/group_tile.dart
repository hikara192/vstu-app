import 'package:flutter/material.dart';

import '../../../core/utils/plural.dart';
import '../../../core/widgets/press_scale.dart';
import '../../../core/widgets/staggered_appear.dart';
import '../data/group.dart';

class GroupsList extends StatelessWidget {
  const GroupsList({
    super.key,
    required this.groups,
    required this.hasQuery,
    required this.selectedGroupId,
    required this.onSelect,
  });

  final List<Group> groups;

  final bool hasQuery;
  final int? selectedGroupId;
  final ValueChanged<Group> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (groups.isEmpty) {
      return GroupsEmpty(hasQuery: hasQuery);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
          child: Text(
            hasQuery
                ? 'Найдено: ${groupsLabel(groups.length)}'
                : 'Всего: ${groupsLabel(groups.length)}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              16 + MediaQuery.paddingOf(context).bottom,
            ),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return StaggeredAppear(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GroupTile(
                    group: group,
                    isSelected: group.id == selectedGroupId,
                    onTap: () => onSelect(group),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.group,
    required this.isSelected,
    required this.onTap,
  });

  final Group group;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final subtitle = group.subtitle;

    return PressScale(
      child: Card(
        color: isSelected
            ? scheme.primaryContainer.withValues(alpha: 0.35)
            : scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected
                ? scheme.primary.withValues(alpha: 0.5)
                : scheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                GroupAvatar(group: group, isSelected: isSelected),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        group.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isSelected ? Icons.check_circle : Icons.chevron_right_rounded,
                  color: isSelected ? scheme.primary : scheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GroupAvatar extends StatelessWidget {
  const GroupAvatar({super.key, required this.group, required this.isSelected});

  final Group group;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final label = group.name.isEmpty ? '?' : group.name.substring(0, 1);

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: isSelected ? scheme.primary : scheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isSelected ? scheme.onPrimary : scheme.onPrimaryContainer,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class GroupsEmpty extends StatelessWidget {
  const GroupsEmpty({super.key, required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasQuery ? Icons.search_off_rounded : Icons.groups_outlined,
                size: 34,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hasQuery ? 'Группа не найдена' : 'Список групп пуст',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hasQuery
                  ? 'Проверьте номер группы — например, «А-37».'
                  : 'Обновите данные или проверьте источник данных.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
