import 'package:flutter/material.dart';

import '../../../core/utils/plural.dart';
import '../domain/schedule_builder.dart';
import 'day_start_gap.dart';
import 'lesson_break.dart';
import 'lesson_card.dart';
import 'lesson_group_card.dart';

class DaySection extends StatelessWidget {
  const DaySection({super.key, required this.day, required this.now});

  final DayView day;
  final DateTime now;

  static const List<String> _weekdays = <String>[
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье',
  ];

  static const List<String> _months = <String>[
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  static const List<String> _monthsShort = <String>[
    'янв',
    'фев',
    'мар',
    'апр',
    'мая',
    'июн',
    'июл',
    'авг',
    'сен',
    'окт',
    'ноя',
    'дек',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isToday = day.isToday(now);
    final isWeekend = day.date.weekday >= DateTime.saturday;
    final weekName = _weekdays[day.date.weekday - 1];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _DateBadge(
                day: day.date.day,
                month: _monthsShort[day.date.month - 1],
                isToday: isToday,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          weekName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isToday ? scheme.primary : null,
                          ),
                        ),
                        if (isToday) ...<Widget>[
                          const SizedBox(width: 8),
                          _TodayBadge(color: scheme.primary),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${day.date.day} ${_months[day.date.month - 1]}'
                      ' • ${lessonsLabel(day.slots.length)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (day.isEmpty)
            _NoLessons(isWeekend: isWeekend)
          else ...<Widget>[
            if (day.morningGap case final Duration gap)
              DayStartGap(delay: gap, firstLesson: day.slots.first),
            for (var index = 0; index < day.slots.length; index++) ...<Widget>[
              if (index > 0)
                LessonBreak(
                  date: day.date,
                  previous: day.slots[index - 1].lesson,
                  next: day.slots[index].lesson,
                ),
              _SlotCard(slot: day.slots[index], date: day.date),
            ],
          ],
        ],
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({required this.slot, required this.date});

  final LessonSlot slot;
  final DateTime date;

  @override
  Widget build(BuildContext context) => slot.isSplit
      ? LessonGroupCard(slot: slot, date: date)
      : LessonCard(lesson: slot.lesson, date: date);
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({
    required this.day,
    required this.month,
    required this.isToday,
  });

  final int day;
  final String month;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: isToday ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$day',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isToday ? scheme.onPrimary : scheme.onSurface,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          Text(
            month,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isToday
                  ? scheme.onPrimary.withValues(alpha: 0.9)
                  : scheme.onSurfaceVariant,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayBadge extends StatelessWidget {
  const _TodayBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        'СЕГОДНЯ',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _NoLessons extends StatelessWidget {
  const _NoLessons({required this.isWeekend});

  final bool isWeekend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            isWeekend ? Icons.wb_sunny_outlined : Icons.free_breakfast_outlined,
            size: 18,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            isWeekend ? 'Выходной' : 'Занятий нет',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
