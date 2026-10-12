import 'package:flutter/material.dart';

import '../../../core/utils/dates.dart';
import '../../../core/utils/plural.dart';
import '../../../core/widgets/time_progress.dart';
import '../data/schedule_models.dart';

class LessonBreak extends StatelessWidget {
  const LessonBreak({
    super.key,
    required this.date,
    required this.previous,
    required this.next,
  });

  final DateTime date;
  final Lesson previous;
  final Lesson next;

  @override
  Widget build(BuildContext context) {
    final start = moment(date, previous.timeEnd);
    final end = moment(date, next.timeStart);
    final total = end.difference(start);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TimeProgress(
        start: start,
        end: end,
        ongoingColor: Theme.of(context).colorScheme.primary,
        idleColor: Theme.of(context).colorScheme.onSurfaceVariant,
        minHeight: 4,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        leadingBuilder: (_) => 'перерыв ${durationLabel(total)}',
        trailing: 'до ${next.timeStart}',
      ),
    );
  }
}
