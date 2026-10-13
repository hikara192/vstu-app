import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/utils/dates.dart';
import '../../../core/utils/plural.dart';
import '../data/schedule_models.dart';
import '../domain/schedule_builder.dart';

/// Ключ заполняющейся части бара (для виджет-тестов).
const Key lessonTimelineFillKey = Key('lesson-timeline-fill');

/// Ключ трека бара (для виджет-тестов).
const Key lessonTimelineTrackKey = Key('lesson-timeline-track');

/// Ключ разделителя перерыва на баре (для виджет-тестов).
const Key lessonTimelineDividerKey = Key('lesson-timeline-divider');

/// Единый прогресс-бар времени пары.
///
/// Показывается только пока пара идёт. Бар заполняется к началу перерыва,
/// затем замирает на разделителе: на время перерыва заливка становится
/// серой, а вместо остатка показывается таймер обратного отсчёта (mm:ss).
/// После перерыва заполнение снова растёт к концу пары. У пар без перерыва
/// разделитель и остановка отсутствуют.
class LessonTimeline extends StatefulWidget {
  const LessonTimeline({
    super.key,
    required this.lesson,
    required this.date,
    this.color,
    this.now,
  });

  final Lesson lesson;

  final DateTime date;

  /// Цвет заливки во время занятий (обычно цвет типа пары).
  final Color? color;

  /// Инжектируемые «часы» для детерминированных тестов.
  final DateTime Function()? now;

  @override
  State<LessonTimeline> createState() => _LessonTimelineState();
}

class _LessonTimelineState extends State<LessonTimeline> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _arm();
  }

  @override
  void didUpdateWidget(LessonTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson != widget.lesson ||
        oldWidget.date != widget.date ||
        oldWidget.now != widget.now) {
      _arm();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Планирует пробуждение, как в [TimeProgress]: пока пара идёт — тик
  /// раз в секунду, до начала — один таймер ровно на границу, после кон
  /// виджет статичен (и не показывается вовсе).
  void _arm() {
    _timer?.cancel();
    _timer = null;
    _now = (widget.now ?? DateTime.now)();

    final start = moment(widget.date, widget.lesson.timeStart);
    final end = moment(widget.date, widget.lesson.timeEnd);
    if (end.difference(start) <= Duration.zero) {
      return;
    }
    if (_now.isBefore(start)) {
      _timer = Timer(start.difference(_now), _onWake);
      return;
    }
    if (_now.isBefore(end)) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onWake());
    }
  }

  void _onWake() {
    if (!mounted) return;
    setState(() {});
    _arm();
  }

  /// Доля [time] на отрезке [start]–[end].
  static double _fraction(DateTime start, Duration total, DateTime time) {
    final elapsed = time.difference(start);
    return (elapsed.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0).toDouble();
  }

  static String _hhmm(DateTime time) =>
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

  /// Таймер перерыва в формате m:ss, например «2:34».
  static String _mmss(Duration left) {
    final seconds = left.inSeconds < 0 ? 0 : left.inSeconds;
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final lesson = widget.lesson;
    final start = moment(widget.date, lesson.timeStart);
    final end = moment(widget.date, lesson.timeEnd);
    final total = end.difference(start);
    final pause = academicPauseOf(lesson, widget.date);

    // Несуществующий интервал или пара не идёт — не рисуем ничего.
    if (total <= Duration.zero || _now.isBefore(start) || !_now.isBefore(end)) {
      return const SizedBox.shrink();
    }

    final lessonColor = widget.color ?? scheme.primary;
    final inBreak = pause != null && !_now.isBefore(pause.$1) && _now.isBefore(pause.$2);
    final fillColor = inBreak ? scheme.onSurfaceVariant : lessonColor;

    final value = pause == null || _now.isBefore(pause.$1) || !_now.isBefore(pause.$2)
        ? _fraction(start, total, _now)
        : _fraction(start, total, pause.$1); // перерыв: замерли на разделителе

    final String leading = pause != null && inBreak
        ? 'перерыв · ${_mmss(pause.$2.difference(_now))}'
        : remainingLabel(end.difference(_now));
    final String trailing = pause != null && inBreak
        ? 'до ${_hhmm(pause.$2)}'
        : 'до ${lesson.timeEnd}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 6,
          key: lessonTimelineTrackKey,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fillColor.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Stack(
              children: <Widget>[
                // Заполнение. heightFactor задаём, иначе у DecoratedBox без
                // ребёнка высота схлопывается до нуля и бар выглядит пустым.
                FractionallySizedBox(
                  key: lessonTimelineFillKey,
                  widthFactor: value,
                  heightFactor: 1,
                  alignment: Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
                // Разделитель на отметке начала перерыва. Позиционируем
                // выравниванием (без LayoutBuilder), чтобы виджет умел
                // сообщать intrinsic-размеры: карточка пары обёрнута в
                // IntrinsicHeight, а LayoutBuilder их не поддерживает.
                if (pause != null)
                  Align(
                    alignment: Alignment(
                      2 * _fraction(start, total, pause.$1) - 1,
                      0,
                    ),
                    child: Container(
                      key: lessonTimelineDividerKey,
                      width: 2,
                      height: 6,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.9),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                leading,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              trailing,
              style: theme.textTheme.labelSmall?.copyWith(
                color: fillColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}