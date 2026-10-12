import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class TimeProgress extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final total = end.difference(start);
    final now = ref.watch(clockProvider);

    if (total <= Duration.zero) {
      return const SizedBox.shrink();
    }

    final isStarted = !now.isBefore(start);
    final isOngoing = isStarted && now.isBefore(end);
    if (showOnlyWhenOngoing && !isOngoing) {
      return const SizedBox.shrink();
    }

    final value = !isStarted
        ? 0.0
        : !now.isBefore(end)
        ? 1.0
        : (now.difference(start).inSeconds / total.inSeconds)
              .clamp(0.0, 1.0)
              .toDouble();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = isOngoing ? ongoingColor : (idleColor ?? ongoingColor);
    final trackAlpha = isOngoing ? ongoingTrackAlpha : idleTrackAlpha;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          minHeight: minHeight,
          borderRadius: borderRadius,
          color: color,
          backgroundColor: color.withValues(alpha: trackAlpha),
        ),
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                leadingBuilder(now),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              trailing,
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
