import '../../../core/utils/dates.dart';
import '../data/schedule_models.dart';
import 'bells.dart';

enum LessonState { upcoming, ongoing, finished }

const int uniWeekCycleLength = 4;

class WeekInfo {
  const WeekInfo({
    required this.number,
    required this.startsOn,
    required this.endsOn,
  });

  final int number;
  final DateTime startsOn;
  final DateTime endsOn;

  bool get isNumerator => number.isOdd;

  String get parity =>
      isNumerator ? LessonWeekType.numerator : LessonWeekType.denominator;

  @override
  String toString() => 'WeekInfo($number, $parity)';
}

class LessonSlot {
  LessonSlot({required this.number, required List<Lesson> variants})
    : variants = List.unmodifiable(variants);

  final int number;

  final List<Lesson> variants;

  Lesson get lesson => variants.first;

  bool get isSplit => variants.length > 1;

  String get timeStart => lesson.timeStart;
  String get timeEnd => lesson.timeEnd;

  (DateTime, DateTime)? pause(DateTime date) => academicPauseOf(lesson, date);

  String? get commonType {
    String labelOf(Lesson lesson) =>
        lesson.typeShort.isNotEmpty ? lesson.typeShort : lesson.type;
    return _commonOf(labelOf);
  }

  String? get commonWeekType => _commonOf((Lesson lesson) => lesson.weekType);

  String? _commonOf(String Function(Lesson lesson) label) {
    final first = label(lesson);
    for (final variant in variants.skip(1)) {
      if (label(variant) != first) {
        return null;
      }
    }
    return first;
  }

  @override
  String toString() => 'LessonSlot($number, ${variants.length} вариантов)';
}

class DayView {
  const DayView({required this.date, required this.week, required this.slots});

  final DateTime date;
  final WeekInfo week;

  final List<LessonSlot> slots;

  bool get isEmpty => slots.isEmpty;

  Duration? get morningGap {
    if (slots.isEmpty) return null;
    final firstStart = slots.first.timeStart;
    if (firstStart.isEmpty) {
      return null;
    }
    final gap = moment(date, firstStart).difference(moment(date, dayStart));
    return gap > Duration.zero ? gap : null;
  }

  bool isToday(DateTime now) =>
      date.year == now.year && date.month == now.month && date.day == now.day;

  @override
  String toString() => 'DayView($date, ${slots.length} пар)';
}

(DateTime, DateTime)? academicPauseOf(Lesson lesson, DateTime date) {
  if (lesson.timeStart.isEmpty || lesson.timeEnd.isEmpty) {
    return null;
  }
  final start = moment(date, lesson.timeStart);
  final end = moment(date, lesson.timeEnd);
  if (end.difference(start) < minLessonWithPause) {
    return null;
  }
  return (start.add(academicHour), start.add(academicHour).add(academicPause));
}

class ScheduleBuilder {
  ScheduleBuilder({
    required DateTime semesterStart,
    required List<Lesson> lessons,
    this.weekAnchor,
  }) : _semesterStart = dateOnly(semesterStart),
       _lessons = List.unmodifiable(<Lesson>[...lessons]..sort(compareLessons));

  final DateTime _semesterStart;
  final List<Lesson> _lessons;

  final WeekCycleAnchor? weekAnchor;

  List<Lesson> get lessons => _lessons;

  DateTime get semesterStart => _semesterStart;

  WeekInfo weekOf(DateTime date) {
    final monday = mondayOf(date);
    final semesterMonday = mondayOf(_semesterStart);

    final index = monday.difference(semesterMonday).inDays ~/ 7;

    final offset = index < 0 ? 0 : index;
    final startsOn = semesterMonday.add(Duration(days: 7 * offset));
    return WeekInfo(
      number: _cycleNumber(monday, offset),
      startsOn: startsOn,
      endsOn: startsOn.add(const Duration(days: 6)),
    );
  }

  int _cycleNumber(DateTime monday, int semesterWeekIndex) {
    final anchor = weekAnchor;
    if (anchor == null) return (semesterWeekIndex % uniWeekCycleLength) + 1;
    final weeksFromAnchor =
        monday.difference(mondayOf(anchor.date)).inDays ~/ 7;
    return ((anchor.number - 1 + weeksFromAnchor) % uniWeekCycleLength) + 1;
  }

  List<Lesson> lessonsOn(DateTime date) {
    final week = weekOf(date);
    return [
      for (final lesson in _lessons)
        if (occursOn(lesson, date, week)) lesson,
    ];
  }

  List<LessonSlot> slotsOn(DateTime date) {
    final lessons = lessonsOn(date);
    if (lessons.isEmpty) {
      return const <LessonSlot>[];
    }
    final byNumber = <int, List<Lesson>>{};
    for (final lesson in lessons) {
      byNumber.putIfAbsent(lesson.number, () => <Lesson>[]).add(lesson);
    }
    return <LessonSlot>[
      for (final number in byNumber.keys.toList()..sort())
        LessonSlot(number: number, variants: _mergeVariants(byNumber[number]!)),
    ];
  }

  DayView dayView(DateTime date) =>
      DayView(date: dateOnly(date), week: weekOf(date), slots: slotsOn(date));

  List<DayView> weekView(DateTime date) {
    final week = weekOf(date);
    return [
      for (var offset = 0; offset < 7; offset++) _dayOfWeek(week, offset),
    ];
  }

  static bool occursOn(Lesson lesson, DateTime date, WeekInfo week) {
    final day = dateOnly(date);
    return lesson.dayOfWeek == day.weekday - 1 &&
        !day.isBefore(dateOnly(lesson.dateStart)) &&
        !day.isAfter(dateOnly(lesson.dateEnd)) &&
        (lesson.weekType == LessonWeekType.always ||
            lesson.weekType == week.parity);
  }

  static bool isFinished(Lesson lesson, DateTime date, DateTime now) =>
      stateOf(lesson, date, now) == LessonState.finished;

  static bool isOngoing(Lesson lesson, DateTime date, DateTime now) =>
      stateOf(lesson, date, now) == LessonState.ongoing;

  static LessonState stateOf(Lesson lesson, DateTime date, DateTime now) {
    final start = moment(date, lesson.timeStart);
    final end = moment(date, lesson.timeEnd);
    if (now.isBefore(start)) {
      return LessonState.upcoming;
    }
    return now.isBefore(end) ? LessonState.ongoing : LessonState.finished;
  }

  static String timeRange(Lesson lesson) =>
      '${lesson.timeStart}–${lesson.timeEnd}';

  static int compareLessons(Lesson a, Lesson b) {
    final byNumber = a.number.compareTo(b.number);
    if (byNumber != 0) {
      return byNumber;
    }
    final bySubgroup = subgroupOrder(a.subGroup)
        .compareTo(subgroupOrder(b.subGroup));
    return bySubgroup != 0 ? bySubgroup : a.subject.compareTo(b.subject);
  }

  static int subgroupOrder(String subgroup) {
    if (subgroup == allSubgroups) {
      return -1;
    }
    return int.tryParse(subgroup) ?? 0;
  }

  DayView _dayOfWeek(WeekInfo week, int offset) {
    final date = week.startsOn.add(Duration(days: offset));
    return DayView(date: date, week: week, slots: slotsOn(date));
  }

  static List<Lesson> _mergeVariants(List<Lesson> raw) {
    final merged = <_VariantKey, Lesson>{};
    final order = <_VariantKey>[];
    for (final lesson in raw) {
      final key = _variantKeyOf(lesson);
      final previous = merged[key];
      if (previous == null) {
        merged[key] = lesson;
        order.add(key);
      } else {
        merged[key] = _withWiderDates(previous, lesson);
      }
    }
    final variants = <Lesson>[for (final key in order) merged[key]!];
    variants.sort(compareLessons);
    return variants;
  }

  static _VariantKey _variantKeyOf(Lesson lesson) => (
    subject: lesson.subject,
    type: lesson.type,
    typeShort: lesson.typeShort,
    subGroup: lesson.subGroup,
    room: lesson.room,
    frame: lesson.frame,
    teacher: lesson.teacher == null
        ? null
        : '${lesson.teacher!.id}:${lesson.teacher!.fullName}',
    weekType: lesson.weekType,
  );

  static Lesson _withWiderDates(Lesson first, Lesson second) {
    final start = first.dateStart.isBefore(second.dateStart)
        ? first.dateStart
        : second.dateStart;
    final end = first.dateEnd.isAfter(second.dateEnd)
        ? first.dateEnd
        : second.dateEnd;
    if (start == first.dateStart && end == first.dateEnd) {
      return first;
    }
    return first.copyWith(dateStart: start, dateEnd: end);
  }
}

typedef _VariantKey = ({
  String subject,
  String type,
  String typeShort,
  String subGroup,
  String room,
  int? frame,
  String? teacher,
  String weekType,
});
