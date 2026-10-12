import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/gradient_header.dart';
import '../../groups/presentation/groups_providers.dart';
import '../../notifications/presentation/notification_providers.dart';
import '../../schedule/presentation/schedule_providers.dart';
import '../data/settings_controller.dart';
import '../domain/app_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const String routeName = 'settings';
  static const String routePath = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final selectedGroup = ref.watch(selectedGroupProvider);
    final controller = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      body: Column(
        children: <Widget>[
          GradientHeader(
            leading: IconButton(
              tooltip: 'Назад',
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
            title: 'Настройки',
            subtitle: 'Оформление и запуск приложения',
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.paddingOf(context).bottom,
              ),
              children: <Widget>[
                const _SectionTitle('Внешний вид'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: <Widget>[
                        _ChoiceRow(
                          title: 'Тема',
                          subtitle: settings.themeMode.title,
                          child: Column(
                            children: <Widget>[
                              for (final mode in AppThemeMode.values)
                                _ChoiceRow(
                                  title: mode.title,
                                  subtitle: mode.description,
                                  selected: mode == settings.themeMode,
                                  compact: true,
                                  onTap: () => controller.setThemeMode(mode),
                                ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ChoiceRow(
                          title: 'Акцентный цвет',
                          subtitle: settings.accent.title,
                          child: _AccentPicker(
                            selected: settings.accent,
                            onSelect: controller.setAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const _SectionTitle('Запуск'),
                Card(
                  child: Column(
                    children: <Widget>[
                      _ChoiceRow(
                        title: 'Стартовый экран',
                        subtitle: settings.startScreen.title,
                        child: Column(
                          children: <Widget>[
                            for (final screen in StartScreen.values)
                              _ChoiceRow(
                                title: screen.title,
                                subtitle: screen.description,
                                selected: screen == settings.startScreen,
                                compact: true,
                                onTap: () => controller.setStartScreen(screen),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const _SectionTitle('Уведомления'),
                Card(
                  child: Column(
                    children: <Widget>[
                      _SwitchRow(
                        icon: Icons.notifications_active_outlined,
                        title: 'Напоминать о парах',
                        subtitle:
                            'За 5 минут до начала пары моей группы '
                            '(по будням и субботам).',
                        value: settings.notificationsEnabled,
                        onChanged: (value) =>
                            _toggleNotifications(context, ref, value),
                      ),
                    ],
                  ),
                ),
                const _SectionTitle('Данные'),
                Card(
                  child: Column(
                    children: <Widget>[
                      _ActionRow(
                        icon: Icons.delete_sweep_outlined,
                        title: 'Очистить кэш',
                        subtitle:
                            'Справочник групп и расписание закреплённой группы. '
                            'Настройки и выбранная группа останутся.',
                        onTap: () =>
                            _clearCache(context, ref, selectedGroup?.id),
                      ),
                      if (selectedGroup != null) ...<Widget>[
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ActionRow(
                          icon: Icons.bookmark_remove_outlined,
                          title: 'Забыть группу «${selectedGroup.name}»',
                          subtitle: 'Карточка «Моя группа» исчезнет.',
                          onTap: () =>
                              ref.read(selectedGroupProvider.notifier).clear(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCache(
    BuildContext context,
    WidgetRef ref,
    int? groupId,
  ) async {
    await ref.read(groupsRepositoryProvider).clearCache();
    if (groupId != null) {
      await ref.read(scheduleRepositoryProvider).clearCache(groupId);
      ref.invalidate(semesterScheduleProvider(groupId));
    }
    ref.invalidate(groupsProvider);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Кэш очищен. Данные загрузятся заново.')),
    );
  }

  Future<void> _toggleNotifications(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final controller = ref.read(appSettingsProvider.notifier);

    if (value) {
      if (ref.read(selectedGroupProvider) == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Сначала выберите группу — тогда включим напоминания.',
            ),
          ),
        );
        return;
      }
      final granted =
          await ref
              .read(localNotificationsServiceProvider)
              ?.requestPermissions() ??
          false;
      if (!context.mounted) return;
      if (!granted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Разрешите уведомления в настройках Android, '
              'чтобы получать напоминания.',
            ),
          ),
        );
        return;
      }
    }

    await controller.setNotificationsEnabled(value);
    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Напоминания включены: за 5 минут до пары.'
              : 'Напоминания выключены.',
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ChoiceRow extends StatefulWidget {
  const _ChoiceRow({
    required this.title,
    this.child,
    this.subtitle,
    this.selected = false,
    this.compact = false,
    this.onTap,
  });

  final String title;
  final String? subtitle;

  final Widget? child;

  final bool selected;

  final bool compact;

  final VoidCallback? onTap;

  @override
  State<_ChoiceRow> createState() => _ChoiceRowState();
}

class _ChoiceRowState extends State<_ChoiceRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final canExpand = !widget.compact && widget.child != null;
    final showChild = widget.child != null && (widget.compact || _expanded);

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: widget.compact
                        ? theme.textTheme.bodyMedium
                        : theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                  ),
                  if (widget.subtitle case final subtitle?)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.selected)
              Icon(Icons.check_rounded, size: 20, color: scheme.primary),
            if (canExpand)
              Icon(
                _expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: scheme.onSurfaceVariant,
              ),
          ],
        ),
        if (showChild)
          Padding(
            padding: EdgeInsets.only(
              top: widget.compact ? 0 : 8,
              left: widget.compact ? 4 : 0,
            ),
            child: widget.child!,
          ),
      ],
    );

    final VoidCallback? onTap = widget.compact
        ? widget.onTap
        : canExpand
        ? () => setState(() => _expanded = !_expanded)
        : widget.onTap;

    if (onTap == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: content,
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: content,
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 22, color: scheme.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
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

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 22, color: scheme.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _AccentPicker extends StatelessWidget {
  const _AccentPicker({required this.selected, required this.onSelect});

  final AccentColor selected;
  final ValueChanged<AccentColor> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        for (final accent in AccentColor.values)
          _AccentSwatch(
            accent: accent,
            selected: accent == selected,
            onTap: () => onSelect(accent),
          ),
      ],
    );
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  final AccentColor accent;
  final bool selected;
  final VoidCallback onTap;

  static const double _boxWidth = 72;
  static const double _boxHeight = 40;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: _boxWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: _boxWidth,
                height: _boxHeight,
                decoration: BoxDecoration(
                  color: accent.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? scheme.onSurface : Colors.transparent,
                    width: selected ? 2.5 : 1,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 22,
                      )
                    : null,
              ),
              const SizedBox(height: 6),
              Text(
                accent.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
