import 'dart:async';

import 'package:flutter/material.dart';

/// Прогресс-интервал с самодостаточным таймером.
///
/// Не подписывается на глобальные часы: виджет сам будит себя раз в
/// секунду, **только пока интервал идёт**, и один раз на его границах
/// (начало/конец). В состоянии «пара ещё не началась» или «уже
/// закончилась» виджет полностью статичен и не перерисовывается — это
/// убирает постоянную перерисовку всего экрана расписания каждую секунду.
class TimeProgress extends StatefulWidget {
  const TimeProgress({
    super.key,
    required this.start,
    required this.end,
    required this.leadingBuilder,
    required this.trailing,
    required this.ongoingColor,
    this.idleColor,
    this.showOnlyWhenOngoing = false,
    this.minHeight = 6,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.idleTrackAlpha = 0.16,
    this.ongoingTrackAlpha = 0.3,
  });

  final DateTime start;

  final DateTime end;

  final String Function(DateTime now) leadingBuilder;

  final String trailing;

  final Color ongoingColor;

  final Color? idleColor;

  final bool showOnlyWhenOngoing;

  final double minHeight;
  final BorderRadius borderRadius;

  final double idleTrackAlpha;
  final double ongoingTrackAlpha;

  @override
  State<TimeProgress> createState() => _TimeProgressState();
}

class _TimeProgressState extends State<TimeProgress> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _arm();
  }

  @override
  void didUpdateWidget(TimeProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.start != widget.start || oldWidget.end != widget.end) {
      _arm();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Перепланирует пробуждение:
  /// * интервал идёт — тик каждую секунду (плавный прогресс и отсчёт);
  /// * до начала — один таймер точно на границу начала;
  /// * после конца — ничего, виджет статичен.
  void _arm() {
    _timer?.cancel();
    _timer = null;
    _now = DateTime.now();

    final total = widget.end.difference(widget.start);
    if (total <= Duration.zero) {
      return;
    }
    if (_now.isBefore(widget.start)) {
      _timer = Timer(widget.start.difference(_now), _onWake);
      return;
    }
    if (_now.isBefore(widget.end)) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onWake());
    }
  }

  void _onWake() {
    if (!mounted) return;
    setState(() {});
    _arm();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.end.difference(widget.start);
    final now = _now;

    if (total <= Duration.zero) {
      return const SizedBox.shrink();
    }

    final isStarted = !now.isBefore(widget.start);
    final isOngoing = isStarted && now.isBefore(widget.end);
    if (widget.showOnlyWhenOngoing && !isOngoing) {
      return const SizedBox.shrink();
    }

    final value = !isStarted
        ? 0.0
        : !now.isBefore(widget.end)
        ? 1.0
        : (now.difference(widget.start).inSeconds / total.inSeconds)
              .clamp(0.0, 1.0)
              .toDouble();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = isOngoing
        ? widget.ongoingColor
        : (widget.idleColor ?? widget.ongoingColor);
    final trackAlpha = isOngoing
        ? widget.ongoingTrackAlpha
        : widget.idleTrackAlpha;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          minHeight: widget.minHeight,
          borderRadius: widget.borderRadius,
          color: color,
          backgroundColor: color.withValues(alpha: trackAlpha),
        ),
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                widget.leadingBuilder(now),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              widget.trailing,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}