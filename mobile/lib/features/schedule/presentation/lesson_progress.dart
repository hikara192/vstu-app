import 'package:flutter/material.dart';

import '../../../app/app_colors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/plural.dart';
import '../../../core/widgets/time_progress.dart';
import '../data/schedule_models.dart';

class LessonProgress extends StatelessWidget {
  const LessonProgress({super.key, required this.lesson, required this.date});

  final Lesson lesson;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final start = moment(date, lesson.timeStart);
    final end = moment(date, lesson.timeEnd);

    return TimeProgress(
      start: start,
      end: end,
      showOnlyWhenOngoing: true,
      ongoingColor: AppColors.of(context).lessonType(lesson.typeShort),
      leadingBuilder: (now) => remainingLabel(end.difference(now)),
      trailing: 'до ${lesson.timeEnd}',
    );
  }
}
