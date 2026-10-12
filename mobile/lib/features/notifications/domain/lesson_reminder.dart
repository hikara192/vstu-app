import '../../../core/config.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/room.dart';
import '../../schedule/data/schedule_models.dart';
import '../../schedule/domain/schedule_builder.dart';

class LessonReminder {
  const LessonReminder({
    required this.id,
    required this.when,
    required this.title,
    required this.body,
  });

  final int id;
  final DateTime when;
  final String title;
  final String body;
}

class LessonReminderPlanner {
  const LessonReminderPlanner({
    this.lead = AppConfig.lessonReminderLead,
    this.horizonDays = AppConfig.lessonReminderHorizonDays,
  });

  final Duration lead;
  final int horizonDays;

  List<LessonReminder> plan(ScheduleBuilder builder, {required DateTime from}) {
    final start = dateOnly(from);
    final reminders = <LessonReminder>[];
    for (var offset = 0; offset < horizonDays; offset++) {
      final date = start.add(Duration(days: offset));
      if (date.weekday == DateTime.sunday) {
        continue;
      }
      for (final slot in builder.slotsOn(date)) {
        final reminder = _reminderFor(slot, date, from);
        if (reminder != null) {
          reminders.add(reminder);
        }
      }
    }
    return reminders;
  }

  LessonReminder? _reminderFor(LessonSlot slot, DateTime date, DateTime from) {
    final lesson = slot.lesson;
    if (lesson.timeStart.isEmpty) {
      return null;
    }
    final when = moment(date, lesson.timeStart).subtract(lead);
    if (!when.isAfter(from)) {
      return null;
    }
    return LessonReminder(
      id: _idFor(date, lesson.number),
      when: when,
      title: _title(lesson),
      body: _body(lesson),
    );
  }

  static int _idFor(DateTime date, int number) {
    final days =
        dateOnly(date).millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    return days * 1000 + number;
  }

  static String _title(Lesson lesson) {
    final subject = lesson.subject.trim();
    return subject.isEmpty ? 'Занятие №${lesson.number}' : subject;
  }

  String _body(Lesson lesson) {
    final room = roomLabel(location: lesson.room, frame: lesson.frame);
    final parts = <String>[
      'Через ${lead.inMinutes} мин',
      '${lesson.timeStart}–${lesson.timeEnd}',
      if (room.isNotEmpty) room,
      if (lesson.subGroup != allSubgroups) 'подгруппа ${lesson.subGroup}',
    ];
    return parts.join(' • ');
  }
}
