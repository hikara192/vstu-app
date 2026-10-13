import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/utils/plural.dart';
import '../domain/schedule_builder.dart';

/// Ширина одного чипа дня.
const double _chipWidth = 48;

/// Суммарный промежуток между чипами (по 3 с каждой стороны).
const double _chipGap = 6;

/// Шаг сетки чипов (ширина + промежуток): центры соседних чипов.
const double _chipStep = _chipWidth + _chipGap;

/// Приблизительная высота чипа до первого замера (после лаяута замер
/// заменяется точным значением).
const double _chipDefaultHeight = 56;

/// Ключ анимированной «таблетки» активного дня — используется в тестах
/// для проверки её положения.
const Key dayStripPillKey = Key('day-strip-active-pill');

class DayStrip extends StatefulWidget {
  const DayStrip({
    super.key,
    required this.days,
    required this.now,
    required this.activeIndex,
    required this.onSelect,
  });

  final List<DayView> days;
  final DateTime now;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  State<DayStrip> createState() => _DayStripState();
}

class _DayStripState extends State<DayStrip> {
  static const List<String> _shortWeekdays = <String>[
    'Пн',
    'Вт',
    'Ср',
    'Чт',
    'Пт',
    'Сб',
    'Вс',
  ];

  static const double _edgePadding = 8;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _viewportKey = GlobalKey();
  final List<GlobalKey> _chipKeys = List<GlobalKey>.generate(
    7,
    (_) => GlobalKey(),
  );

  /// Высота «таблетки»: сначала приблизительная, после первого лаяута —
  /// точная высота чипа.
  double _pillHeight = _chipDefaultHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealActiveChip());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Пересчитываем высоту таблетки при первом лаяуте и при изменении
    // масштаба текста/геометрии.
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncPillHeight());
  }

  @override
  void didUpdateWidget(covariant DayStrip oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activeIndex != widget.activeIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _revealActiveChip());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _revealActiveChip() {
    if (!mounted) return;
    final chipContext = _chipKeys[widget.activeIndex].currentContext;
    final viewportBox =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    final chipBox = chipContext?.findRenderObject() as RenderBox?;
    if (chipContext == null ||
        viewportBox == null ||
        chipBox == null ||
        !chipBox.hasSize) {
      return;
    }

    final viewportLeft = viewportBox.localToGlobal(Offset.zero).dx;
    final chipLeft = chipBox.localToGlobal(Offset.zero).dx;
    final chipRight = chipLeft + chipBox.size.width;
    final viewportRight = viewportLeft + viewportBox.size.width;
    final isFullyVisible =
        chipLeft >= viewportLeft + _edgePadding &&
        chipRight <= viewportRight - _edgePadding;
    if (isFullyVisible) return;

    unawaited(
      Scrollable.ensureVisible(
        chipContext,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: 0.5,
      ),
    );
  }

  /// Сдвиг «таблетки» под чип с заданным индексом. Смещение задаётся в долях
  /// собственной ширины таблетки ([AnimatedSlide] умножает offset на размер).
  Offset _pillOffsetFor(int index) =>
      Offset((index * _chipStep + _chipGap / 2) / _chipWidth, 0);

  void _syncPillHeight() {
    if (!mounted) return;
    final box =
        _chipKeys[widget.activeIndex].currentContext?.findRenderObject()
            as RenderBox?;
    if (box == null || !box.hasSize) return;
    final height = box.size.height;
    if ((height - _pillHeight).abs() < 0.5) return;
    setState(() => _pillHeight = height);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          bottom: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        key: _viewportKey,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Stack(
          children: <Widget>[
            // Таблетка активного дня рисуется ПОД чипами (непозиционные
            // дети Stack рисуются в порядке списка) и едет между ними.
            AnimatedSlide(
              offset: _pillOffsetFor(widget.activeIndex),
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              child: _ActiveDayPill(
                key: dayStripPillKey,
                width: _chipWidth,
                height: _pillHeight,
                color: scheme.primary,
              ),
            ),
            Row(
              children: <Widget>[
                for (var index = 0; index < widget.days.length; index++)
                  Padding(
                    key: _chipKeys[index],
                    padding: const EdgeInsets.symmetric(
                      horizontal: _chipGap / 2,
                    ),
                    child: DayChip(
                      label: _shortWeekdays[index],
                      date: widget.days[index].date.day,
                      lessons: widget.days[index].slots.length,
                      isToday: widget.days[index].isToday(widget.now),
                      isActive: index == widget.activeIndex,
                      onTap: () => widget.onSelect(index),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Скруглённая «таблетка», подкладываемая под активный чип дня.
class _ActiveDayPill extends StatelessWidget {
  const _ActiveDayPill({
    super.key,
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

class DayChip extends StatelessWidget {
  const DayChip({
    super.key,
    required this.label,
    required this.date,
    required this.lessons,
    required this.isToday,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final int date;
  final int lessons;
  final bool isToday;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final background = isActive
        ? Colors.transparent
        : isToday
        ? scheme.primaryContainer
        : scheme.surfaceContainerHighest.withValues(alpha: 0.6);
    final foreground = isActive
        ? scheme.onPrimary
        : isToday
        ? scheme.onPrimaryContainer
        : scheme.onSurfaceVariant;
    final dots = lessons > 3 ? 3 : lessons;

    return Tooltip(
      message: lessonsLabel(lessons),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _chipWidth,
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : scheme.outlineVariant.withValues(alpha: 0.7),
            ),
          ),
          child: Column(
            children: <Widget>[
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '$date',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (dots == 0)
                      Container(
                        width: 10,
                        height: 2,
                        decoration: BoxDecoration(
                          color: foreground.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      )
                    else
                      for (var i = 0; i < dots; i++)
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: foreground,
                            shape: BoxShape.circle,
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
