import 'package:flutter/material.dart';

import '../../../app/app_colors.dart';
import '../domain/schedule_builder.dart';

class WeekNavigator extends StatelessWidget {
  const WeekNavigator({
    super.key,
    required this.week,
    required this.showToday,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final WeekInfo week;
  final bool showToday;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parityColor = AppColors.of(context).parity(week.isNumerator);
    final start =
        '${week.startsOn.day}.${week.startsOn.month.toString().padLeft(2, '0')}';
    final end =
        '${week.endsOn.day}.${week.endsOn.month.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Предыдущая неделя',
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: onPrevious,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.25),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: Column(
                key: ValueKey<int>(week.number),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          '${week.number} неделя',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: parityColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          week.parity,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$start – $end',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Следующая неделя',
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: onNext,
          ),
          if (showToday)
            IconButton(
              tooltip: 'Текущая неделя',
              icon: const Icon(Icons.today_rounded),
              onPressed: onToday,
            ),
        ],
      ),
    );
  }
}
