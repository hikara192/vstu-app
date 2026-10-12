import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../data/sdo_exception.dart';
import '../data/sdo_models.dart';
import 'sdo_providers.dart';
import 'sdo_submission_screen.dart';

/// Вкладка «Задания» курса.
class SdoAssignmentsTab extends ConsumerWidget {
  const SdoAssignmentsTab({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SdoAssignment>> assignments = ref.watch(
      sdoAssignmentsProvider(courseId),
    );

    return assignments.when(
      loading: () => const GroupsSkeleton(),
      error: (Object error, _) => ErrorView(
        message: describeSdoError(error),
        onRetry: () => ref.invalidate(sdoAssignmentsProvider(courseId)),
      ),
      data: (List<SdoAssignment> items) {
        if (items.isEmpty) {
          return const _EmptyAssignments();
        }
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(sdoAssignmentsProvider(courseId).future),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) => _AssignmentCard(
              assignment: items[index],
            ),
          ),
        );
      },
    );
  }
}

class _AssignmentCard extends ConsumerWidget {
  const _AssignmentCard({required this.assignment});

  final SdoAssignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool isOverdue = assignment.isOverdue;

    Color accent = scheme.primary;
    if (isOverdue) accent = scheme.error;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SdoAssignmentScreen(assignment: assignment),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          assignment.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (assignment.dueDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.schedule, size: 12, color: accent),
                                const SizedBox(width: 4),
                                Text(
                                  'Сдать до: ${_formatDateTime(assignment.dueDate!)}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  _StatusChip(status: assignment.status),
                ],
              ),
              if (assignment.description.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  assignment.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final String dd = dt.day.toString().padLeft(2, '0');
    final String mm = dt.month.toString().padLeft(2, '0');
    final String hh = dt.hour.toString().padLeft(2, '0');
    final String mi = dt.minute.toString().padLeft(2, '0');
    return '$dd.$mm ${hh}:$mi';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final SdoSubmissionStatus status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final (Color color, String label) = switch (status) {
      SdoSubmissionStatus.submitted =>
        (scheme.secondaryContainer, 'Отправлено'),
      SdoSubmissionStatus.draft => (scheme.tertiaryContainer, 'Черновик'),
      SdoSubmissionStatus.newSubmission => (scheme.surfaceContainerHighest, 'Не начато'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyAssignments extends StatelessWidget {
  const _EmptyAssignments();

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
              Icons.assignment_outlined,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text('Заданий нет', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Преподаватель пока не добавил заданий в этот курс.',
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

/// Экран конкретного задания: описание, файлы, кнопка отправки.
class SdoAssignmentScreen extends ConsumerWidget {
  const SdoAssignmentScreen({super.key, required this.assignment});

  final SdoAssignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(assignment.name)),
      body: SdoSubmissionScreen(
        assignment: assignment,
        courseId: assignment.courseId,
      ),
    );
  }
}