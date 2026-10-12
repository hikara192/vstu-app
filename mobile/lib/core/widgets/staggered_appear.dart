import 'dart:async';

import 'package:flutter/material.dart';

class StaggeredAppear extends StatefulWidget {
  const StaggeredAppear({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = const Duration(milliseconds: 260),
  });

  final Widget child;

  final int index;

  final Duration duration;

  static const Duration maxDelay = Duration(milliseconds: 180);

  static const Duration step = Duration(milliseconds: 24);

  @override
  State<StaggeredAppear> createState() => _StaggeredAppearState();
}

class _StaggeredAppearState extends State<StaggeredAppear>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void initState() {
    super.initState();
    final delay = StaggeredAppear.step * widget.index.clamp(0, 8);
    unawaited(
      Future<void>.delayed(
        delay > StaggeredAppear.maxDelay ? StaggeredAppear.maxDelay : delay,
        () {
          if (mounted) {
            _controller.forward();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(_curve),
        child: widget.child,
      ),
    );
  }
}
