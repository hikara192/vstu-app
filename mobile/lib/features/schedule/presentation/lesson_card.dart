import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_colors.dart';
import '../../../core/providers.dart';
import '../../../core/utils/room.dart';
import '../data/schedule_models.dart';
import '../domain/schedule_builder.dart';
import 'lesson_parts.dart';
import 'lesson_pause.dart';
import 'lesson_progress.dart';

class LessonCard extends ConsumerWidget {
  const LessonCard({super.key, required this.lesson, required this.date});

  final Lesson lesson;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final appColors = AppColors.of(context);

    final state = ref.watch(
      clockProvider.select(
        (DateTime time) => ScheduleBuilder.stateOf(lesson, date, time),
      ),
    );
    final isFinished = state == LessonState.finished;
    final isOngoing = state == LessonState.ongoing;
    final typeColor = appColors.lessonType(lesson.typeShort);
    final isNumerator = lesson.weekType == LessonWeekType.numerator;
    final typeLabel = lesson.typeShort.isNotEmpty
        ? lesson.typeShort
        : (lesson.type.isNotEmpty ? lesson.type : 'пара');

    final room = roomLabel(location: lesson.room, frame: lesson.frame);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isFinished ? 0.55 : 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          color: isOngoing
              ? scheme.primaryContainer.withValues(alpha: 0.35)
              : scheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isOngoing
                  ? scheme.primary
                  : typeColor.withValues(alpha: 0.3),
              width: isOngoing ? 1.6 : 1,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LessonTimeColumn(lesson: lesson, color: typeColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: <Widget>[
                            LessonTag(
                              text: typeLabel,
                              color: typeColor,
                              tooltip: lesson.type,
                            ),
                            if (lesson.weekType != LessonWeekType.always)
                              LessonTag(
                                text: isNumerator ? 'числ.' : 'знам.',
                                color: appColors.parity(isNumerator),
                                tooltip:
                                    'Только ${lesson.weekType.toLowerCase()} неделя',
                              ),
                            if (isOngoing)
                              LessonOngoingBadge(
                                background: scheme.primary,
                                foreground: scheme.onPrimary,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          lesson.subject,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                            decoration: isFinished
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 14,
                          runSpacing: 6,
                          children: <Widget>[
                            if (room.isNotEmpty)
                              LessonMeta(
                                icon: Icons.place_outlined,
                                text: room,
                              ),
                            if (lesson.subGroup != allSubgroups)
                              LessonMeta(
                                icon: Icons.groups_outlined,
                                text: 'подгруппа ${lesson.subGroup}',
                              ),
                          ],
                        ),
                        if (lesson.teacher != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.person_outline,
                                size: 16,
                                color: scheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  lesson.teacher!.fullName,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        LessonPause(
                          lesson: lesson,
                          date: date,
                          color: typeColor,
                        ),

                        if (isOngoing)
                          LessonProgress(lesson: lesson, date: date),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
