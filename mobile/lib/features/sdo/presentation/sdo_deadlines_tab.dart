import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../data/sdo_exception.dart';
import '../data/sdo_models.dart';
import '../domain/sdo_format.dart';
import 'sdo_providers.dart';

/// Вкладка «Дедлайны»: ближайшие события курсов из календаря Moodle.
class SdoDeadlinesTab extends ConsumerWidget {
  const SdoDeadlinesTab({super.key, this.onOpenUrl});

  final void Function(SdoDeadline deadline)? onOpenUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SdoDeadline>> deadlines = ref.watch(
      sdoDeadlinesProvider,
    );

    return deadlines.when(
      loading: () => const GroupsSkeleton(),
      error: (Object error, _) => ErrorView(
        message: describeSdoError(error),
        onRetry: () => ref.invalidate(sdoDeadlinesProvider),
      ),
      data: (List<SdoDeadline> items) {
        if (items.isEmpty) {
          return const _EmptyDeadlines();
        }
        final List<SdoDeadline> sorted = <SdoDeadline>[...items]
          ..sort(
            (SdoDeadline a, SdoDeadline b) =>
                a.timeSort.compareTo(b.timeSort),
          );
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(sdoDeadlinesProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) =>
                _DeadlineCard(deadline: sorted[index], onOpenUrl: onOpenUrl),
          ),
        );
      },
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  const _DeadlineCard({required this.deadline, this.onOpenUrl});

  final SdoDeadline deadline;
  final void Function(SdoDeadline deadline)? onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool overdue = deadline.overdue;
    final Color accent = overdue ? scheme.error : scheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpenUrl == null ? null : () => onOpenUrl!(deadline),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  overdue
                      ? Icons.warning_amber_rounded
                      : Icons.event_available_outlined,
                  color: accent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      deadline.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (deadline.courseName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          deadline.courseName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Icon(Icons.schedule, size: 14, color: accent),
                        const SizedBox(width: 4),
                        Text(
                          formatDeadline(deadline.timeSort),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (overdue) ...<Widget>[
                          const SizedBox(width: 8),
                          Text(
                            'просрочено',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (deadline.url.isNotEmpty && onOpenUrl != null)
                Icon(
                  Icons.open_in_new_rounded,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDeadlines extends StatelessWidget {
  const _EmptyDeadlines();

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
              Icons.event_available_outlined,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text('Дедлайнов нет', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Ближайших событий в СДО не запланировано.',
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
