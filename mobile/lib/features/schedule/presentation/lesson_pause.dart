import 'package:flutter/material.dart';

import '../../../core/utils/plural.dart';
import '../../../core/widgets/time_progress.dart';
import '../data/schedule_models.dart';
import '../domain/bells.dart';
import '../domain/schedule_builder.dart';

class LessonPause extends StatelessWidget {
  const LessonPause({
    super.key,
    required this.lesson,
    required this.date,
    this.color,
  });

  final Lesson lesson;
  final DateTime date;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final pause = academicPauseOf(lesson, date);
    if (pause == null) {
      return const SizedBox.shrink();
    }
    final tone = color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return TimeProgress(
      start: pause.$1,
      end: pause.$2,
      ongoingColor: tone,
      idleColor: tone,
      minHeight: 4,
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      leadingBuilder: (_) => 'перерыв ${durationLabel(academicPause)}',
      trailing: '${_hhmm(pause.$1)}–${_hhmm(pause.$2)}',
    );
  }

  static String _hhmm(DateTime time) =>
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
}
