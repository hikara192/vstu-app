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

class LessonGroupCard extends ConsumerWidget {
  const LessonGroupCard({super.key, required this.slot, required this.date});

  final LessonSlot slot;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final appColors = AppColors.of(context);

    final lesson = slot.lesson;

    final state = ref.watch(
      clockProvider.select(
        (DateTime time) => ScheduleBuilder.stateOf(lesson, date, time),
      ),
    );
    final isFinished = state == LessonState.finished;
    final isOngoing = state == LessonState.ongoing;
    final typeColor = appColors.lessonType(lesson.typeShort);

    final commonType = slot.commonType;
    final commonWeekType = slot.commonWeekType;
    final showTypeInRow = commonType == null;
    final showParityInRow =
        commonWeekType == null || commonWeekType == LessonWeekType.always;
    final commonIsNumerator = commonWeekType == LessonWeekType.numerator;
    final typeLabel = commonType == null || commonType.isEmpty
        ? (lesson.type.isNotEmpty ? lesson.type : 'пара')
        : commonType;

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
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (commonType != null || isOngoing)
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: <Widget>[
                              if (commonType != null)
                                LessonTag(
                                  text: typeLabel,
                                  color: typeColor,
                                  tooltip: lesson.type,
                                ),
                              if (!showParityInRow)
                                LessonTag(
                                  text: commonIsNumerator ? 'числ.' : 'знам.',
                                  color: appColors.parity(commonIsNumerator),
                                  tooltip:
                                      'Только ${commonWeekType.toLowerCase()} неделя',
                                ),
                              if (isOngoing)
                                LessonOngoingBadge(
                                  background: scheme.primary,
                                  foreground: scheme.onPrimary,
                                ),
                            ],
                          ),
                        for (
                          var index = 0;
                          index < slot.variants.length;
                          index++
                        )
                          _VariantRow(
                            lesson: slot.variants[index],
                            isFinished: isFinished,
                            showDivider: index > 0,
                            showType: showTypeInRow,
                            showParity: showParityInRow,
                          ),

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

class _VariantRow extends StatelessWidget {
  const _VariantRow({
    required this.lesson,
    required this.isFinished,
    required this.showDivider,
    required this.showType,
    required this.showParity,
  });

  final Lesson lesson;
  final bool isFinished;
  final bool showDivider;
  final bool showType;
  final bool showParity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final appColors = AppColors.of(context);
    final typeColor = appColors.lessonType(lesson.typeShort);
    final isNumerator = lesson.weekType == LessonWeekType.numerator;
    final room = roomLabel(location: lesson.room, frame: lesson.frame);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showDivider) Divider(height: 17, color: _dividerColor(theme)),
        Row(
          children: <Widget>[
            _SubgroupLabel(lesson: lesson),
            if (showType) ...<Widget>[
              LessonTag(
                text: lesson.typeShort.isNotEmpty ? lesson.typeShort : 'пара',
                color: typeColor,
                tooltip: lesson.type,
              ),
            ],
            if (showParity &&
                lesson.weekType != LessonWeekType.always) ...<Widget>[
              LessonTag(
                text: isNumerator ? 'числ.' : 'знам.',
                color: appColors.parity(isNumerator),
                tooltip: 'Только ${lesson.weekType.toLowerCase()} неделя',
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          lesson.subject,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.25,
            decoration: isFinished ? TextDecoration.lineThrough : null,
            decorationColor: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 14,
          runSpacing: 4,
          children: <Widget>[
            if (room.isNotEmpty)
              LessonMeta(icon: Icons.place_outlined, text: room),
            if (lesson.teacher != null)
              LessonMeta(
                icon: Icons.person_outline,
                text: lesson.teacher!.fullName,
              ),
          ],
        ),
      ],
    );
  }

  static Color _dividerColor(ThemeData theme) =>
      theme.colorScheme.outlineVariant.withValues(alpha: 0.6);
}

class _SubgroupLabel extends StatelessWidget {
  const _SubgroupLabel({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCommon = lesson.subGroup == allSubgroups;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isCommon ? 'для всех' : 'подгруппа ${lesson.subGroup}',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
