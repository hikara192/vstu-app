import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/utils/dates.dart';
import '../domain/schedule_builder.dart';
import 'day_section.dart';
import 'day_strip.dart';

class WeekContent extends StatefulWidget {
  const WeekContent({
    super.key,
    required this.builder,
    required this.targetDate,
    required this.now,
    required this.weekOffset,
    required this.onRefresh,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  final ScheduleBuilder builder;
  final DateTime targetDate;
  final DateTime now;
  final int weekOffset;
  final Future<void> Function() onRefresh;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  static const double swipeVelocity = 220;

  static const Duration dayScrollDuration = Duration(milliseconds: 320);

  @override
  State<WeekContent> createState() => _WeekContentState();
}

class _WeekContentState extends State<WeekContent> {
  final List<GlobalKey> _dayKeys = List<GlobalKey>.generate(
    7,
    (_) => GlobalKey(),
  );
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _listKey = GlobalKey();

  final ValueNotifier<int> _activeDay = ValueNotifier<int>(0);

  bool _isAutoScrolling = false;

  int _scrollRequest = 0;

  static const double _dayTopTolerance = 1;

  @override
  void initState() {
    super.initState();
    _activeDay.value = _todayIndex();
    _scrollController.addListener(_syncActiveDayWithScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _jumpToDay(_activeDay.value);
    });
  }

  @override
  void didUpdateWidget(covariant WeekContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.weekOffset != widget.weekOffset) {
      _activeDay.value = _todayIndex();
      _isAutoScrolling = true;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      _isAutoScrolling = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _jumpToDay(_activeDay.value);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_syncActiveDayWithScroll);
    _scrollController.dispose();
    _activeDay.dispose();
    super.dispose();
  }

  int _todayIndex() {
    final week = widget.builder.weekOf(widget.targetDate);
    final today = dateOnly(widget.now);
    final index = today.difference(week.startsOn).inDays;
    return index >= 0 && index < 7 ? index : 0;
  }

  void _syncActiveDayWithScroll() {
    if (_isAutoScrolling) return;
    _activeDay.value = _dayIndexAtViewportTop();
  }

  int _dayIndexAtViewportTop() {
    final viewportBox =
        _listKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewportBox == null || !viewportBox.hasSize) {
      return _activeDay.value;
    }
    final viewportTop = viewportBox.localToGlobal(Offset.zero).dy;

    var index = 0;
    for (var day = 0; day < _dayKeys.length; day++) {
      final box =
          _dayKeys[day].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;

      if (box.localToGlobal(Offset.zero).dy > viewportTop + _dayTopTolerance) {
        break;
      }
      index = day;
    }
    return index;
  }

  void _jumpToDay(int index) {
    _scrollToDaySection(index, duration: Duration.zero);
  }

  void _scrollToDay(int index) {
    _activeDay.value = index;
    _scrollToDaySection(index, duration: WeekContent.dayScrollDuration);
  }

  void _scrollToDaySection(int index, {required Duration duration}) {
    final dayContext = _dayKeys[index].currentContext;
    if (dayContext == null) {
      return;
    }
    final request = ++_scrollRequest;
    _isAutoScrolling = true;
    unawaited(
      Scrollable.ensureVisible(
        dayContext,
        duration: duration,
        curve: Curves.easeOutCubic,
        alignment: 0,
      ).whenComplete(() {
        if (request == _scrollRequest) {
          _isAutoScrolling = false;
        }
      }),
    );
  }

  void _handleSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -WeekContent.swipeVelocity) {
      widget.onNextWeek();
    } else if (velocity > WeekContent.swipeVelocity) {
      widget.onPreviousWeek();
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = widget.builder.weekView(widget.targetDate);
    final hasLessons = days.any((day) => !day.isEmpty);

    return Column(
      children: <Widget>[
        ValueListenableBuilder<int>(
          valueListenable: _activeDay,
          builder: (BuildContext context, int activeDay, Widget? child) =>
              DayStrip(
                days: days,
                now: widget.now,
                activeIndex: activeDay,
                onSelect: _scrollToDay,
              ),
        ),
        Expanded(
          child: GestureDetector(
            key: _listKey,
            onHorizontalDragEnd: _handleSwipe,
            child: RefreshIndicator(
              onRefresh: widget.onRefresh,
              child: hasLessons
                  ? SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: 24 + MediaQuery.paddingOf(context).bottom,
                      ),
                      child: Column(
                        children: <Widget>[
                          for (var index = 0; index < days.length; index++)
                            DaySection(
                              key: _dayKeys[index],
                              day: days[index],
                              now: widget.now,
                            ),
                        ],
                      ),
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      children: const <Widget>[_WeekEmptyCard()],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeekEmptyCard extends StatelessWidget {
  const _WeekEmptyCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.event_available_outlined,
              size: 40,
              color: scheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'На этой неделе занятий нет',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Возможно, идут каникулы или сессия. '
              'Полистайте недели стрелками в шапке.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
